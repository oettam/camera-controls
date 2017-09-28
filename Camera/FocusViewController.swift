//
//  FocusViewController.swift
//  Camera
//
//  Created by Matteo Caldari on 06/02/15.
//  Copyright (c) 2015 Matteo Caldari. All rights reserved.
//

import UIKit
import AVFoundation

class FocusViewController: UIViewController, CameraControlsViewControllerProtocol, CameraSettingValueObserver {

	@IBOutlet var modeSwitch:UISwitch!
	@IBOutlet var slider:UISlider!
	
	var cameraController:CameraController? {
		willSet {
			if let cameraController = cameraController {
				cameraController.unregisterObserver(observer: self, property: CameraControlObservableSettingLensPosition)
			}
		}
		didSet {
			if let cameraController = cameraController {
				cameraController.registerObserver(observer: self, property: CameraControlObservableSettingLensPosition)
			}
		}
	}
	
	override func viewDidLoad() {
		setInitialValues()
	}
	
	
	@IBAction func sliderDidChangeValue(sender:UISlider) {
        cameraController?.lockFocusAtLensPosition(lensPosition: CGFloat(sender.value))
	}
	
	
	@IBAction func modeSwitchValueChanged(sender:UISwitch) {
        if sender.isOn {
			cameraController?.enableContinuousAutoFocus()
		}
		else {
            cameraController?.lockFocusAtLensPosition(lensPosition: CGFloat(self.slider.value))
		}
        slider.isEnabled = !sender.isOn
	}

	
	func cameraSetting(setting:String, valueChanged value:AnyObject) {
		if setting == CameraControlObservableSettingLensPosition {
			if let lensPosition = value as? Float {
				slider.value = lensPosition
			}
		}
	}

	
	func setInitialValues() {
		if isViewLoaded && cameraController != nil {
			if let autoFocus = cameraController?.isContinuousAutoFocusEnabled() {
				modeSwitch.isOn = autoFocus
				slider.isEnabled = !autoFocus
			}
			
			if let currentLensPosition = cameraController?.currentLensPosition() {
				slider.value = currentLensPosition
			}
		}
	}
}
