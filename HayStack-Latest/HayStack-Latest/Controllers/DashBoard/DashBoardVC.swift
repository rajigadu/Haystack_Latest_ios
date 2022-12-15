//
//  DashBoardVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
import CoreLocation
import GooglePlaces

class EventsCell: UICollectionViewCell {
    @IBOutlet weak var EventTitlelblref: UILabel!
}
class EventssecondCell: UICollectionViewCell {
    @IBOutlet weak var backViewref: UIView!
    
    @IBOutlet weak var EventInfoImgref: UIImageView!
    @IBOutlet weak var Eventtitlelblref: UILabel!
    @IBOutlet weak var Eventsubtitlelblref: UILabel!
    @IBOutlet weak var eventTimelblref: UILabel!
    @IBOutlet weak var eventdaylblref: UILabel!
    @IBOutlet weak var eventmonthlblref: UILabel!
    
    @IBOutlet weak var widthref: NSLayoutConstraint!
}

class DashBoardVC: UIViewController {
    @IBOutlet weak var YourEventColcref: UICollectionView!
    
    @IBOutlet weak var addressLblref: UILabel!
    
    @IBOutlet weak var currentDateLblref: UILabel!
    
    @IBOutlet weak var poppularEventsheightconstantref: NSLayoutConstraint!
    
    var timer = Timer()
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()

    var locality = ""
    var administrativeArea = ""
    var country = ""
    
    var defaultLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)

    var VcFrom = ""
    private var placesClient: GMSPlacesClient!

    var myadressselected = false
    var eventsArr = ["My Events","Interest","Attend","Invited"]
    
    var popularEventsArr:[SearchEventModeldata] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.delegate = self
        //myadressselected = false
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        placesClient = GMSPlacesClient.shared()
        //if self.VcFrom == "" {
        
      //  self.MyPopularEventsMehtod()
         self.currentTime()
        myadressselected = false
         
        
        
//        }else {
//            myadressselected = true
//        }
        
//        switch UIDevice.current.screenType {
//        case .iPhones_5_5s_5c_SE:
//            self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 260)
//        case .iPhones_6_6s_7_8:
//            self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 285)
//         default:
//            self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 285)
//
//        }
//         //self.Eventstblref.reloadData()
//        self.YourEventColcref.reloadData()
        
        self.MyPopularEventsMehtod()
        
    }
    
//    private func getCurrentTime() {
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
//    }

    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        self.currentDateLblref.text = formatter.string(from: Date())
       // self.addressLblref.text = locality + administrativeArea + country
       // myadressselected = false

     }


  
    @IBAction func searchForEventbtnref(_ sender: Any) {
        
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AllCategoryListVC") as! AllCategoryListVC
        nxtVC.allcategoryseen = "SearchEvent"
        self.navigationController?.pushViewController(nxtVC, animated: true)
        
     }
    
}

extension DashBoardVC : CLLocationManagerDelegate{
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
           // googlemapviewref.isMyLocationEnabled = true
//            googlemapviewref.settings.myLocationButton = true
//            googlemapviewref.settings.zoomGestures = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if let location = locations.first {
//
            defaultLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                 geocoder.reverseGeocodeLocation(CLLocation(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude), completionHandler:
                {(placemarks, error) in
            if (error != nil){
            print("reverse geodcode fail: \(error!.localizedDescription)")
            }
                    if let pm = placemarks as? [CLPlacemark] {
             if pm.count > 0 {
            let pm = placemarks![0]
            var addressString : String = ""
            if pm.subLocality != nil {
                addressString = addressString + pm.subLocality! + ", "
            }
            if pm.thoroughfare != nil {
                addressString = addressString + pm.thoroughfare! + ", "
            }
            if pm.locality != nil {
                addressString = addressString + pm.locality! + ", "
            }
            if pm.country != nil {
                addressString = addressString + pm.country! + ", "
            }
            if pm.postalCode != nil {
                addressString = addressString + pm.postalCode! + " "
            }
                // print(addressString)
           // self.CurrenLocation = addressString
                self.addressLblref.text = addressString
               
            }
                    }
            })
           // }
            
