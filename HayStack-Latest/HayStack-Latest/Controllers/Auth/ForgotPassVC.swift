//
//  ForgotPassVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class ForgotPassVC: UIViewController {

    @IBOutlet weak var EmailTfref: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignInBtnref(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.navigationController?.pushViewController(vc, animated: true)
        self.movetonextvc(id: "LoginVC", storyBordid: "Main")

    }
    
    
    
    
    @IBAction func forgotPassbtnref(_ sender: Any) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
       // self.movetonextvc(id: "LoginVC", storyBordid: "Main")
        
        
        switch self.ForGotPasswordValidation() {
       case .Success:
           print("done")
           self.ForGotPassword()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }

    }

}
extension ForgotPassVC{
    func ForGotPasswordValidation()-> ApiCheckValidation {
        if EmailTfref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = EmailTfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension ForgotPassVC {
   
    
    //MARK:- login func
    func ForGotPassword(){
        indicator.showActivityIndicator()
          guard let Email = EmailTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        
        let parameters = [
            "email":Email,
            
        ]
        NetworkManager.Apicalling(url: API_URl.ForGotPassWordURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
            print(response.uid)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                 let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.movetonextvc(id: "LoginVC", storyBordid: "Main")
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
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
