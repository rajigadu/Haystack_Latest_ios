//
//  PublishingEventVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 14/05/21.
//

import UIKit
import CoreLocation

class publishEventCell: UITableViewCell{
    @IBOutlet weak var UserNameLblref: UILabel!
    @IBOutlet weak var UserEmailLblref: UILabel!
    @IBOutlet weak var UserNumberLblref: UILabel!
     
    @IBOutlet weak var EditBtnref: UIButton!
    @IBOutlet weak var deleteBtnref: UIButton!
}

class PublishingEventVC: UIViewController {
    var MemberModel: CreateEventMemberFourthModel?
    var MemberModelArr: [CreateEventMemberFourthModel] = []
    
    
    var AdvertiseStatus = ""
    var HostcontactStatus = ""
    var FirstScreenModel: CreateEventFirstModel?
    var secondScreenModelArr: [CategorySecondModel] = []
    
    
    let manager = CLLocationManager()
    
    var currentLocLat = ""
    var currentLocLong = ""
    let geocoder = CLGeocoder()
    var skipBtn = true

    
    @IBOutlet weak var MebersListTblref: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if skipBtn  {
        if MemberModel?.memberNumber != "" || MemberModel?.memberNumber != nil {
            self.MemberModelArr.append(CreateEventMemberFourthModel(membername: MemberModel?.membername ?? "", memberNumber: MemberModel?.memberNumber ?? "", memberEmail: MemberModel?.memberEmail ?? ""))
        }
        }
        
        print(AdvertiseStatus,HostcontactStatus)
    }
    
    @IBAction func popBackbtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func addMore(_ sender: Any) {
         let storyboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddExtraMeberToEventVC")  as! AddExtraMeberToEventVC
        vc.AddExtraMeberdelegate = self
        self.present(vc, animated: true)


     }
    
    @IBAction func publishBntref(_ sender: Any) {
        indicator.showActivityIndicator()
         if let cityname = self.FirstScreenModel?.CityName as? String,let satename =  self.FirstScreenModel?.StateName as? String,let countrycode =  self.FirstScreenModel?.CountryName as? String,let pincode = self.FirstScreenModel?.ZipCode as? String {
             let myAddress =  cityname + "," + satename + ","  + countrycode + ","  + pincode
              self.findMyAddressLatAndLong(Address: myAddress)
         }else {
            self.PublishingEventToLive(lat: self.currentLocLat,Long: self.currentLocLong)
         }
    }
    
    func findMyAddressLatAndLong(Address:String){
        geocoder.geocodeAddressString(Address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
                self.PublishingEventToLive(lat: "", Long: "")
            }
            if let placemark = placemarks?.first {
                if let coordinates:CLLocationCoordinate2D = placemark.location?.coordinate{
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                    self.PublishingEventToLive(lat: "\(coordinates.latitude)", Long: "\(coordinates.longitude)")
                  }
               
             }
        })
    }
    
}