            if !(myadressselected){
                myadressselected = true
                self.MyPopularEventsMehtod()
            }
                 
        }
    }
    

    func userLocationString() -> String {
        let userLocationString = "\(locality), \(administrativeArea), \(country)"
        return userLocationString
    }
}
extension DashBoardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == YourEventColcref {
            return self.popularEventsArr.count
        }else {
            return eventsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
        if collectionView == YourEventColcref {
            return CGSize(width: self.view.frame.width, height: 250.0)
        }else {
            switch UIDevice.current.screenType {
            case .iPhones_5_5s_5c_SE:
                return CGSize(width: 158.0, height: 45.0)
            case .iPhones_6_6s_7_8:
                return CGSize(width: 158.0, height: 45.0)
            default:
                return CGSize(width: 158.0, height: 45.0)
            }
         }
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == YourEventColcref {
            let cell:EventssecondCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventssecondCell", for: indexPath) as! EventssecondCell
            cell.widthref.constant = self.view.frame.width - 32
            cell.backViewref.addBottomShadow()
            //Event Image
            if let url_str =  self.popularEventsArr[indexPath.row].photo  {
                cell.EventInfoImgref.sd_setImage(with: URL(string: API_URl.ImageBaseURL +  url_str), placeholderImage: UIImage(named: "papularEvent"))
                
                cell.EventInfoImgref.contentMode = .scaleAspectFill
            }else {
                cell.EventInfoImgref.contentMode = .scaleToFill
                cell.EventInfoImgref.image = UIImage(named: "papularEvent")
            }
            //Event Name
            if let eventName = self.popularEventsArr[indexPath.row].event_name {
                cell.Eventtitlelblref.text = eventName
            }
            //category
            if let category = self.popularEventsArr[indexPath.row].category {
                cell.Eventsubtitlelblref.text = category
            }
            //starttime
            if let starttime = self.popularEventsArr[indexPath.row].starttime {
                cell.eventTimelblref.text = starttime
            }
            //eventday
            if let eventday = self.popularEventsArr[indexPath.row].startdate {
                cell.eventdaylblref.text = self.inandoutDateFormate(inputDateformate: "MM-dd-yyyy", outputDateformate: "dd", inputdatestr: eventday)
            }
            if let eventMonth = self.popularEventsArr[indexPath.row].startdate {
                cell.eventmonthlblref.text = self.inandoutDateFormate(inputDateformate: "MM-dd-yyyy", outputDateformate: "MMM", inputdatestr: eventMonth)
                //cell.eventmonthlblref.text = eventMonth
            }
          
           
            return cell
        }else {
        let cell:EventsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventsCell", for: indexPath) as! EventsCell
            cell.EventTitlelblref.text = eventsArr[indexPath.row]
        return cell
        }
    }
    
    
    
    
    func inandoutDateFormate(inputDateformate:String,outputDateformate:String,inputdatestr:String)-> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputDateformate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputDateformate

        let date: Date? = dateFormatterGet.date(from: inputdatestr)
         return dateFormatter.string(from: date!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == YourEventColcref {
            //self.movetonextvc(id: "SearchEventInfoVC", storyBordid: "DashBoard")
            let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchEventInfoVC") as! SearchEventInfoVC
            nxtVC.VcFrom = "DashBoard"
            nxtVC.HomeDelegate = self
            nxtVC.MySearchedEventsArr = self.popularEventsArr[indexPath.row]
            self.navigationController?.pushViewController(nxtVC, animated: true)
            
         }else {
            let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "MyEventsVC") as! MyEventsVC
             nxtVC.selectedBtnName = self.eventsArr[indexPath.row]
            self.navigationController?.pushViewController(nxtVC, animated: true)
            //self.movetonextvc(id: "MyEventsVC", storyBordid: "DashBoard")
        }
    }
    
    //MARK:- login func
    func MyPopularEventsMehtod(){
         indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
 
         let parameters = [
            "id":UserId,
            "latitude":"\(defaultLocation.coordinate.latitude)",
            "longitude":"\(defaultLocation.coordinate.longitude)",
            "category":"",
            "searchtype":"",
            "currentdate":"",
            "endtime":"",
            "device_type":"IOS",
            "device_id":UIDevice.current.identifierForVendor!.uuidString,
            "device_token":newDeviceId
            
         ] as! [String:String]
        NetworkManager.Apicalling(url: API_URl.popularEvent_URL, paramaters: parameters, httpMethodType: .post, success: { (response:MyEventsModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let response = response.data as? [SearchEventModeldata] {
                    self.popularEventsArr = response
                    
                    switch UIDevice.current.screenType {
                    case .iPhones_5_5s_5c_SE:
                        self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 255)
                    case .iPhones_6_6s_7_8:
                        self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 280)
                     default:
                        self.poppularEventsheightconstantref.constant = CGFloat(self.popularEventsArr.count * 280)

                    }
                     //self.Eventstblref.reloadData()
                    self.YourEventColcref.reloadData()
                }
             }else {
                indicator.hideActivityIndicator()
                //self.ShowAlert(message: response.message ?? "Something went wrong...")
            }
        }) { (errorMsg) in
            
            indicator.hideActivityIndicator()
            if let err = errorMsg as? String{
                self.ShowAlert(message: err)
            }
        }
    }
    
    
}
extension DashBoardVC :HomeScreenDelegate ,UITabBarControllerDelegate{
    func HomeScreenData(VcFrom: String) {
        myadressselected = true
        //self.currentTime()
    }
    
    

func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
      let tabBarIndex = tabBarController.selectedIndex
      
      print(tabBarIndex)
      
      if tabBarIndex == 0 {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        var navigation = UINavigationController()
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
//        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
//        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//            navigation = UINavigationController(rootViewController: initialViewControlleripad)
//
//        appDelegate.window?.rootViewController = navigation
//        appDelegate.window?.makeKeyAndVisible()
       }
  }
}
