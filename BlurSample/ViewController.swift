//
//  ViewController.swift
//  BlurSample
//
//  Created by Hiroki Yoshifuji on 2015/08/26.
//  Copyright (c) 2015年 Hiroki Yoshifuji. All rights reserved.
//

import UIKit
import SwiftColorPicker
import HexColors

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurRadiusSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var colorAlphaSlider: UISlider!
    @IBOutlet weak var blurRadiusTextField: UITextField!
    @IBOutlet weak var saturationTextField: UITextField!
    @IBOutlet weak var colorAlphaTextField: UITextField!
    
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet var colorWell:ColorWell!
    @IBOutlet var colorPicker:ColorPicker!
    @IBOutlet var huePicker:HuePicker!
    var pickerController:ColorPickerController!
    
    func colorToString(color: UIColor) -> String {
        let colorTextList = (color.description as NSString).substringFromIndex(count("UIDeviceRGBColorSpace "))
        let colorList = colorTextList.componentsSeparatedByString(" ")
        var colorText = NSString(format: "#%02x%02x%02x",
            Int((colorList[0] as NSString).floatValue * 255),
            Int((colorList[1] as NSString).floatValue * 255),
            Int((colorList[2] as NSString).floatValue * 255))
        return colorText.uppercaseString as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerController = ColorPickerController(svPickerView: colorPicker!, huePickerView: huePicker!, colorWell: colorWell!)
        pickerController.color = UIColor(white: 1, alpha: 0.3)
        pickerController.onColorChange = {(color:UIColor, finished) in

            self.colorTextField.text = self.colorToString(color)
            
            self.updateImage()
        }

        
        colorTextField.text = colorToString(pickerController.color!)
        updateImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func valueChangedBlurRadiusSlider(sender: AnyObject) {
        blurRadiusTextField.text = "\(blurRadiusSlider.value)"
        updateImage()
        
    }
    
    @IBAction func valueChangedSaturationSlider(sender: AnyObject) {
        saturationTextField.text = "\(saturationSlider.value)"
        updateImage()
    }
    @IBAction func valueChangedColorAlphaSlider(sender: AnyObject) {
        colorAlphaTextField.text = "\(colorAlphaSlider.value)"
        updateImage()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == colorTextField {
            pickerController.color = UIColor(hexString: textField.text)
            updateImage()
            return
        }
        let value = NSString(string: textField.text).floatValue
        var slider = textField == blurRadiusTextField ? blurRadiusSlider : textField == saturationTextField ? saturationSlider : colorAlphaSlider
        
        if slider.minimumValue <= value && value <= slider.maximumValue {
            slider.value = value
            
            updateImage()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func updateImage() {
        var color = pickerController.color?.colorWithAlphaComponent(CGFloat(colorAlphaSlider.value))
        imageView.image = UIImage(named: "login")!.applyBlurWithRadius(CGFloat(blurRadiusSlider.value), tintColor: color, saturationDeltaFactor: CGFloat(saturationSlider.value), maskImage: nil)
    }
}

