//
//  LoginVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
enum ApiCheckValidation {
    case Success
    case Error(String)
}
class LoginVC: UIViewController {
    @IBOutlet weak var backViewHeightref: NSLayoutConstraint!
    @IBOutlet weak var Passwordtfref: UITextField!
    @IBOutlet weak var Emailtfref: UITextField!

    var UserDataModel : newUserModel?
//    var SpouseUserDataModel : SpouseUser?
//    var SoldierUserDataModel : SoldierUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.backViewHeightref.constant = self.view.frame.height/2  - 35
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
 
    @IBAction func SignInBtnref(_ sender: Any) {
        switch self.LoginUserValidation() {
       case .Success:
           print("done")
           self.login()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
    
    
    @IBAction func SignUpBntref(_ sender: Any) {
        self.movetonextvc(id: "RegistrationPickerVC", storyBordid: "Main")

    }
    
    @IBAction func forgotPassbtnref(_ sender: Any) {
        self.movetonextvc(id: "ForgotPassVC", storyBordid: "Main")
    }
    
}
extension LoginVC{
    func LoginUserValidation()-> ApiCheckValidation {
        if Emailtfref.text ?? "" == "" || Passwordtfref.text ?? "" == ""{
            return ApiCheckValidation.Error("Please enter your credentials...")
        }else if let Emailstr = Emailtfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else if let Passstr = Passwordtfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension LoginVC {
    //MARK:- login func
    func login(){
        indicator.showActivityIndicator()
        guard let email = Emailtfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = Passwordtfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        let parameters = [
            "username":email,
            "password":password,
            "device_type":"IOS",
            "device_id":UIDevice.current.identifierForVendor!.uuidString,
            "device_token":newDeviceId
        ]
        NetworkManager.Apicalling(url: API_URl.LogINURL, paramaters: parameters, httpMethodType: .post, success: { (response:newUserModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
//                if response.lognied_User == "Soldier"{
                LognedUserType = response.data?[0].acc_type ?? ""
                UserDefaults.standard.set(response.data?[0].acc_type ?? "", forKey: "LoginedUserType")
                    self.UserDataModel = response
                    UserDefaults.standard.set(true, forKey: "IsUserLogined")
//                    self.SoldierUserDataModel = response.data?.soldier
                UserDefaults.standard.set(self.UserDataModel?.data?[0].id, forKey: "userID")
                  
                UserDefaults.standard.set(self.UserDataModel?.data?[0].fname, forKey: "userfname")
                    UserDefaults.standard.set(self.UserDataModel?.data?[0].lname, forKey: "userlname")
                    UserDefaults.standard.set(self.UserDataModel?.data?[0].email, forKey: "useremail")
                    UserDefaults.standard.set(self.UserDataModel?.data?[0].mobile, forKey: "usermobile")
                    UserDefaults.standard.set(self.UserDataModel?.data?[0].dod_id, forKey: "SoldierDod_id")
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                var navigation = UINavigationController()
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                    navigation = UINavigationController(rootViewController: initialViewControlleripad)
              
                appDelegate.window?.rootViewController = navigation
                appDelegate.window?.makeKeyAndVisible()

            }else {
                indicator.hideActivityIndicator()
                self.ShowAlert(message:   "Something went wrong...")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
            }
        }
    }
}
