//
//  CreateNewGroupVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit
import ContactsUI

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
        self.memberPhoneTfref.text = ""
        self.memberNameTFref.text = ""
        self.memberEmailTFref.text = ""
        
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)

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
        if groupNameTfref.text ?? "" == "" || groupDiscriptionTFref.text ?? "" == "" || (memberNameTFref.text ?? "" == "" && memberPhoneTfref.text ?? "" == "") || (memberNameTFref.text ?? "" == "" && memberEmailTFref.text ?? "" == "") {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if memberEmailTFref.text ?? "" != "" {
            if let Emailstr = memberEmailTFref.text,!isValidEmail(Emailstr) {
                return ApiCheckValidation.Error("Please enter Valid Email...")
            }
            return ApiCheckValidation.Success
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
extension CreateNewGroupVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let emailNumberCount = contact.emailAddresses.count
        let phoneNumberCount = contact.phoneNumbers.count
        let name: String? = CNContactFormatter.string(from: contact, style: .fullName)
        self.memberNameTFref.text = name
        
        
//        //MARK:-   Email 
//        //@JA - They have to have at least 1 email address
//        guard emailNumberCount > 0 else {
//            dismiss(animated: true)
//            //show pop up: "Selected contact does not have a number"
//            let alertController = UIAlertController(title: "No emails found for contact: "+contact.givenName+" "+contact.familyName, message: nil, preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: {
//            alert -> Void in
//
//            })
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//            return
//        }
//
//        //@JA - If they have only 1 email it's easy.  If there is many emails we want to concatenate them and separate by commas , , ...
//        if emailNumberCount == 1 {
//            setEmailFromContact(contactEmail: contact.emailAddresses[0].value as String)
//        } else {
//            let alertController = UIAlertController(title: "Select an email from contact: "+contact.givenName+" "+contact.familyName+" or select 'All' to send to every email listed.", message: nil, preferredStyle: .alert)
//
//            for i in 0...emailNumberCount-1 {
//                let emailAction = UIAlertAction(title: contact.emailAddresses[i].value as String, style: .default, handler: {
//                alert -> Void in
//                    self.setEmailFromContact(contactEmail: contact.emailAddresses[i].value as String)
//                })
//                alertController.addAction(emailAction)
//            }
//
//            let allAction = UIAlertAction(title: "All", style: .destructive, handler: {
//            alert -> Void in
//                var emailConcat = ""
//                for i in 0...emailNumberCount-1{
//                    if(i != emailNumberCount-1){ //@JA - Only add the , if we are not on the last item of the array
//                        emailConcat = emailConcat + (contact.emailAddresses[i].value as String)+","
//                    }else{
//                        emailConcat = emailConcat + (contact.emailAddresses[i].value as String)
//                    }
//                }
//                self.setEmailFromContact(contactEmail: emailConcat)//@JA - Sends the concatenated version of the emails separated by commas
//            })
//            alertController.addAction(allAction)
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            alert -> Void in
//
//            })
//            alertController.addAction(cancelAction)
//
//            dismiss(animated: true)
//            self.present(alertController, animated: true, completion: nil)
//        }
        
        //MARK:-  Phone Number 
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setEmailFromContact(contactEmail: String){
        self.memberEmailTFref.text = contactEmail
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("contact picker canceled")
    }
    
 

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        contactNumber = contactNumber.trimmingCharacters(in: CharacterSet.whitespaces)
        guard contactNumber.count >= 10 else {
            dismiss(animated: true) {
                self.ShowAlert(message: "Selected contact does not have a valid number")
            }
            return
        }
        self.memberPhoneTfref.text = String(contactNumber.suffix(10))

    }

   
}
