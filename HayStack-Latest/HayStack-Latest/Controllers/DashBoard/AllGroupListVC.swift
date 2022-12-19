//
//  GroupVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class NewGroupsListCell: UITableViewCell {
    
    @IBOutlet weak var ComposeBtnref: UIButton!
    @IBOutlet weak var membersListbtnref: UIButton!
    
    @IBOutlet weak var memberslistbtn2ref: UIButton!
    @IBOutlet weak var memberslistbtn3ref: UIButton!
    @IBOutlet weak var backViewRef: UIView!
    
    @IBOutlet weak var membersCountref: UILabel!
    
    @IBOutlet weak var deletebtnref: UIButton!
    @IBOutlet weak var groupnameLblref: UILabel!
}

class AllGroupListVC: UIViewController {
    
    @IBOutlet weak var backBtnref: UIButton!
    @IBOutlet weak var headerVewref: UIView!

    @IBOutlet weak var NewGroupListtblref: UITableView!
    
    @IBOutlet weak var addNewGroupsmallBtnref: UIButton!
    var grouplistModel : [GroupsListModel_data] = []
    var vcFrom = ""
    var isPresenter = false
   //for create event
    var AdvertiseStatus = ""
    var HostcontactStatus = ""
    var MemberModel: CreateEventMemberFourthModel?
    var FirstScreenModel: CreateEventFirstModel?
    var secondScreenModelArr: [CategorySecondModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerVewref.addBottomShadow()
        
//        self.tabBarController?.tabBar.isHidden = false
//
//        // Do any additional setup after loading the view.
        self.NewGroupListtblref.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.NewGroupListtblref.isHidden = false
//        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.NewGroupListtblref.isHidden = true
        self.addNewGroupsmallBtnref.isHidden = true
         //Api calling
        self.AllGroupList()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.NewGroupListtblref.isHidden = false
//        }
        
        backBtnref.isHidden = vcFrom == "CreateEvent_AddMember" ? false : true
        if vcFrom == "CreateEvent_AddExtraMember" && isPresenter {
            backBtnref.isHidden = isPresenter == true ? false : true
        }
        
        self.tabBarController?.tabBar.isHidden = vcFrom == "CreateEvent_AddExtraMember" ? true : false
        
        self.tabBarController?.tabBar.isHidden = vcFrom == "CreateEvent_AddMember" ? true : false

        
    }
    
    @IBAction func AddNewGroupBtnref(_ sender: Any) {
        self.movetonextvc(id: "CreateNewGroupVC", storyBordid: "SupportBoard")
    }
    

