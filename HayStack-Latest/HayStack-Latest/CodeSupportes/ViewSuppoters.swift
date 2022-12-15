//
//  ViewSuppoters.swift
//  DeltaServices
//
//  Created by rajesh gandru on 01/04/21.
//16.029149,79.943052

import Foundation
import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}
extension CALayer {
    func applyCornerRadiusShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        cornerRadiusValue: CGFloat = 0)
    {
        cornerRadius = cornerRadiusValue
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
extension UIView {
func addBottomShadow() {
    layer.masksToBounds = false
    layer.shadowRadius = 1
    layer.shadowOpacity = 1
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0 , height: 2)
    layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                 y: bounds.maxY - layer.shadowRadius,
                                                 width: bounds.width + 15,
                                                 height: layer.shadowRadius)).cgPath
}
}
extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
//shadowView.dropShadow()

    
  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
//    layer.masksToBounds = false
//    layer.shadowColor = color.cgColor
//    layer.shadowOpacity = opacity
//    layer.shadowOffset = offSet
//    layer.shadowRadius = radius
//
//    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//    layer.shouldRasterize = true
//    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
//
//    let viewShadow = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//    viewShadow.center = self.view.center
    self.backgroundColor = UIColor.yellow
    self.layer.shadowColor = UIColor.red.cgColor
    self.layer.shadowOpacity = 1
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowRadius = 5
   }
    
    //shadowView.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)

}
class DateField: UITextField {
    var date: Date?
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
        
    override func didMoveToSuperview() {
        let currentDate = Date()
        datePicker.datePickerMode = .date
        //datePicker.preferredDatePickerStyle = .inline
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
 
        }
        //datePicker.minimumDate = currentDate
        formatter.dateFormat = "MM-dd-yyyy"//MMM dd, yyyy"  05-27-2021
        //formatter.dateStyle = .short
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        toolbar.setItems([cancel,space,done], animated: false)
        inputAccessoryView = toolbar
        inputView = datePicker
    }
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        endEditing(true)
    }
    @objc func doneAction(_ sender: UIBarButtonItem) {
        date = datePicker.date
        text = formatter.string(from: datePicker.date)
        endEditing(true)
    }
}
class TimeField: UITextField {
    var date: Date?
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
        
    override func didMoveToSuperview() {
        let currentDate = Date()

        datePicker.datePickerMode = .time
       // datePicker.minimumDate = currentDate
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
 
        }

        formatter.dateFormat = "hh:mm a"
        //formatter.dateStyle = .short
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        toolbar.setItems([cancel,space,done], animated: false)
        inputAccessoryView = toolbar
        inputView = datePicker
    }
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        endEditing(true)
    }
    @objc func doneAction(_ sender: UIBarButtonItem) {
        date = datePicker.date
        text = formatter.string(from: datePicker.date)
        endEditing(true)
    }
}



extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
}
