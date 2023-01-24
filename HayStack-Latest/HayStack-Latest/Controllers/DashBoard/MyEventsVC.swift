//
//  MyEventsVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit

class MyEventsCell: UITableViewCell {
    @IBOutlet weak var ComposeBtnref: UIButton!
    @IBOutlet weak var membersListbtnref: UIButton!
    
    @IBOutlet weak var EventNameLblref: UILabel!
    @IBOutlet weak var Peoplelblref: UILabel!
    @IBOutlet weak var userFirstBtnref: UIButton!
    @IBOutlet weak var userSecondBtnref: UIButton!
    @IBOutlet weak var userThirdBtnref: UIButton!
    
    @IBOutlet weak var deleteBtnref: UIButton!
    @IBOutlet weak var EditEventBtnref: UIButton!
    @IBOutlet weak var backViewRef: UIView!
}

class MyEventsVC: UIViewController {
    
    @IBOutlet weak var InvitedLblref: UILabel!
    
    @IBOutlet weak var AttendLblref: UILabel!
    @IBOutlet weak var IntrestLblref: UILabel!
    @IBOutlet weak var Myeventslblref: UILabel!
    @IBOutlet weak var Eventstblref: UITableView!
    
    
    var MyEventsArr : [SearchEventModeldata]?
    
    var selectedBtnName = ""
    let formatter = DateFormatter()
    let formatter2 = DateFormatter()
    var currentDate = ""
    var currentTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

      
        self.formatter.dateFormat = "MM-dd-yyyy"
        self.currentDate = formatter.string(from: Date())
        self.formatter2.dateFormat = "hh:mm a"
        self.currentTime = formatter2.string(from: Date())
        
    }
    override func viewWillAppear(_ animated: Bool) {
      
        if self.selectedBtnName == "My Events"{
            self.MyEventsBtnMethod()
        }else if self.selectedBtnName == "Attend"{
            self.AttendBntMethodref()
        }else if self.selectedBtnName == "Interest"{
            self.IntrestedbtnMethodref()
        }else if self.selectedBtnName == "Invited"{
            self.invitedBtnMethodref()
        }
         
       
    }
    
    @IBAction func backBntref(_ sender: Any) {
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
         self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
    @IBAction func MyEventsBntref(_ sender: Any) {
        self.MyEventsBtnMethod()
       
    }
    @IBAction func InvitedBntref(_ sender: Any) {
        self.invitedBtnMethodref()
    }
    @IBAction func interestBntref(_ sender: Any) {
        self.IntrestedbtnMethodref()
     }
    @IBAction func attendBntref(_ sender: Any) {
        self.AttendBntMethodref()
    }
    
    func MyEventsBtnMethod(){
        self.AttendLblref.isHidden = true
        self.InvitedLblref.isHidden = true
        self.IntrestLblref.isHidden = true
        self.Myeventslblref.isHidden = false
        self.MyEventsArr?.removeAll()
        self.Eventstblref.reloadData()
        self.selectedBtnName = "My Events"
        self.Eventstblref.reloadWithAnimation()
        //Api calling...
        self.MyEventsMehtod()
    }
    
    func invitedBtnMethodref(){
        self.AttendLblref.isHidden = true
        self.InvitedLblref.isHidden = false
        self.IntrestLblref.isHidden = true
        self.Myeventslblref.isHidden = true
        self.MyEventsArr?.removeAll()
        self.Eventstblref.reloadData()
        self.Eventstblref.reloadWithAnimation()
        self.selectedBtnName = "Invited"
        //Api calling...
        self.MyInvitedMehtod()
    }
    
    func IntrestedbtnMethodref(){
        self.AttendLblref.isHidden = true
        self.InvitedLblref.isHidden = true
        self.IntrestLblref.isHidden = false
        self.Myeventslblref.isHidden = true
        self.MyEventsArr?.removeAll()
        self.Eventstblref.reloadData()
        self.selectedBtnName = "Interest"
        self.Eventstblref.reloadWithAnimation()
        //Api calling...
        self.MyIntrestedMehtod()
    }
    
    func AttendBntMethodref(){
        self.AttendLblref.isHidden = false
        self.InvitedLblref.isHidden = true
        self.IntrestLblref.isHidden = true
        self.Myeventslblref.isHidden = true
        self.MyEventsArr?.removeAll()
        self.Eventstblref.reloadData()
        self.selectedBtnName = "Attend"
        
        self.Eventstblref.reloadWithAnimation()
        //Api calling...
        self.MyAttendMehtod()
    }
     
}
extension MyEventsVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if  self.MyEventsArr?.count ?? 0 > 0
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
              return self.MyEventsArr?.count ?? 0
       
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyEventsCell = tableView.dequeueReusableCell(withIdentifier: "MyEventsCell", for: indexPath) as! MyEventsCell
        
        
       // if self.selectedBtnName == "MyEvent" {
            if let EventName = self.MyEventsArr?[indexPath.row].event_name {
                cell.EventNameLblref.text = EventName
            }