    @IBAction func backBtnref(_ sender: Any) {
        if isPresenter {
            self.dismiss()
        } else {
        self.popToBackVC()
        }
    }
}
extension AllGroupListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.grouplistModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewGroupsListCell = tableView.dequeueReusableCell(withIdentifier: "NewGroupsListCell", for: indexPath) as! NewGroupsListCell
        
        cell.ComposeBtnref.tag = indexPath.row
        cell.ComposeBtnref.addTarget(self, action: #selector(EditNewGroup), for: .touchUpInside)
        
        cell.membersListbtnref.tag = indexPath.row
        cell.membersListbtnref.addTarget(self, action: #selector(GroupmembersList), for: .touchUpInside)
        if self.grouplistModel[indexPath.row].member?.count ?? 0 > 0 {
            cell.membersListbtnref.setImage(self.imageWith(name: self.grouplistModel[indexPath.row].member?[0].member ?? "H"), for: .normal
            )
            
            cell.membersListbtnref.isHidden = false
        }else {
            cell.membersListbtnref.isHidden = true
        }
        if self.grouplistModel[indexPath.row].member?.count ?? 0 >= 1 {
        cell.membersCountref.text = "People (\(self.grouplistModel[indexPath.row].member?.count ?? 1) )"
        }else {
            cell.memberslistbtn2ref.isHidden = true
            cell.memberslistbtn3ref.isHidden = true
            cell.membersListbtnref.isHidden = false
            
            cell.membersCountref.text = "add the Members"
            
            cell.membersListbtnref.setImage(UIImage(named: "selectedNewEvent"), for: .normal)
        }
        
        if self.grouplistModel[indexPath.row].member?.count ?? 0 > 1 {
            cell.memberslistbtn2ref.setImage(self.imageWith(name: self.grouplistModel[indexPath.row].member?[1].member ?? "H"), for: .normal
            )
            cell.memberslistbtn2ref.isHidden = false
        }else {
            cell.memberslistbtn2ref.isHidden = true
        }
        if self.grouplistModel[indexPath.row].member?.count ?? 0 > 2 {
            cell.memberslistbtn3ref.setImage(self.imageWith(name: self.grouplistModel[indexPath.row].member?[2].member ?? "H"), for: .normal
            )
            cell.memberslistbtn3ref.isHidden = false
        }else {
            cell.memberslistbtn3ref.isHidden = true
        }
        cell.groupnameLblref.text = self.grouplistModel[indexPath.row].gname
        
       // cell.backViewRef.dropShadow()
        
        cell.backViewRef.layer.shadowColor = UIColor.gray.cgColor
        cell.backViewRef.layer.masksToBounds = false
        cell.backViewRef.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
        cell.backViewRef.layer.shadowOpacity = 1.0
        cell.backViewRef.layer.shadowRadius = 1.0
        
        
        cell.memberslistbtn2ref.tag = indexPath.row
        cell.memberslistbtn2ref.addTarget(self, action: #selector(GroupmembersList), for: .touchUpInside)
        
        cell.memberslistbtn3ref.tag = indexPath.row
        cell.memberslistbtn3ref.addTarget(self, action: #selector(GroupmembersList), for: .touchUpInside)
        
        cell.deletebtnref.tag = indexPath.row
        cell.deletebtnref.addTarget(self, action: #selector(DeleteGroup), for: .touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "GroupMembersListVC") as! GroupMembersListVC
        if self.vcFrom == "CreateEvent_AddMember" || self.vcFrom == "CreateEvent_AddExtraMember"{
            if self.vcFrom == "CreateEvent_AddMember" {
                nxtVC.vcFrom = self.vcFrom
                nxtVC.AdvertiseStatus = self.AdvertiseStatus
                nxtVC.HostcontactStatus = self.HostcontactStatus
                //  nxtVC.MemberModel = self.MemberModel
                nxtVC.FirstScreenModel = self.FirstScreenModel
                nxtVC.secondScreenModelArr = self.secondScreenModelArr
            }else if self.vcFrom == "CreateEvent_AddExtraMember"{
                nxtVC.vcFrom = self.vcFrom
            }
        }else {
            nxtVC.vcFrom = "AddMember"
        }
        nxtVC.groupid = self.grouplistModel[indexPath.row].id ?? ""
        nxtVC.GroupName = self.grouplistModel[indexPath.row].gname ?? ""
        if isPresenter {
            nxtVC.isPresenter = true
            self.present(nxtVC, animated: true)
        } else {
            self.navigationController?.pushViewController(nxtVC, animated: true)
        }
        
     }
    
    
    @objc func EditNewGroup(sender: UIButton){
        //self.movetonextvc(id: "EditGroupVC", storyBordid: "SupportBoard")
        let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "EditGroupVC") as! EditGroupVC
      
        nxtVC.groupid = self.grouplistModel[sender.tag].id ?? ""
        nxtVC.groupName =  self.grouplistModel[sender.tag].gname ?? ""
        nxtVC.groupdiscription =  self.grouplistModel[sender.tag].gdesc ?? ""
        self.navigationController?.pushViewController(nxtVC, animated: true)

     }
    
    @objc func GroupmembersList(sender: UIButton){
       // self.movetonextvc(id: "GroupMembersListVC", storyBordid: "SupportBoard")
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "SupportBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "GroupMembersListVC") as! GroupMembersListVC
        if self.vcFrom == "CreateEvent_AddMember" || self.vcFrom == "CreateEvent_AddExtraMember"{
            if self.vcFrom == "CreateEvent_AddMember" {
                nxtVC.vcFrom = self.vcFrom
                nxtVC.AdvertiseStatus = self.AdvertiseStatus
                nxtVC.HostcontactStatus = self.HostcontactStatus
                //  nxtVC.MemberModel = self.MemberModel
                nxtVC.FirstScreenModel = self.FirstScreenModel
                nxtVC.secondScreenModelArr = self.secondScreenModelArr
                nxtVC.groupid = self.grouplistModel[sender.tag].id ?? ""
                nxtVC.GroupName = self.grouplistModel[sender.tag].gname ?? ""
                self.navigationController?.pushViewController(nxtVC, animated: true)
            }else if self.vcFrom == "CreateEvent_AddExtraMember"{
                nxtVC.vcFrom = self.vcFrom
                nxtVC.groupid = self.grouplistModel[sender.tag].id ?? ""
                nxtVC.GroupName = self.grouplistModel[sender.tag].gname ?? ""
                //self.navigationController?.pushViewController(nxtVC, animated: true)
                self.present(nxtVC, animated: true, completion: nil)
            }
        }else {
            nxtVC.vcFrom = "AddMember"
            nxtVC.groupid = self.grouplistModel[sender.tag].id ?? ""
            nxtVC.GroupName = self.grouplistModel[sender.tag].gname ?? ""
            self.navigationController?.pushViewController(nxtVC, animated: true)
        }
      

        
     }
    
    @objc func DeleteGroup(sender: UIButton){
        let alertController = UIAlertController(title: kApptitle, message: "Are you sure you want to delete this group?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
            self.DeleteTheGroupList(groupId:self.grouplistModel[sender.tag].id ?? "")
        }
        let CancelBtn = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
        }
        alertController.addAction(OKAction)
        alertController.addAction(CancelBtn)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func imageWith(name: String) -> UIImage {
           let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
           let nameLabel = UILabel(frame: frame)
           nameLabel.textAlignment = .center
           nameLabel.backgroundColor = .lightGray
           nameLabel.textColor = .white
           nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
           var initials = ""
           if let initialsArray = name.components(separatedBy: " ") as? [String]{
               if let firstWord = initialsArray.first {
                   if let firstLetter = firstWord.first {
                       initials += String(firstLetter).capitalized }
               }
               if initialsArray.count > 1, let lastWord = initialsArray.last {
                   if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                   }
               }
           }
//           else {
//               return nil
//           }
           nameLabel.text = initials
           UIGraphicsBeginImageContext(frame.size)
           if let currentContext = UIGraphicsGetCurrentContext() {
               nameLabel.layer.render(in: currentContext)
               let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage!
           }
           return UIImage(named: "UserLogo")!
       }
    
}

extension AllGroupListVC {
//MARK:- login func
func AllGroupList(){
    indicator.showActivityIndicator()
 
    var UserId = ""
    if  LognedUserType == "Soldier" {
        UserId = UserDefaults.standard.string(forKey: "SoldierId") ?? ""
    }else {
        UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
    }
    
    let parameters = [
         "id": UserId//(host id)
    ] as [String : Any]
    NetworkManager.Apicalling(url: API_URl.Get_Group_List_URL, paramaters: parameters, httpMethodType: .post, success: { (response:GroupsListModel) in
        print(response.data)
        if response.status == "1" {
            indicator.hideActivityIndicator()
            if let responsedata = response.data as? [GroupsListModel_data]{
            self.grouplistModel = responsedata
                self.NewGroupListtblref.reloadData()
                self.NewGroupListtblref.isHidden = false
                self.addNewGroupsmallBtnref.isHidden = false
            }else {
                self.NewGroupListtblref.isHidden = true
                self.addNewGroupsmallBtnref.isHidden = true
            }
            
            self.addNewGroupsmallBtnref.isHidden = self.isPresenter == true ? true : false
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
    
    func DeleteTheGroupList(groupId:String){
        indicator.showActivityIndicator()
     
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
             "id": UserId,//(host id)
             "groupid":groupId
         ]
        NetworkManager.Apicalling(url: API_URl.Delete_the_GroupURL, paramaters: parameters, httpMethodType: .post, success: { (response:GroupsListModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.AllGroupList()
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

