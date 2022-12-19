//
//  AddExtraMeberToEventVCViewController.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 25/05/21.
//

import UIKit
import ContactsUI

var GlobalMemberModel: CreateEventMemberFourthModel?
var GlobalvcFrom = ""

protocol AddExtraMeberToEventDelegate{

 func AddExtraMeberToEventData(Data: CreateEventMemberFourthModel)
    
}

protocol UpdateExtraMeberToEventDelegate{

 func UpdateExtraMeberToEventData(Data: CreateEventMemberFourthModel)
    
}
class AddExtraMeberToEventVC: UIViewController {


    @IBOutlet weak var memberNumbertfref: UITextField!
    @IBOutlet weak var memberNametfref: UITextField!
    @IBOutlet weak var memberEmailtfref: UITextField!
    var vcFrom = ""
    var memberNumber = ""
    var memberName = ""
    var memberEmail = ""
    var AdvertiseStatus = ""
    var HostcontactStatus = ""
    var MemberModel: CreateEventMemberFourthModel?
    var AddExtraMeberdelegate : AddExtraMeberToEventDelegate?
    var UpdateExtraMeberdelegate : UpdateExtraMeberToEventDelegate?
    var isPresenter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("addNewMember"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let email = notification.userInfo?["email"] as? String {
        // do something with your image
            self.memberEmailtfref.text = email
        }
        
        if let number = notification.userInfo?["number"] as? String {
        // do something with your image
            self.memberNumbertfref.text = number
        }
        if let name = notification.userInfo?["name"] as? String {
        // do something with your image
            self.memberNametfref.text = name
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.memberNumbertfref.text = ""
        self.memberNametfref.text = ""
        self.memberEmailtfref.text = ""
    }

   
    override func viewWillAppear(_ animated: Bool) {
        if vcFrom == "EditMember"{
            self.memberNumbertfref.text = memberNumber
            self.memberNametfref.text = memberName
            self.memberEmailtfref.text = memberEmail
        }
        
//        if GlobalvcFrom == "addMemberFromGroup"{
//            self.memberNumbertfref.text = GlobalMemberModel?.memberNumber
//            self.memberNametfref.text = GlobalMemberModel?.membername
//            self.memberEmailtfref.text = GlobalMemberModel?.memberEmail
//        }
    }
    @IBAction func backBntref(_ sender: Any) {
        self.dismiss()
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
    
    
    @IBAction func addFromTheGroupbntref(_ sender: Any) {
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AllGroupListVC") as! AllGroupListVC
         nxtVC.vcFrom = "CreateEvent_AddMember"
        if isPresenter {
            nxtVC.isPresenter = true
            self.present(nxtVC, animated: true)
        } else {
            nxtVC.isPresenter = false
          self.navigationController?.pushViewController(nxtVC, animated: true)
        }
        //self.present(nxtVC, animated: true)
    }
    
    
    @IBAction func addContactsBookBtnref(_ sender: Any){
        memberEmailtfref.text = ""
        memberNumbertfref.text = ""
        memberNametfref.text = ""
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.present(contacVC, animated: true, completion: nil)
    }
    
    @IBAction func InviteBntFromGroupref(_ sender: Any) {
       let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
       let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AllGroupListVC") as! AllGroupListVC
        nxtVC.vcFrom = "CreateEvent_AddExtraMember"
        if isPresenter {
            nxtVC.isPresenter = true
            self.present(nxtVC, animated: true)
        } else {
            nxtVC.isPresenter = false
        self.navigationController?.pushViewController(nxtVC, animated: true)
        }
     }
    
    
    
    func movetonextVc(){
        
        if vcFrom == "EditMember"{
            self.UpdateExtraMeberdelegate?.UpdateExtraMeberToEventData(Data: CreateEventMemberFourthModel(membername: self.memberNametfref.text ?? "", memberNumber: self.memberNumbertfref.text ?? "", memberEmail: self.memberEmailtfref.text ?? ""))
            
            self.dismiss()

            
        }else {
      
        self.AddExtraMeberdelegate?.AddExtraMeberToEventData(Data: CreateEventMemberFourthModel(membername: self.memberNametfref.text ?? "", memberNumber: self.memberNumbertfref.text ?? "", memberEmail: self.memberEmailtfref.text ?? ""))
        
        self.dismiss()
        }

    }
}
extension AddExtraMeberToEventVC {
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
extension AddExtraMeberToEventVC: CNContactPickerDelegate {

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
extension AddExtraMeberToEventVC{
    func AddMembersToEventValidation()-> ApiCheckValidation {
        if (memberNumbertfref.text ?? "" == "" && memberNametfref.text ?? "" == "") || (memberEmailtfref.text ?? "" == "" && memberNametfref.text ?? "" == "") {
            return ApiCheckValidation.Error("All feilds required!")
        }else if memberEmailtfref.text ?? "" != "" {
            if let Emailstr = memberEmailtfref.text,!isValidEmail(Emailstr) {
                return ApiCheckValidation.Error("Please enter Valid Email...")
            }
            return ApiCheckValidation.Success
        }else {
            return ApiCheckValidation.Success
        }
    }
}
