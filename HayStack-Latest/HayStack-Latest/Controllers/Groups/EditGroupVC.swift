//
//  EditGroupVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class EditGroupVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    @IBOutlet weak var groupNameTfref: UITextField!
    @IBOutlet weak var groupDiscriptionTFref: UITextView!
    
    var groupid = ""
    
    var groupName = ""
    var groupdiscription = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.groupNameTfref.text = groupName
        self.groupDiscriptionTFref.text = groupdiscription
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnref(_ sender: Any) {
         self.popToBackVC()
    }
    @IBAction func EditGroupBntref(_sender: Any){
        
        switch self.EditGroupValidation() {
       case .Success:
           print("done")
           self.EditGroupMethod()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
 
}
extension EditGroupVC{
    func EditGroupValidation()-> ApiCheckValidation {
        if groupNameTfref.text ?? "" == "" || groupDiscriptionTFref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds are required...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension EditGroupVC {
   
    
    //MARK:- login func
    func EditGroupMethod(){
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
            "groupid" : self.groupid,
            "id": UserId//(host id)
        ]
        NetworkManager.Apicalling(url: API_URl.Edit_Group_URL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateGroupModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                
                self.ShowAlert(message: response.message ?? "Group details edited successfully.")

 
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
