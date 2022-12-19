//
//  CreateEventThirdVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 14/05/21.
//

import UIKit
import ContactsUI

class AddMembersToEventVC: UIViewController {

    @IBOutlet weak var memberNumbertfref: UITextField!
    @IBOutlet weak var memberNametfref: UITextField!
    @IBOutlet weak var memberEmailtfref: UITextField!
    
    var AdvertiseStatus = ""
    var HostcontactStatus = ""
    var MemberModel: CreateEventMemberFourthModel?
    var FirstScreenModel: CreateEventFirstModel?
    var secondScreenModelArr: [CategorySecondModel] = []
    
    var vcFrom = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if vcFrom == "addMemberFromGroup"{
            self.memberNumbertfref.text = self.MemberModel?.memberNumber
            self.memberNametfref.text = self.MemberModel?.membername
            self.memberEmailtfref.text = self.MemberModel?.memberEmail
        }
    }

    @IBAction func backBntref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func InviteBntFromGroupref(_ sender: Any) {
       let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
       let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AllGroupListVC") as! AllGroupListVC
        nxtVC.vcFrom = "CreateEvent_AddMember"
        nxtVC.AdvertiseStatus = self.AdvertiseStatus
        nxtVC.HostcontactStatus = self.HostcontactStatus
      //  nxtVC.MemberModel = self.MemberModel
        nxtVC.FirstScreenModel = self.FirstScreenModel
        nxtVC.secondScreenModelArr = self.secondScreenModelArr
       self.navigationController?.pushViewController(nxtVC, animated: true)
     }
    
    
    @IBAction func movetoDashBoard(_ sender: Any) {
        self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")

    }
    @IBAction func skipandContinueBntref(_ sender: Any) {
         let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "PublishingEventVC") as! PublishingEventVC
        nxtVC.skipBtn = false
        nxtVC.AdvertiseStatus = self.AdvertiseStatus
        nxtVC.HostcontactStatus = self.HostcontactStatus
        nxtVC.FirstScreenModel = self.FirstScreenModel
        nxtVC.secondScreenModelArr = self.secondScreenModelArr
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
    @IBAction func invitePeopleBtnref(_ sender: Any) {
        switch self.AddMembersToEventValidation() {
       case .Success:
           print("done")
        self.movetonextVc()
       case .Error(let errorStr) :
           print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }

    }
    
    @IBAction func addContactsBookBtnref(_ sender: Any){
        self.memberNametfref.text = ""
        self.memberNumbertfref.text = ""
        self.memberEmailtfref.text = ""
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    
    func movetonextVc(){
        self.MemberModel = CreateEventMemberFourthModel(membername: self.memberNametfref.text ?? "", memberNumber: self.memberNumbertfref.text ?? "", memberEmail: self.memberEmailtfref.text ?? "")
//        self.movetonextvc(id: "PublishingEventVC", storyBordid: "DashBoard")
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "PublishingEventVC") as! PublishingEventVC
        nxtVC.MemberModel = self.MemberModel
        
        nxtVC.AdvertiseStatus = self.AdvertiseStatus
        nxtVC.HostcontactStatus = self.HostcontactStatus
        nxtVC.FirstScreenModel = self.FirstScreenModel
        nxtVC.secondScreenModelArr = self.secondScreenModelArr
        self.navigationController?.pushViewController(nxtVC, animated: true)

    }
}
extension AddMembersToEventVC {
    // MARK: Delegate method CNContectPickerDelegate
 //   func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
  //      print(contact.phoneNumbers)
  //      let numbers = contact.phoneNumbers.first
  //      let Namenumbers = contact.givenName.first
  //      print((numbers?.value)?.stringValue ?? "")
 //
//        self.memberNumbertfref.text = "\((numbers?.value)?.stringValue ?? "")"
//        self.memberNametfref.text = "\((Namenumbers?.value)?.stringValue ?? "")"
 //       self.memberEmailtfref.text = "\((numbers?.value)?.stringValue ?? "")"
            
  //          print(" Contact No. \((numbers?.value)?.stringValue ?? "")")
        
        
  //  }
   // func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
   //     self.dismiss(animated: true, completion: nil)
   // }
}
extension AddMembersToEventVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let emailNumberCount = contact.emailAddresses.count
        let phoneNumberCount = contact.phoneNumbers.count
        let name: String? = CNContactFormatter.string(from: contact, style: .fullName)
        self.memberNametfref.text = name
        
        
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
        self.memberEmailtfref.text = contactEmail
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
        self.memberNumbertfref.text = String(contactNumber.suffix(10))

    }

   
}
extension AddMembersToEventVC{
    func AddMembersToEventValidation()-> ApiCheckValidation {
        if (memberNumbertfref.text ?? "" == "" && memberNametfref.text ?? "" == "") || (memberEmailtfref.text ?? "" == "" && memberNametfref.text ?? "" == "") {
            return ApiCheckValidation.Error("All feilds required!")
        } else if memberEmailtfref.text ?? "" != "" {
            if let Emailstr = memberEmailtfref.text,!isValidEmail(Emailstr) {
                return ApiCheckValidation.Error("Please enter Valid Email...")
            }
            return ApiCheckValidation.Success
        }else {
            return ApiCheckValidation.Success
        }
    }
}