//            if let Peoplelblref = self.MyEventsArr?[indexPath.row].membercount {
//                cell.Peoplelblref.text = "People (\(Peoplelblref))"
//            }
           if let membercount = self.MyEventsArr?[indexPath.row].membercount {
            if membercount == "0"{
                cell.userFirstBtnref.isHidden = true
                cell.userSecondBtnref.isHidden = true
                cell.userThirdBtnref.isHidden = true
                cell.Peoplelblref.isHidden = true
            }else {
            cell.Peoplelblref.text = "People (\(membercount))"
                cell.userFirstBtnref.isHidden = false
                cell.userSecondBtnref.isHidden = false
                cell.userThirdBtnref.isHidden = false
                cell.Peoplelblref.isHidden = false
            }
        }else {
            cell.userFirstBtnref.isHidden = true
            cell.userSecondBtnref.isHidden = true
            cell.userThirdBtnref.isHidden = true
            cell.Peoplelblref.isHidden = true
        }
        
        
        if  self.selectedBtnName == "My Events" {
            cell.ComposeBtnref.isHidden = false
        }else {
            cell.ComposeBtnref.isHidden = true
        }
        
        cell.ComposeBtnref.tag = indexPath.row
        cell.ComposeBtnref.addTarget(self, action: #selector(EditNewGroup), for: .touchUpInside)
        
        cell.membersListbtnref.tag = indexPath.row
        cell.membersListbtnref.addTarget(self, action: #selector(GroupmembersList), for: .touchUpInside)
        
       // cell.backViewRef.dropShadow()
        
        cell.backViewRef.layer.shadowColor = UIColor.gray.cgColor
        cell.backViewRef.layer.masksToBounds = false
        cell.backViewRef.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
        cell.backViewRef.layer.shadowOpacity = 1.0
        cell.backViewRef.layer.shadowRadius = 1.0
        
        cell.deleteBtnref.tag = indexPath.row
        cell.deleteBtnref.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "EventInfoVC") as! EventInfoVC
        nxtVC.MyEventsDetails = self.MyEventsArr?[indexPath.row]
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
    @objc func EditNewGroup(sender: UIButton){
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "UpdateEventVC") as! UpdateEventVC
        nxtVC.MyEventsDetails = self.MyEventsArr?[sender.tag]
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
    @objc func deleteEvent(sender: UIButton){
        let alertController = UIAlertController(title: kApptitle, message: "Are you sure you want to delete?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if self.selectedBtnName == "My Events" {
                 self.DeleteMyEvents(eventid:self.MyEventsArr?[sender.tag].id ?? "")
            }else if self.selectedBtnName == "Interest" {
                self.DeleteAllEvents(eventid: self.MyEventsArr?[sender.tag].id ?? "", type: "interest")
             }else if self.selectedBtnName == "Invited" {
                self.DeleteAllEvents(eventid: self.MyEventsArr?[sender.tag].id ?? "", type: "invite")
            }else if self.selectedBtnName == "Attend" {
                self.DeleteAllEvents(eventid: self.MyEventsArr?[sender.tag].id ?? "", type: "attend")
            }
         }
        let CancelBtn = UIAlertAction(title: "Cancel", style: .default) { (UIAlertAction) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelBtn)
        self.present(alertController, animated: true, completion: nil)
        
     }
    
    @objc func GroupmembersList(sender: UIButton){
        //self.movetonextvc(id: "GroupMembersListVC", storyBordid: "SupportBoard")
     }
    
}

