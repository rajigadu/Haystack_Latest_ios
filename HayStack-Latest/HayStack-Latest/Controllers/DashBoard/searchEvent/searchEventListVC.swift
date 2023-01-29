//
//  searchEventListVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit

class searchEventCell: UITableViewCell {
    @IBOutlet weak var backViewref: UIView!
    @IBOutlet weak var MyEventNamelblref: UILabel!
    @IBOutlet weak var MyEventHostNamelblref: UILabel!
    @IBOutlet weak var MyEventHostCoantactInfoLblef: UILabel!
    @IBOutlet weak var EventPeopleCountlblref: UILabel!
    @IBOutlet weak var firsrMemberBtnref: UIButton!
    @IBOutlet weak var seconMemberBntref: UIButton!
    @IBOutlet weak var thirdMemberBtnref: UIButton!
}

class searchEventListVC: UIViewController {
    
    var currentAddressModel : AddressStruct?
    var searchType = ""
    var distance_miles = ""
    var nationwide = ""
    var SearchScreenModelArr: [CategorySecondModel] = []
    var searchEventDate :searchEventDateModel?
    
    var MySearchedEventsArr : [SearchEventModeldata] = []

    @IBOutlet weak var searchEventtblref: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchEventtblref.reloadData()
        // Do any additional setup after loading the view.
        //Api Calling...
        self.SearchEventMethod()
    }
    
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func moveToDashBoardbtnref(_ sender: Any) {
        self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")
    }
    

}
extension searchEventListVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MySearchedEventsArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: searchEventCell = tableView.dequeueReusableCell(withIdentifier: "searchEventCell", for: indexPath) as! searchEventCell
        cell.backViewref.layer.shadowColor = UIColor.gray.cgColor
        cell.backViewref.layer.masksToBounds = false
        cell.backViewref.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
        cell.backViewref.layer.shadowOpacity = 1.0
        cell.backViewref.layer.shadowRadius = 1.0
        
        if let myeventName = self.MySearchedEventsArr[indexPath.row].event_name {
            cell.MyEventNamelblref.text = myeventName
        }
        
        if let Hostname = self.MySearchedEventsArr[indexPath.row].hostname {
            cell.MyEventHostNamelblref.text = Hostname
        }
        
        if let contactInfo = self.MySearchedEventsArr[indexPath.row].contactinfo {
            cell.MyEventHostCoantactInfoLblef.text = contactInfo
        }
        
        if let membercount = self.MySearchedEventsArr[indexPath.row].membercount {
            if membercount == "0"{
                cell.firsrMemberBtnref.isHidden = true
                cell.seconMemberBntref.isHidden = true
                cell.thirdMemberBtnref.isHidden = true
                cell.EventPeopleCountlblref.isHidden = true
            }else {
            cell.EventPeopleCountlblref.text = "People (\(membercount))"
                cell.firsrMemberBtnref.isHidden = false
                cell.seconMemberBntref.isHidden = false
                cell.thirdMemberBtnref.isHidden = false
                cell.EventPeopleCountlblref.isHidden = false
            }
        }else {
            cell.firsrMemberBtnref.isHidden = true
            cell.seconMemberBntref.isHidden = true
            cell.thirdMemberBtnref.isHidden = true
            cell.EventPeopleCountlblref.isHidden = true
        }
         return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.movetonextvc(id: "SearchEventInfoVC", storyBordid: "DashBoard")
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchEventInfoVC") as! SearchEventInfoVC
        nxtVC.MySearchedEventsArr = self.MySearchedEventsArr[indexPath.row]
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
}
extension searchEventListVC {
   
    
    //MARK:-
    func SearchEventMethod(){
        indicator.showActivityIndicator()
        var categoryId = ""
        var categoryName = ""
        var categoryIDArr : [String] = []
        var categoryNameArr : [String] = []
        for i in 0..<self.SearchScreenModelArr.count{
            categoryIDArr.append(self.SearchScreenModelArr[i].Category_id)
            categoryNameArr.append(self.SearchScreenModelArr[i].CategoryName)
        }
        
        categoryId = categoryIDArr.joined(separator: ",")
        categoryName = categoryNameArr.joined(separator: ",")
        
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        var  parameters = Dictionary<String,String>()
         parameters = [
            "id":UserId,
            "searchType":searchType,
            "address":currentAddressModel?.addressstr ?? "",
            "country":currentAddressModel?.countrystr ?? "",
            "state":currentAddressModel?.statestr ?? "",
            "zip":currentAddressModel?.pincodestr ?? "",
            "city":currentAddressModel?.citystr ?? "",
            "startdate":searchEventDate?.startDate ?? "",
            "enddate":searchEventDate?.EndDate ?? "",
            "starttime":searchEventDate?.startTime ?? "",
            "endtime":searchEventDate?.EndTime ?? "",
            "distance_miles":self.distance_miles,
            "nationwide":self.nationwide,
            "latitude":currentAddressModel?.latstr ?? "",
            "longitude":currentAddressModel?.longstr ?? "",
            "category":categoryId
         ]
        NetworkManager.Apicalling(url: API_URl.Search_for_Event_URL, paramaters: parameters, httpMethodType: .post, success: { (response:SearchEventModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                 if let response = response.data as? [SearchEventModeldata]{
                    self.MySearchedEventsArr = response
                    self.searchEventtblref.reloadData()
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
}
