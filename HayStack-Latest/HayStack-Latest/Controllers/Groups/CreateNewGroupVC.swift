//
//  CreateNewGroupVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class CreateNewGroupVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    @IBOutlet weak var groupNameTfref: UITextField!
    @IBOutlet weak var groupDiscriptionTFref: UITextView!
    
    //Add member
    @IBOutlet weak var memberNameTFref: UITextField!
    @IBOutlet weak var memberPhoneTfref: UITextField!
    @IBOutlet weak var memberEmailTFref: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
     }
    
    @IBAction func choosememberFromContactsList(_ sender: Any){
        
    }
    
    @IBAction func createNewGroupBntref(_sender: Any){
        
        switch self.CreateGroupValidation() {
       case .Success:
           print("done")
           self.CreateNewGroupMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
    
}


extension CreateNewGroupVC{
    func CreateGroupValidation()-> ApiCheckValidation {
        if groupNameTfref.text ?? "" == "" || groupDiscriptionTFref.text ?? "" == "" || memberNameTFref.text ?? "" == "" || memberPhoneTfref.text ?? "" == "" || memberEmailTFref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = memberEmailTFref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}

extension CreateNewGroupVC {
   
    
    //MARK:- login func
    func CreateNewGroupMethod(){
        indicator.showActivityIndicator()
        guard let groupName = groupNameTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let groupDiscription = groupDiscriptionTFref.text else{
            indicator.hideActivityIndicator()
            return}
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
        
        let parameters = [
            "gname": groupName,
            "gdesc":groupDiscription,
            "id": UserId//(host id)
        ]
        NetworkManager.Apicalling(url: API_URl.create_Group_URL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateGroupModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.AddMemberToGroupMethod(groupId: response.groupid ?? 0)
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
    
    
    //MARK:- login func
    func AddMemberToGroupMethod(groupId: Int){
        indicator.showActivityIndicator()
        guard let memberName = memberNameTFref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let memberPhone = memberPhoneTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        guard let memberEmail = memberEmailTFref.text else{
            indicator.hideActivityIndicator()
            return}
        
        guard let groupName = groupNameTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
            "groupid":groupId,
            "member":memberName,
            "number":memberPhone,
            "email":memberEmail,
            "id": UserId//(host id)
        ] as [String : Any]
        NetworkManager.Apicalling(url: API_URl.add_Member_To_Group_URL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateGroupModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                 self.ShowAlertWithPop(message: response.message ?? "This member added successfully to \(groupName) group." )
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
