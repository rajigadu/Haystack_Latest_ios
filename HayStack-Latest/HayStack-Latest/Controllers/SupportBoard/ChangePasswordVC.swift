//
//  ChangePasswordVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var OldPasswordTfref: UITextField!
    @IBOutlet weak var PasswordTfref: UITextField!
    @IBOutlet weak var ConfirmPasswordTfref: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backbtnref(_sender : Any){
        self.popToBackVC()
    }
    
    @IBAction func ChangePasswordbtnref(_sender : Any){
        switch self.ChangePasswordValidation() {
       case .Success:
           print("done")
           self.ChangePasswordMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }

}
extension ChangePasswordVC: UITextFieldDelegate{
 
    func ChangePasswordValidation()-> ApiCheckValidation {
        if OldPasswordTfref.text ?? "" == "" || PasswordTfref.text ?? "" == "" || ConfirmPasswordTfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Passstr = PasswordTfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else if let Passstr = PasswordTfref.text,let Passstr2 = ConfirmPasswordTfref.text {
            if Passstr != Passstr2 {
                return ApiCheckValidation.Error("Please enter Valid Password...")
            }else {
                return ApiCheckValidation.Success
            }
        } else {
            return ApiCheckValidation.Success
        }
    }
}
extension ChangePasswordVC {
   
    
    //MARK:- login func
    func ChangePasswordMethod(){
        indicator.showActivityIndicator()
    
        guard let OldPassword = OldPasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = PasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
            "oldpassword" : OldPassword,
            "newpassword" : password,
            "lognied_User":"Soldier",
            "id":UserId
 
        ]
        NetworkManager.Apicalling(url: API_URl.ChangePassWordURL, paramaters: parameters, httpMethodType: .post, success: { (response:editUserModel) in
           
            if response.message == "Password has been changed successfully." {
                indicator.hideActivityIndicator()
                
                self.ShowAlertWithLogOut(message : response.message ?? "Password has been changed successfully.")
                
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
    
    
    func ShowAlertWithLogOut(message : String){
        let alertController = UIAlertController(title: kApptitle, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            self.logOutMethod()
        }
        alertController.addAction(OKAction)
         self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func logOutMethod(){
        UserDefaults.standard.set("", forKey: "LoginedUserType")
        UserDefaults.standard.set(false, forKey: "IsUserLogined")
        UserDefaults.standard.set("", forKey: "SoldierId")
        UserDefaults.standard.set("", forKey: "Soldierfname")
        UserDefaults.standard.set("", forKey: "Soldierlname")
        UserDefaults.standard.set("", forKey: "SoldierGovt_email")
        UserDefaults.standard.set("", forKey: "SoldierUsername")
        UserDefaults.standard.set("", forKey: "SoldierDod_id")
        UserDefaults.standard.set("", forKey: "LoginedUserType")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set("", forKey: "SpouseSubId")
        UserDefaults.standard.set("", forKey: "Spousefname")
        UserDefaults.standard.set("", forKey: "Spouselname")
        UserDefaults.standard.set("", forKey: "SpouseSponsors_govt_email")
        UserDefaults.standard.set("", forKey: "SpouseUserName")
        UserDefaults.standard.set("", forKey: "SpouseSponsor_id")
        UserDefaults.standard.set("", forKey: "SpouseRelation_to_sm")
        UserDefaults.standard.set("", forKey: "SoldierId")
        UserDefaults.standard.set("", forKey: "Soldierfname")
        UserDefaults.standard.set("", forKey: "Soldierlname")
        UserDefaults.standard.set("", forKey: "SoldierGovt_email")
        UserDefaults.standard.set("", forKey: "SoldierUsername")
        UserDefaults.standard.set("", forKey: "SoldierDod_id")
        UserDefaults.standard.set(false, forKey: "IsUserLogined")
        
        self.resetDefaults()
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var navigation = UINavigationController()
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            navigation = UINavigationController(rootViewController: initialViewControlleripad)
      
        appDelegate.window?.rootViewController = navigation
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