extension PublishingEventVC :UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections_nodata(in: tableView, ArrayCount: self.MemberModelArr.count, numberOfsections: 1, data_MSG_Str: "No Members were added!")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MemberModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: publishEventCell = tableView.dequeueReusableCell(withIdentifier: "publishEventCell", for: indexPath) as! publishEventCell
        cell.UserNameLblref.text = self.MemberModelArr[indexPath.row].membername 
        cell.UserEmailLblref.text = self.MemberModelArr[indexPath.row].memberEmail 
        cell.UserNumberLblref.text = self.MemberModelArr[indexPath.row].memberNumber
        
        
        cell.deleteBtnref.tag = indexPath.row
        cell.deleteBtnref.addTarget(self, action: #selector(DeleteEventbtn), for: .touchUpInside)
        
        cell.EditBtnref.tag = indexPath.row
        cell.EditBtnref.addTarget(self, action: #selector(EditEventbtn), for: .touchUpInside)
        return cell
    }
    @objc func DeleteEventbtn(sender: UIButton){
       // if self.MemberModelArr.count < sender.tag {
            if self.MemberModelArr[sender.tag].memberNumber != "" {
                self.MemberModelArr.remove(at: sender.tag)
            }
       // }
        
        self.MebersListTblref.reloadData()
    }
    
    @objc func EditEventbtn(sender: UIButton){
        let storyboard = UIStoryboard(name: "DashBoard", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "AddExtraMeberToEventVC")  as! AddExtraMeberToEventVC
       vc.UpdateExtraMeberdelegate = self
        vc.vcFrom = "EditMember"
       // if self.MemberModelArr.count < sender.tag {
       
       // }
        
        if self.MemberModelArr[sender.tag].memberNumber != "" {
            
            vc.memberNumber = self.MemberModelArr[sender.tag].memberNumber ?? ""
            vc.memberName = self.MemberModelArr[sender.tag].membername ?? ""
            vc.memberEmail = self.MemberModelArr[sender.tag].memberEmail ?? ""
            
            
            self.MemberModelArr.remove(at: sender.tag)
        }
        
        self.MebersListTblref.reloadData()
       self.present(vc, animated: true)
        
        
    }
    
}
extension PublishingEventVC :AddExtraMeberToEventDelegate {
    func AddExtraMeberToEventData(Data: CreateEventMemberFourthModel) {
        if Data.memberNumber != "" {
            self.MemberModelArr.append(CreateEventMemberFourthModel(membername: Data.membername , memberNumber: Data.memberNumber  , memberEmail: Data.memberEmail  ))
            
            self.MebersListTblref.reloadData()
        }
    }
    
    
}
extension PublishingEventVC :UpdateExtraMeberToEventDelegate {
    func UpdateExtraMeberToEventData(Data: CreateEventMemberFourthModel) {
        if Data.memberNumber != "" {
            self.MemberModelArr.append(CreateEventMemberFourthModel(membername: Data.membername , memberNumber: Data.memberNumber  , memberEmail: Data.memberEmail  ))
            
            self.MebersListTblref.reloadData()
        }
    }
    
    
}
extension PublishingEventVC {
   
    
    //MARK:- login func
    func PublishingEventToLive(lat: String,Long: String){
        //indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        var categoryId = ""
        var categoryName = ""
        var categoryIDArr : [String] = []
        var categoryNameArr : [String] = []
        for i in 0..<self.secondScreenModelArr.count{
            categoryIDArr.append(self.secondScreenModelArr[i].Category_id)
            categoryNameArr.append(self.secondScreenModelArr[i].CategoryName)
        }
        
        categoryId = categoryIDArr.joined(separator: ",")
        categoryName = categoryNameArr.joined(separator: ",")
        var imageData = Data()
//        if let img = FirstScreenModel?.EventImage {
//            if let datastr:Data = img.pngData() {
//               // Handle operations with data here...
//                imageData = datastr
//            }
//        }
        
        
        var parameters = [
            "event_name":FirstScreenModel?.EventName,
            "streetaddress":FirstScreenModel?.StreetAddress,
            "city":FirstScreenModel?.CityName,
            "id":UserId,
            "state":FirstScreenModel?.StateName,
            "zipcode":FirstScreenModel?.ZipCode,
            "startdate":FirstScreenModel?.StartDate,
            "starttime":FirstScreenModel?.StartTime,
            "enddate":FirstScreenModel?.EndDate,
            "endtime":FirstScreenModel?.EndTime,
            "hostname":FirstScreenModel?.HostName,
            "contactinfo":FirstScreenModel?.ContactEmailOrPass,
            //"eventtype":FirstScreenModel?.HostType,
            "event_description":FirstScreenModel?.EventDiscription,
           // "eventtype":categoryName,
            "country":FirstScreenModel?.CountryName,
//            "latitude":self.currentLocLat,
//            "longitude":self.currentLocLong,
            "latitude":lat,
            "longitude":Long,
            "category":categoryId,
            
            "eventtype":self.AdvertiseStatus,
            "hosttype":self.HostcontactStatus,
            
//            "allmembers[0][member]":harvinder
//            "allmembers[0][email]":harvinder@anaad.net
//            "allmembers[0][number]":7307151068
//            "allmembers[1][member]":Rajesh
//            
//            "allmembers[1][email]":raji@anaad.net
//            "allmembers[1][number]":8360757603
        ] as! [String: String]
        
        for i in 0..<self.MemberModelArr.count{
            parameters.updateValue(self.MemberModelArr[i].membername, forKey: "allmembers[\(i)][member]")
            parameters.updateValue(self.MemberModelArr[i].memberEmail, forKey: "allmembers[\(i)][email]")
            parameters.updateValue(self.MemberModelArr[i].memberNumber, forKey: "allmembers[\(i)][number]")
        }
 
        NetworkManager2.Apicalling(url: API_URl.CreateNewEvent_URL, paramaters: parameters, ImageData: FirstScreenModel?.EventImage, imagetype: FirstScreenModel?.imagetype ?? "jpg", httpMethodType: .post, success: { (response:UserModel) in
             if response.status == "1" {
                indicator.hideActivityIndicator()
                 self.movetonextvc(id: "finalSuccessEventVC", storyBordid: "DashBoard")
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
extension PublishingEventVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations[0] as? CLLocation{
 
            self.currentLocLat = "\(location.coordinate.latitude)"
            self.currentLocLong = "\(location.coordinate.longitude)"
        }

    }
}
