//
//  EventInfoVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 29/05/21.
//

import UIKit
import IQKeyboardManagerSwift
class EventInfoVC: UIViewController {
    @IBOutlet weak var headerViewref: UIView!
    @IBOutlet weak var eventImgref: UIImageView!
    
    @IBOutlet weak var EventNametfref: UITextField!
    @IBOutlet weak var streetAddressTfref: UITextField!
    @IBOutlet weak var cityTfref: UITextField!
    @IBOutlet weak var stateTfref: UITextField!
    @IBOutlet weak var zipCodeTfref: UITextField!
    @IBOutlet weak var countryNameTfref: UITextField!
    @IBOutlet weak var hostNameTfref: UITextField!
    @IBOutlet weak var hostTypeTfref: UITextField!
    @IBOutlet weak var ContactInfoTfref: UITextField!
    @IBOutlet weak var StartDateTfref: UITextField!
    @IBOutlet weak var StartTimeTfref: UITextField!
    @IBOutlet weak var EndDateTfref: UITextField!
    @IBOutlet weak var EndTimeTfref: UITextField!
    @IBOutlet weak var EventDiscription: IQTextView!
    @IBOutlet weak var StateBntref: UIButton!
    
    var MyEventsDetails : SearchEventModeldata?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerViewref.addBottomShadow()
        // Do any additional setup after loading the view.
        
        self.showEventDetails()
    }
    
    @IBAction func backBntref(_ sender: Any) {
        self.popToBackVC()
    }
    
    
    func showEventDetails(){
        //Event Name
        if let eventName = self.MyEventsDetails?.event_name {
            self.EventNametfref.text = eventName
        }
        //Event Image
        if let url_str =  self.MyEventsDetails?.photo  {
            self.eventImgref.sd_setImage(with: URL(string: API_URl.ImageBaseURL + url_str), placeholderImage: UIImage(named: "addEventimg"))
         }
        
        //Host name
        if let hostName = self.MyEventsDetails?.hostname {
            self.hostNameTfref.text = hostName
        }
        //Contact Info
        if let ContactInfo = self.MyEventsDetails?.contactinfo {
            self.ContactInfoTfref.text = ContactInfo
        }
        //Country name
        if let Countryname = self.MyEventsDetails?.country {
            self.countryNameTfref.text = Countryname
        }
        //State name
        if let Statename = self.MyEventsDetails?.state {
            self.stateTfref.text = Statename
        }
        //City
        if let Cityname = self.MyEventsDetails?.city {
            self.cityTfref.text = Cityname
        }
        //street code
        if let streetaddress = self.MyEventsDetails?.streetaddress {
            self.streetAddressTfref.text = streetaddress
        }
        //Zip code
        if let zipcode = self.MyEventsDetails?.zipcode {
            self.zipCodeTfref.text = zipcode
        }
        //start date
        if let startdate = self.MyEventsDetails?.startdate {
            self.StartDateTfref.text = startdate
        }
        //start time
        if let starttime = self.MyEventsDetails?.starttime {
            self.StartTimeTfref.text = starttime
        }
        //end date
        if let enddate = self.MyEventsDetails?.enddate {
            self.EndDateTfref.text = enddate
        }
        //end time
        if let endtime = self.MyEventsDetails?.endtime {
            self.EndTimeTfref.text = endtime
        }
        //event discription
        if let eventdiscription = self.MyEventsDetails?.event_description {
            self.EventDiscription.text = eventdiscription
        }
        
    }

    @IBAction func navigateBntref(_ sender: Any) {
        self.openGoogleMap()
             
    }
    func openGoogleMap() {
        guard let lat = Double(self.MyEventsDetails?.latitude ?? "") as? Double else{
             return
          }
        guard let long = Double(self.MyEventsDetails?.longitude ?? "") as? Double else {
         return
      }
        
        
          if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

              if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:])
               }}
          else {
                 //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                                   UIApplication.shared.open(urlDestination)
                               }
                    }

            }
    
    
}