extension MyEventsVC {
   
    
    //MARK:- login func
    func MyEventsMehtod(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
        
         let parameters = [
            "id":UserId,
            "currentdate":self.currentDate,
            "endtime":self.currentTime
        ]
        NetworkManager.Apicalling(url: API_URl.myEvents_URL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let response = response.data as? [SearchEventModeldata] {
                    self.MyEventsArr = response
                     //self.Eventstblref.reloadData()
                    self.Eventstblref.reloadWithAnimation()
                }
                  

            }else {
                indicator.hideActivityIndicator()
                self.AttendLblref.isHidden = true
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = true
                self.Myeventslblref.isHidden = false
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "My Events"
                self.Eventstblref.reloadWithAnimation()
                self.ShowAlert(message: response.message ?? "No record found.")
                
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
                self.AttendLblref.isHidden = true
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = true
                self.Myeventslblref.isHidden = false
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "My Events"
                self.Eventstblref.reloadWithAnimation()
            }
        }
    }
    
    //MARK:- login func
    func MyIntrestedMehtod(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
        
         let parameters = [
            "id":UserId,
            "currentdate":self.currentDate,
            "endtime":self.currentTime
          
        ]
        NetworkManager.Apicalling(url: API_URl.myInterest_URL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let response = response.data as? [SearchEventModeldata] {
                    self.MyEventsArr = response
                     //self.Eventstblref.reloadData()
                    self.Eventstblref.reloadWithAnimation()
                }
                  

            }else {
                indicator.hideActivityIndicator()
                self.AttendLblref.isHidden = true
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = false
                self.Myeventslblref.isHidden = true
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "Interest"
                self.Eventstblref.reloadWithAnimation()
                self.ShowAlert(message: response.message ?? "No record found.")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
                self.AttendLblref.isHidden = true
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = false
                self.Myeventslblref.isHidden = true
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "Interest"
                self.Eventstblref.reloadWithAnimation()
                
            }
        }
    }
    
    //MARK:- login func
    func MyAttendMehtod(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
        
         let parameters = [
            "id":UserId,
            "currentdate":self.currentDate,
            "endtime":self.currentTime
        ]
        NetworkManager.Apicalling(url: API_URl.myAttend_URL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let response = response.data as? [SearchEventModeldata] {
                    self.MyEventsArr = response
                     //self.Eventstblref.reloadData()
                    self.Eventstblref.reloadWithAnimation()
                }
                  

            }else {
                indicator.hideActivityIndicator()
                self.AttendLblref.isHidden = false
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = true
                self.Myeventslblref.isHidden = true
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "Attend"
                
                self.Eventstblref.reloadWithAnimation()
                self.ShowAlert(message: response.message ?? "No record found.")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
                self.AttendLblref.isHidden = false
                self.InvitedLblref.isHidden = true
                self.IntrestLblref.isHidden = true
                self.Myeventslblref.isHidden = true
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.selectedBtnName = "Attend"
                
                self.Eventstblref.reloadWithAnimation()
            }
        }
    }
    
    
    //MARK:- login func
    func MyInvitedMehtod(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
         let parameters = [
            "id":UserId,
            "currentdate":self.currentDate,
            "endtime":self.currentTime
        ]
        NetworkManager.Apicalling(url: API_URl.myInvited_URL, paramaters: parameters, httpMethodType: .get, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let response = response.data as? [SearchEventModeldata] {
                    self.MyEventsArr = response
                     //self.Eventstblref.reloadData()
                    self.Eventstblref.reloadWithAnimation()
                }
 
            }else {
                indicator.hideActivityIndicator()
                 self.AttendLblref.isHidden = true
                self.InvitedLblref.isHidden = false
                self.IntrestLblref.isHidden = true
                self.Myeventslblref.isHidden = true
                self.MyEventsArr?.removeAll()
                self.Eventstblref.reloadData()
                self.Eventstblref.reloadWithAnimation()
                self.selectedBtnName = "Invited"

                self.ShowAlert(message: "No record found.")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
                self.AttendLblref.isHidden = true
               self.InvitedLblref.isHidden = false
               self.IntrestLblref.isHidden = true
               self.Myeventslblref.isHidden = true
               self.MyEventsArr?.removeAll()
               self.Eventstblref.reloadData()
               self.Eventstblref.reloadWithAnimation()
               self.selectedBtnName = "Invited"
            }
        }
    }
    //MARK:- login func
    func DeleteAllEvents(eventid:String,type:String){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
      
         let parameters = [
            "id":UserId,
            "eventid":eventid,
            "type":type
        ]
        NetworkManager.Apicalling(url: API_URl.DeleteAllEventURL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
               
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                     if type == "interest" {
                        self.MyIntrestedMehtod()
                    }else if type == "attend" {
                        self.MyAttendMehtod()
                    }else if type == "invite" {
                        self.MyInvitedMehtod()
                    }
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
    func DeleteMyEvents(eventid:String){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
       
      
         let parameters = [
            "id":UserId,
            "eventid":eventid,
         ]
        NetworkManager.Apicalling(url: API_URl.DeleteEventURL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
               
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.MyEventsMehtod()
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
