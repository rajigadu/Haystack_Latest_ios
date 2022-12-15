//
//  GroupMembersListVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit

class GroupMemberlistCell: UITableViewCell {
    
    @IBOutlet weak var composebtnref: UIButton!
    
    @IBOutlet weak var memberNamelblref: UILabel!
    @IBOutlet weak var memberEmailLblref: UILabel!
    @IBOutlet weak var memberPhoneLblref: UILabel!
    
    @IBOutlet weak var deletebtnref: UIButton!

    
    
}

class GroupMembersListVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    var groupid = ""
    var GroupName = ""
    
    var vcFrom = ""// nxtVC.vcFrom = "CreateEvent"
    @IBOutlet weak var GroupmembersListtblref: UITableView!
    var groupMembersListarr : [GroupsMemberModel] = []
    //for create event
     var AdvertiseStatus = ""
     var HostcontactStatus = ""
     var MemberModel: CreateEventMemberFourthModel?
     var FirstScreenModel: CreateEventFirstModel?
     var secondScreenModelArr: [CategorySecondModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
         self.headerVewref.addBottomShadow()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Api calling...
        self.GetGroupMemberslist()
    }
    
    
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func addMemberbtnref(_ sender: Any) {
 
        let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "EditMembersVC") as! EditMembersVC
         nxtVC.groupId = self.groupid
         nxtVC.GroupName = self.GroupName
        nxtVC.vcFrom = "AddNewMember"
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
}
extension GroupMembersListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupMembersListarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GroupMemberlistCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberlistCell", for: indexPath) as! GroupMemberlistCell
        
        if let Membername = self.groupMembersListarr[indexPath.row].member {
            cell.memberNamelblref.text = Membername
        }
        
        if let MemberEmail = self.groupMembersListarr[indexPath.row].email {
            cell.memberEmailLblref.text = MemberEmail
        }
        
        if let MemberPhone = self.groupMembersListarr[indexPath.row].number {
            cell.memberPhoneLblref.text = MemberPhone
        }
        
        
        
        cell.composebtnref.tag = indexPath.row
        cell.composebtnref.addTarget(self, action: #selector(EditmembersList), for: .touchUpInside)
        
        cell.deletebtnref.tag = indexPath.row
        cell.deletebtnref.addTarget(self, action: #selector(DeletemembersList), for: .touchUpInside)
        

        return cell
    }
    @objc func EditmembersList(sender: UIButton){
        let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "EditMembersVC") as! EditMembersVC
        nxtVC.memberName = self.groupMembersListarr[sender.tag].member ?? ""
        nxtVC.memberPhone =  self.groupMembersListarr[sender.tag].number ?? ""
        nxtVC.memberEmail =  self.groupMembersListarr[sender.tag].email ?? ""
        nxtVC.groupId = self.groupMembersListarr[sender.tag].groupid ?? ""
        nxtVC.memberId = self.groupMembersListarr[sender.tag].id ?? ""
        nxtVC.GroupName = self.GroupName
        nxtVC.vcFrom = "EditMember"
        self.navigationController?.pushViewController(nxtVC, animated: true)

    }
    
    @objc func DeletemembersList(sender: UIButton){
        let alertController = UIAlertController(title: kApptitle, message: "Are you sure you want to delete this member?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            self.DeletegroupMemberList(groupId:self.groupMembersListarr[sender.tag].groupid ?? "",memberid : self.groupMembersListarr[sender.tag].id ?? "")
        }
        let CancelBtn = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vcFrom == "CreateEvent_AddExtraMember" {
//            let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
//            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AddExtraMeberToEventVC") as! AddExtraMeberToEventVC
          
            GlobalvcFrom =  "addMemberFromGroup"
            GlobalMemberModel = CreateEventMemberFourthModel(membername: self.groupMembersListarr[indexPath.row].member ?? "", memberNumber: self.groupMembersListarr[indexPath.row].number ?? "", memberEmail: self.groupMembersListarr[indexPath.row].email ?? "")
             self.dismiss()
        }else if self.vcFrom == "CreateEvent_AddMember" {
            let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AddMembersToEventVC") as! AddMembersToEventVC
            nxtVC.vcFrom =  "addMemberFromGroup"
            nxtVC.MemberModel = CreateEventMemberFourthModel(membername: self.groupMembersListarr[indexPath.row].member ?? "", memberNumber: self.groupMembersListarr[indexPath.row].number ?? "", memberEmail: self.groupMembersListarr[indexPath.row].email ?? "")
            nxtVC.AdvertiseStatus = self.AdvertiseStatus
            nxtVC.HostcontactStatus = self.HostcontactStatus
            nxtVC.FirstScreenModel = self.FirstScreenModel
            nxtVC.secondScreenModelArr = self.secondScreenModelArr
            self.navigationController?.pushViewController(nxtVC, animated: true)
            
        }
    }
    
}

extension GroupMembersListVC {
    //MARK:- login func
    func GetGroupMemberslist(){
        indicator.showActivityIndicator()
        
        var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        let parameters = [
            "id": UserId,//(host id)
            "groupid":self.groupid
        ] as [String : Any]
        NetworkManager.Apicalling(url: API_URl.GetGroupMembersListURL, paramaters: parameters, httpMethodType: .post, success: { (response:GroupsmembersListModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let responsedata = response.data as? [GroupsMemberModel]{
                    self.groupMembersListarr = responsedata
                    self.GroupmembersListtblref.reloadData()
                 }
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
    
    
    func DeletegroupMemberList(groupId:String,memberid : String){
        indicator.showActivityIndicator()
     
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
             "userid": UserId,//(host id)
             "groupid":groupId,
            "memberid":memberid
         ]
        NetworkManager.Apicalling(url: API_URl.deleteGroupMembersListURL, paramaters: parameters, httpMethodType: .post, success: { (response:GroupsListModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.GetGroupMemberslist()
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
