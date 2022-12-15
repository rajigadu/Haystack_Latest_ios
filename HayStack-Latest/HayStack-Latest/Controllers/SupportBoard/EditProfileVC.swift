//
//  EditProfileVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class EditProfileVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!

    @IBOutlet weak var FNametfref: UITextField!
    @IBOutlet weak var LNametfref: UITextField!
    @IBOutlet weak var UserNametfref: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserNametfref.delegate = self
       // self.headerVewref.addBottomShadow()
        self.tabBarController?.tabBar.isHidden = true
        
        
        if UserDefaults.standard.string(forKey: "LoginedUserType") == "Soldier"{
            if let FUserName = UserDefaults.standard.string(forKey: "Soldierfname") {
                self.FNametfref.text = FUserName
            }
            if let LUserName = UserDefaults.standard.string(forKey: "Soldierlname") {
                self.LNametfref.text = LUserName
            }
            if let UserName = UserDefaults.standard.string(forKey: "SoldierUsername") {
                self.UserNametfref.text = UserName
            }
          }else {
            if let FUserName = UserDefaults.standard.string(forKey: "userfname") {
                self.FNametfref.text = FUserName
            }
            if let LUserName = UserDefaults.standard.string(forKey: "userlname") {
                self.LNametfref.text = LUserName
            }
            if let UserName = UserDefaults.standard.string(forKey: "usermobile") {
                self.UserNametfref.text = UserName
            }
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtnref(_sender : Any){
        self.popToBackVC()
    }
    
    @IBAction func EditProfilebtnref(_sender : Any){
        switch self.EditProfileValidation() {
       case .Success:
           print("done")
           self.EditProfileMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }

}
extension EditProfileVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == UserNametfref {
            if (string == " ") {
                return false
            }
        }
        return true
    }
    func EditProfileValidation()-> ApiCheckValidation {
        if FNametfref.text ?? "" == "" || LNametfref.text ?? "" == "" || UserNametfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension EditProfileVC {
    
    //MARK:- login func
    func EditProfileMethod(){
        indicator.showActivityIndicator()
    
        guard let FName = FNametfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let LName = LNametfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let UserName = UserNametfref.text else{
            return
        }
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
      
        let parameters = [
            "fname":FName,
            "lname":LName,
            "userNumber":UserName,
            "lognied_User":LognedUserType,
            "id":UserId
        ]
        
        NetworkManager.Apicalling(url: API_URl.UpdateProfileURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
            print(response.uid)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                    UserDefaults.standard.set(FName, forKey: "userfname")
                    UserDefaults.standard.set(LName, forKey: "userlname")
                    UserDefaults.standard.set(UserName, forKey: "usermobile")
                self.ShowAlertWithPop(message: response.message)
             }else {
                indicator.hideActivityIndicator()
                self.ShowAlert(message: response.message ?? "Something went wrong...")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
            }
        }
    }
}
