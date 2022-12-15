//
//  ContactUSVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class ContactUSVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    @IBOutlet weak var fullNametfref: UITextField!
    @IBOutlet weak var Emailtfref: UITextField!
    @IBOutlet weak var Discriptiontfref: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.headerVewref.addBottomShadow()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtnref(_sender : Any){
        self.popToBackVC()
    }
    
    @IBAction func ContactUsbtnref(_sender : Any){
        
        
        switch self.ContactUSVCValidation() {
       case .Success:
           print("done")
           self.ContactUsMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
}
extension ContactUSVC: UITextFieldDelegate{
 
    func ContactUSVCValidation()-> ApiCheckValidation {
        if fullNametfref.text ?? "" == "" || Emailtfref.text ?? "" == "" || Discriptiontfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = Emailtfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
         }else {
            return ApiCheckValidation.Success
        }
    }
}
extension ContactUSVC {
   
    
    //MARK:- login func
    func ContactUsMethod(){
        indicator.showActivityIndicator()
    
        guard let full_name = fullNametfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let email = Emailtfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let message = Discriptiontfref.text else{
            return
        }
      
        let parameters = [
            "full_name" : full_name,
            "email" : email,
            "message" : message
        ]
        NetworkManager.Apicalling(url: API_URl.ContactUsURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
            print(response.uid)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                self.ShowAlertWithPop(message: response.message)
             }else {
                indicator.hideActivityIndicator()
                 if response.message == "Message has sent successfully !!!" {
                     self.ShowAlertWithPop(message: response.message)
                 } else {
                self.ShowAlert(message: response.message ?? "Something went wrong...")
                 }
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
            }
        }
    }
}
