//
//  SearchEventInfoVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

protocol HomeScreenDelegate{
    func HomeScreenData(VcFrom: String)
}

class SearchEventInfoVC: UIViewController {
    
    
    @IBOutlet weak var eventImgref: UIImageView!
    @IBOutlet weak var EventNametfref: UITextField!
    @IBOutlet weak var streetAddressTfref: UITextField!
    @IBOutlet weak var cityTfref: UITextField!
    @IBOutlet weak var stateTfref: UITextField!
    @IBOutlet weak var zipCodeTfref: UITextField!
    @IBOutlet weak var countryNameTfref: UITextField!
    @IBOutlet weak var hostNameTfref: UITextField!
    @IBOutlet weak var ContactInfoTfref: UITextField!
    @IBOutlet weak var StartDateTfref: UITextField!
    @IBOutlet weak var StartTimeTfref: UITextField!
    @IBOutlet weak var EndDateTfref: UITextField!
    @IBOutlet weak var EndTimeTfref: UITextField!
    @IBOutlet weak var EventDiscription: IQTextView!
 
    var MySearchedEventsArr : SearchEventModeldata?
    
    
    var VcFrom = ""
    var HomeDelegate :HomeScreenDelegate?
    var popularEventsArr:nearByEventsModelData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.showEventDetails()
     }
    
    func showEventDetails(){
        
        if VcFrom == "MapView" {
            //Event Name
            if let eventName = self.popularEventsArr?.event_name {
                self.EventNametfref.text = eventName
            }
            //Event Image
            if let url_str =  self.popularEventsArr?.photo as? String  {
                self.eventImgref.sd_setImage(with: URL(string: API_URl.ImageBaseURL + url_str), placeholderImage: UIImage(named: "addEventimg"))
             }
            
            //Host name
            if let hostName = self.popularEventsArr?.hostname {
                self.hostNameTfref.text = hostName
            }
            //Contact Info
            if let ContactInfo = self.popularEventsArr?.contactinfo {
                self.ContactInfoTfref.text = ContactInfo
            }
            //Country name
            if let Countryname = self.popularEventsArr?.country {
                self.countryNameTfref.text = Countryname
            }
            //State name
            if let Statename = self.popularEventsArr?.state {
                self.stateTfref.text = Statename
            }
            //City
            if let Cityname = self.popularEventsArr?.city {
                self.cityTfref.text = Cityname
            }
            //street code
            if let streetaddress = self.popularEventsArr?.streetaddress {
                self.streetAddressTfref.text = streetaddress
            }
            //Zip code
            if let zipcode = self.popularEventsArr?.zipcode {
                self.zipCodeTfref.text = zipcode
            }
            //start date
            if let startdate = self.popularEventsArr?.startdate {
                self.StartDateTfref.text = startdate
            }
            //start time
            if let starttime = self.popularEventsArr?.starttime {
                self.StartTimeTfref.text = starttime
            }
            //end date
            if let enddate = self.popularEventsArr?.enddate {
                self.EndDateTfref.text = enddate
            }
            //end time
            if let endtime = self.popularEventsArr?.endtime {
                self.EndTimeTfref.text = endtime
            }
            //event discription
            if let eventdiscription = self.popularEventsArr?.event_description {
                self.EventDiscription.text = eventdiscription
            }
        }else {
        //Event Name
        if let eventName = self.MySearchedEventsArr?.event_name {
            self.EventNametfref.text = eventName
        }
        //Event Image
        if let url_str =  self.MySearchedEventsArr?.photo as? String  {
            self.eventImgref.sd_setImage(with: URL(string: API_URl.ImageBaseURL + url_str), placeholderImage: UIImage(named: "addEventimg"))
         }
        
        //Host name
        if let hostName = self.MySearchedEventsArr?.hostname {
            self.hostNameTfref.text = hostName
        }
        //Contact Info
        if let ContactInfo = self.MySearchedEventsArr?.contactinfo {
            self.ContactInfoTfref.text = ContactInfo
        }
        //Country name
        if let Countryname = self.MySearchedEventsArr?.country {
            self.countryNameTfref.text = Countryname
        }
        //State name
        if let Statename = self.MySearchedEventsArr?.state {
            self.stateTfref.text = Statename
        }
        //City
        if let Cityname = self.MySearchedEventsArr?.city {
            self.cityTfref.text = Cityname
        }
        //street code
        if let streetaddress = self.MySearchedEventsArr?.streetaddress {
            self.streetAddressTfref.text = streetaddress
        }
        //Zip code
        if let zipcode = self.MySearchedEventsArr?.zipcode {
            self.zipCodeTfref.text = zipcode
        }
        //start date
        if let startdate = self.MySearchedEventsArr?.startdate {
            self.StartDateTfref.text = startdate
        }
        //start time
        if let starttime = self.MySearchedEventsArr?.starttime {
            self.StartTimeTfref.text = starttime
        }
        //end date
        if let enddate = self.MySearchedEventsArr?.enddate {
            self.EndDateTfref.text = enddate
        }
        //end time
        if let endtime = self.MySearchedEventsArr?.endtime {
            self.EndTimeTfref.text = endtime
        }
        //event discription
        if let eventdiscription = self.MySearchedEventsArr?.event_description {
            self.EventDiscription.text = eventdiscription
        }
        }
        
    }
    

    @IBAction func backBtnref(_ sender: Any) {
        if VcFrom == "DashBoard"{
             self.HomeDelegate?.HomeScreenData(VcFrom: "EventInfo")
            self.popToBackVC()
        }else {
        self.popToBackVC()
        }
    }
    
    @IBAction func attendBtnref(_ sender: Any) {
        self.Add_Attend_to_Event_Method()
    }
    
    @IBAction func IntrestedBntref(_ sender: Any) {
        self.Add_Intrested_to_Event_Method()
     }
 
    @IBAction func notIntrestedBtnref(_ sender: Any) {
        //self.movetonextvc(id: "DashBoardVC", storyBordid: "DashBoard")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var navigation = UINavigationController()
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            navigation = UINavigationController(rootViewController: initialViewControlleripad)
      
        appDelegate.window?.rootViewController = navigation
        appDelegate.window?.makeKeyAndVisible()
     }
    
    
    
}
extension SearchEventInfoVC {
   
    
    //MARK:-
    func Add_Attend_to_Event_Method(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        var searchEventId  = ""
        var hostID = ""
        if VcFrom == "MapView" {
            searchEventId = popularEventsArr?.id ?? ""
            hostID = popularEventsArr?.userid ?? ""
         }else {
            searchEventId = MySearchedEventsArr?.id ?? ""
            hostID = MySearchedEventsArr?.userid ?? ""

        }
        let parameters = [
            "eventid":searchEventId,
            "id":UserId,//(loggined user id)
            "userid":hostID//(host id)
        ] as! [String:String]
        NetworkManager.Apicalling(url: API_URl.AttendedToEventURL, paramaters: parameters, httpMethodType: .post, success: { (response:SearchEventModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                // self.movetonextvc(id: "MyEventsVC", storyBordid: "DashBoard")
                let alertController = UIAlertController(title: kApptitle, message: response.message ?? "Event added successfully.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                    let nxtVC = Storyboard.instantiateViewController(withIdentifier: "MyEventsVC") as! MyEventsVC
                    nxtVC.selectedBtnName = "Attend"
                    self.navigationController?.pushViewController(nxtVC, animated: true)
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
    
    //MARK:-
    func Add_Intrested_to_Event_Method(){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        var searchEventId  = ""
        var hostID = ""
        if VcFrom == "MapView" {
            searchEventId = popularEventsArr?.id ?? ""
            hostID = popularEventsArr?.userid ?? ""
         }else {
            searchEventId = MySearchedEventsArr?.id ?? ""
            hostID = MySearchedEventsArr?.userid ?? ""

        }
        let parameters = [
             "eventid":searchEventId,
            "id":UserId,//(loggined user id)
            "userid":hostID//(host id)
        ] as! [String:String]
        NetworkManager.Apicalling(url: API_URl.IntrestedToEventURL, paramaters: parameters, httpMethodType: .post, success: { (response:SearchEventModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                let alertController = UIAlertController(title: kApptitle, message: response.message ?? "Event added successfully.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                    let nxtVC = Storyboard.instantiateViewController(withIdentifier: "MyEventsVC") as! MyEventsVC
                    nxtVC.selectedBtnName = "Interest"
                    self.navigationController?.pushViewController(nxtVC, animated: true)
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
