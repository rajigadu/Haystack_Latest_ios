//
//  EditMembersVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class EditMembersVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    
    //Add member
    @IBOutlet weak var memberNameTFref: UITextField!
    @IBOutlet weak var memberPhoneTfref: UITextField!
    @IBOutlet weak var memberEmailTFref: UITextField!
    
    var memberName = ""
    var memberPhone = ""
    var memberEmail = ""
    
    var GroupName = ""
    var groupId = ""
    var memberId = ""
    
    var vcFrom = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.memberNameTFref.text = memberName
        self.memberPhoneTfref.text = memberPhone
        self.memberEmailTFref.text = memberEmail

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func chosseFomContactListbtnref(_ sender: Any) {
    }
    @IBAction func EditGroupMemberBntref(_sender: Any){
        
        switch self.EditMemberValidation() {
       case .Success:
           print("done")
        if vcFrom == "EditMember" {
           self.EditMemberfromGroupMethod()
        }else {
            self.AddMemberToGroupMethod()
        }
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }

}
extension EditMembersVC{
    func EditMemberValidation()-> ApiCheckValidation {
        if  memberNameTFref.text ?? "" == "" || memberPhoneTfref.text ?? "" == "" || memberEmailTFref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = memberEmailTFref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension EditMembersVC {
//MARK:- login func
func EditMemberfromGroupMethod(){
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
    
    
    
    var UserId = ""
    if  LognedUserType == "Soldier" {
        UserId = UserDefaults.standard.string(forKey: "SoldierId") ?? ""
    }else {
        UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
    }
    
    let parameters = [
        "groupid":self.groupId,
        "member":memberName,
        "number":memberPhone,
        "email":memberEmail,
        "id":memberId,
        "userid": UserId//(host id)
    ] as [String : Any]
    NetworkManager.Apicalling(url: API_URl.EditGroupMembersListURL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateGroupModel) in
        print(response.data)
        if response.status == "1" {
            indicator.hideActivityIndicator()
            self.ShowAlert(message: response.message ?? "Member details updted successfully.")
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
    func AddMemberToGroupMethod(){
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
        
        
        
        
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
            "groupid":self.groupId,
            "member":memberName,
            "number":memberPhone,
            "email":memberEmail,
            "id": UserId//(host id)
        ] as [String : Any]
        NetworkManager.Apicalling(url: API_URl.add_Member_To_Group_URL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateGroupModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                self.ShowAlertWithPop(message: response.message ?? "This member added successfully to \(self.GroupName) group." )
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
