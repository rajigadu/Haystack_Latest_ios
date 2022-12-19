//
//  MyProfileVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class MyProfilelblCell : UITableViewCell {
    @IBOutlet weak var titleLblref: UILabel!
    @IBOutlet weak var profileImgref: UIImageView!
    
}

class MyProfileVC: UIViewController {
    
    @IBOutlet weak var headerVewref: UIView!
    
    
    @IBOutlet weak var versionNumber: UILabel!
    var ProfileTitlearr = ["Edit Profile","Change Password","Contact Us","Terms and Conditions","Logout"]
    var ProfileIconsarr = ["EditProfile","ChangePassword","ContactUS","termsAndConditions","LogOut"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerVewref.addBottomShadow()
        
        self.versionNumber.text = "v~ \(Bundle.main.versionNumber) (\(Bundle.main.buildNumber))"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }

    @IBAction func deleteAccountBtnref(_ sender: Any) {
        self.ShowAlertWithDeleteAccount(message : "Are you sure you want to Delete Account?")
    }
    
}
extension MyProfileVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileTitlearr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyProfilelblCell = tableView.dequeueReusableCell(withIdentifier: "MyProfilelblCell", for: indexPath) as! MyProfilelblCell
        cell.titleLblref.text = ProfileTitlearr[indexPath.row]
        cell.profileImgref.image = UIImage(named: ProfileIconsarr[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ProfileTitlearr[indexPath.row] == "Edit Profile" {
            self.movetonextvc(id: "EditProfileVC", storyBordid: "SupportBoard")
        }else if ProfileTitlearr[indexPath.row] == "Change Password" {
            self.movetonextvc(id: "ChangePasswordVC", storyBordid: "SupportBoard")
        }else if ProfileTitlearr[indexPath.row] == "Contact Us" {
            self.movetonextvc(id: "ContactUSVC", storyBordid: "SupportBoard")
        } else if ProfileTitlearr[indexPath.row] == "Trems and Conditions" {
            self.movetonextvc(id: "TermsAndConditionsVC", storyBordid: "SupportBoard")
        }else if ProfileTitlearr[indexPath.row] == "Logout" {
            self.ShowAlertWithLogOut(message : "Are you sure you want to logout?")
        }

        
    }
    func ShowAlertWithLogOut(message : String){
        let alertController = UIAlertController(title: kApptitle, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            self.logOutMethod()
        }
        let CancelBtn = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func ShowAlertWithDeleteAccount(message : String){
        let alertController = UIAlertController(title: kApptitle, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            self.deleteAccount()
        }
        let CancelBtn = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelBtn)
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
    
    //MARK:- login func
    func deleteAccount(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        var currentDate = Date.getCurrentDate()
         let parameters = [
            "id":UserId,
            "currentdate": currentDate
          ] as! [String:String]
        NetworkManager.Apicalling(url: API_URl.DeleteAccountURL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                self.logOutMethod()
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
