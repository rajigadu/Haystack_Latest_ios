//
//  referFriendVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class referFriendVC: UIViewController {
    
    @IBOutlet weak var headerVewref: UIView!
    @IBOutlet weak var FriendNameTfref: UITextField!
    @IBOutlet weak var FriendEmailTfref: UITextField!
    @IBOutlet weak var FriendMobileNumberTfref: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.headerVewref.addBottomShadow()
        // Do any additional setup after loading the view.
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func ReferaFriendbtnref(_sender : Any){
        
        switch self.referFriendValidation() {
       case .Success:
           print("done")
           self.referaFriendMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
   

}
extension referFriendVC: UITextFieldDelegate{
 
    func referFriendValidation()-> ApiCheckValidation {
        if FriendNameTfref.text ?? "" == "" || FriendEmailTfref.text ?? "" == "" || FriendMobileNumberTfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = FriendEmailTfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
         }else {
            return ApiCheckValidation.Success
        }
    }
}
extension referFriendVC {    
    //MARK:- login func
    func referaFriendMethod(){
        indicator.showActivityIndicator()
    
        guard let FriendName = FriendNameTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let FriendEmail = FriendEmailTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let FriendMobileNumber = FriendMobileNumberTfref.text else{
            return
        }
        var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""

        let parameters = [
            "name" : FriendName,
            "email" : FriendEmail,
            "number" : FriendMobileNumber,
            "id":UserId
        ]
        NetworkManager.Apicalling(url: API_URl.ReferFriendURL, paramaters: parameters, httpMethodType: .get, success: { (response:ReferFriendModel) in
            if response.status == "1" {
                indicator.hideActivityIndicator()
                self.FriendNameTfref.text = ""
                self.FriendEmailTfref.text = ""
                self.FriendMobileNumberTfref.text = ""
                self.ShowAlert(message: response.message ?? "Successfully sent a referal mail...")
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
