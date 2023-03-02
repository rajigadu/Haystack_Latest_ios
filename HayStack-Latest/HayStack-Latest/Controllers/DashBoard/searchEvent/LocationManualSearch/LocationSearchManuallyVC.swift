//
//  LocationSearchManuallyVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces
//class searchEventCell2: UITableViewCell {
//    @IBOutlet weak var backViewref: UIView!
//
//    @IBOutlet weak var MyEventNamelblref: UILabel!
//    @IBOutlet weak var MyEventHostNamelblref: UILabel!
//    @IBOutlet weak var MyEventHostCoantactInfoLblef: UILabel!
//    @IBOutlet weak var EventPeopleCountlblref: UILabel!
//    @IBOutlet weak var firsrMemberBtnref: UIButton!
//    @IBOutlet weak var seconMemberBntref: UIButton!
//    @IBOutlet weak var thirdMemberBtnref: UIButton!
//    @IBOutlet weak var infoBtnref: UIButton!
//}
//struct AddressStruct {
//    var citystr : String
//    var statestr : String
//    var countrystr : String
//    var pincodestr : String
//    var addressstr : String
//    var latstr : String
//    var longstr : String
//}
//
//protocol SearchEventScreenDelegate{
//    func SearchEventScreenData(Data: [CategorySecondModel])
//}

class LocationSearchManuallyVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var googlemapviewref: GMSMapView!
    @IBOutlet weak var searchFeildLocTfref: UITextField!
    @IBOutlet weak var RadiusTfref: UITextField!
    
    @IBOutlet weak var ManualSearchView: UIView!
    @IBOutlet weak var manualSearchViewHeightref: NSLayoutConstraint!
    @IBOutlet weak var nationWideswitchbtnref: UISwitch!
    @IBOutlet weak var NationWideselectionbtnref: UIButton!
    
    @IBOutlet weak var radusHeightref: NSLayoutConstraint!
    
    @IBOutlet weak var EventBackViewref: UIView!
    
    @IBOutlet weak var EventbackWeidthref: NSLayoutConstraint!
    @IBOutlet weak var eventtblref: UITableView!
    
    @IBOutlet weak var memuIconBtnref: UIButton!
    @IBOutlet weak var menuLeadref: NSLayoutConstraint!
    
    //Manual Search
    @IBOutlet weak var cityTfref: UITextField!
    @IBOutlet weak var stateTFref: UITextField!
    @IBOutlet weak var zipCodeTFref: UITextField!
    @IBOutlet weak var addressTFref: UITextField!
    @IBOutlet weak var countrynameTfref: UITextField!
    @IBOutlet weak var StateBntref: UIButton!

    
    @IBOutlet weak var addManualAddressbtn: UIButton!
    var SearchScreenModelArr: [CategorySecondModel] = []
    var SearchEventDelegate :SearchEventScreenDelegate?
    var isManualSearchEnable = false
    let locationManager = CLLocationManager()
    
    var defaultLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var defaultLocation2 = CLLocation(latitude: 42.361145, longitude: -71.057083)

    var zoomLevel: Float = 15.0
    let marker : GMSMarker = GMSMarker()
    var isPlaceSearching = false
    var CurrentDatestr = ""
    var CurrentTimeStr = ""
    let geocoderstr = GMSGeocoder()
    
    let geocoder = CLGeocoder()
    var CurrenLocation = ""
    var myadressselected = false
    
    var UserName = ""
    var isnationWide = "0"
    var DistanceInKM = ""
    var popularEventsArr:[nearByEventsModelData] = []
    var currentAddressModel : AddressStruct?
    var currentAddressModel2 : AddressStruct?
    var markerPosition : CGPoint!
    
    var IsMenuOpend = false
    
    //Manual Search
    var Countrypickerview = UIPickerView()
    var Statepickerview2 = UIPickerView()
   // var isnationWide = ""
    var distance_miles = ""
    var CountryModel : [countryModelData] = []
    var StateModel : [StateModelData] = []
    var latstr = ""
    var longstr = ""
    //var SearchScreenModelArr: [CategorySecondModel] = []
   // let geocoder = CLGeocoder()
    var searchLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var delegatestr : ManualAddessDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addManualAddressbtn.setImage(UIImage(systemName: "arrow.up.square"), for: .normal)

        isPlaceSearching = false
        self.currentTimeforApi()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        googlemapviewref.delegate = self
        googlemapviewref.isMyLocationEnabled = true
        googlemapviewref.settings.myLocationButton = true
        googlemapviewref.settings.zoomGestures = true
        googlemapviewref.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        googlemapviewref.settings.myLocationButton = true
        googlemapviewref.settings.indoorPicker = false
        
        
        if UserDefaults.standard.string(forKey: "LoginedUserType") == "Soldier"{
            if let UserNamestr = UserDefaults.standard.string(forKey: "SoldierUsername") {
                UserName = UserNamestr
            }
        }else {
            if let UserNamestr = UserDefaults.standard.string(forKey: "SpouseUserName") {
                UserName = UserNamestr
            }
        }
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                switch (CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                }
            } else {
                print("Location services are not enabled")
            }
        }
        IsMenuOpend = true
        self.EventbackWeidthref.constant = 0
        self.memuIconBtnref.setImage(#imageLiteral(resourceName: "menuForward"), for: .normal)
        self.EventBackViewref.isHidden = true
        self.menuLeadref.constant = 0
        
        //ManualSearch Loading...
        self.LoadManuallSearchfeilds()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        //isPlaceSearching = false
    }
    
    func LoadManuallSearchfeilds() {
        //Statepicker
        countrynameTfref.inputView = Countrypickerview
        countrynameTfref.textAlignment = .left
        countrynameTfref.placeholder = "Select Your Country"

        Countrypickerview.delegate = self
        Countrypickerview.dataSource = self
        
        self.countrynameTfref.text = "United States"
        
        stateTFref.delegate = self
       // self.stateTfref.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
       

        //Countrypicker
        stateTFref.inputView = Statepickerview2
        stateTFref.textAlignment = .left
        stateTFref.placeholder = "Select Your State"
        stateTFref.delegate = self
        Statepickerview2.delegate = self
        Statepickerview2.dataSource = self
        
        
       

        //Api Calling...
        self.getCountryListMethos()
    }
    
    @IBAction func MenuIconBntref(_ sender: Any) {
         if IsMenuOpend  {
            IsMenuOpend = false
            self.memuIconBtnref.setImage(#imageLiteral(resourceName: "MenuBackward"), for: .normal)
            self.EventBackViewref.isHidden = false
            UIView.animate(withDuration: 1) {
                self.EventbackWeidthref.constant = 240
                self.menuLeadref.constant = 241
                self.view.layoutIfNeeded()
            }
         }else {
            IsMenuOpend = true
            self.memuIconBtnref.setImage(#imageLiteral(resourceName: "menuForward"), for: .normal)
            self.EventBackViewref.isHidden = true
            UIView.animate(withDuration: 1) {
                self.menuLeadref.constant = 0
                self.EventbackWeidthref.constant = 0
                 self.view.layoutIfNeeded()
            }
         }
      }
    
    @IBAction func applyBntref(_ sender: Any) {
        if self.defaultLocation.coordinate.latitude != nil && defaultLocation.coordinate.latitude > 0.00 && RadiusTfref.text?.count ?? 0 > 0 {
            self.googlemapviewref.clear()
            self.isnationWide = "0"
            
            self.DistanceInKM = self.RadiusTfref.text ?? ""
            if isPlaceSearching {
                if self.defaultLocation2.coordinate.latitude != nil && defaultLocation2.coordinate.latitude > 0.00 {
                    self.addRadiusCircle(location: self.defaultLocation2,distanceInMile: Int(RadiusTfref.text ?? "0") ?? 0)
                    self.MyPopularEventsMehtod(lat: "\(defaultLocation2.coordinate.latitude)", Long: "\(defaultLocation2.coordinate.longitude)")
                } else {
                 self.addRadiusCircle(location: self.defaultLocation,distanceInMile: Int(RadiusTfref.text ?? "0") ?? 0)
                self.MyPopularEventsMehtod(lat: "\(defaultLocation.coordinate.latitude)", Long: "\(defaultLocation2.coordinate.longitude)")
                }
            } else {
                self.addRadiusCircle(location: self.defaultLocation,distanceInMile: Int(RadiusTfref.text ?? "0") ?? 0)
                self.MyPopularEventsMehtod(lat: "\(defaultLocation.coordinate.latitude)", Long: "\(defaultLocation.coordinate.longitude)")
            }
        }else {
            if RadiusTfref.text?.count ?? 0 < 0{
                // self.showToast(message: "Please enter radious", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    
    
    @IBAction func backBtnref(_ sender: Any) {
        self.SearchEventDelegate?.SearchEventScreenData(Data: self.SearchScreenModelArr)
        self.popToBackVC()
    }
    
    
    
    @IBAction func nationWideSelectionbtn(_ sender: Any) {
        if self.isnationWide == "0" {
            self.isnationWide = "1"
            self.radusHeightref.constant = 0
            self.DistanceInKM = ""
            self.NationWideselectionbtnref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
            
            self.googlemapviewref.clear()
            self.MyPopularEventsMehtod(lat: "\(defaultLocation.coordinate.latitude)", Long: "\(defaultLocation.coordinate.longitude)")
        }else {
            self.isnationWide = "0"
            self.radusHeightref.constant = 40
            self.DistanceInKM = self.RadiusTfref.text ?? ""
            self.NationWideselectionbtnref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
    }
    
    @IBAction func AddManualLocationBtnref(_ sender: Any) {
        self.manualSearchViewEnableAndDisable()
    }
    func manualSearchViewEnableAndDisable() {
        isManualSearchEnable = isManualSearchEnable ? false : true
        ManualSearchView.isHidden = isManualSearchEnable ? true : false
        manualSearchViewHeightref.constant = isManualSearchEnable ? 0 : 318
        self.addManualAddressbtn.setImage(isManualSearchEnable ? UIImage(systemName: "arrow.down.app") : UIImage(systemName: "arrow.up.square"), for: .normal)
    }
    
    @IBAction func ContinueBntref(_ sender: Any) {
        // self.movetonextvc(id: "SearchdateRangeVC", storyBordid: "DashBoard")
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchdateRangeVC") as! SearchdateRangeVC
        if isPlaceSearching {
            if self.defaultLocation2.coordinate.latitude != nil && defaultLocation2.coordinate.latitude > 0.00 {
                nxtVC.currentAddressModel = self.currentAddressModel2
            } else {
                nxtVC.currentAddressModel = self.currentAddressModel
            }
        } else {
            nxtVC.currentAddressModel = self.currentAddressModel
        }
        nxtVC.searchType = "automatically"
        nxtVC.distance_miles = self.DistanceInKM
        nxtVC.nationwide = self.isnationWide
        nxtVC.SearchScreenModelArr = self.SearchScreenModelArr
        self.navigationController?.pushViewController(nxtVC, animated: true)
        
    }
    
    @IBAction func manualSearchBtnref(_ sender: Any) {
        // self.movetonextvc(id: "ManualSearchVC", storyBordid: "DashBoard")
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "ManualSearchVC") as! ManualSearchVC
        nxtVC.delegatestr = self
        nxtVC.distance_miles = self.DistanceInKM
        nxtVC.isnationWide = self.isnationWide
        nxtVC.SearchScreenModelArr = self.SearchScreenModelArr
        self.navigationController?.pushViewController(nxtVC, animated: true)
        
    }
    
    func currentTimeforApi() {
       let formatter2 = DateFormatter()
       formatter2.dateFormat = "MM-dd-yyyy"
       self.CurrentDatestr = formatter2.string(from: Date())
 
       let formatter3 = DateFormatter()
        formatter3.dateFormat = "hh:mm a"
        self.CurrentTimeStr = formatter3.string(from: Date())
     }
}
// Mark: -CLLocationManagerDelegate
extension LocationSearchManuallyVC: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            
            // googlemapviewref.isMyLocationEnabled = true
            //            googlemapviewref.settings.myLocationButton = true
            //            googlemapviewref.settings.zoomGestures = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            defaultLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if !(myadressselected){
                myadressselected = true
              
                let mapCamera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
                googlemapviewref.camera = mapCamera
                marker.position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
                marker.title = UserName
                // marker.snippet = "USA"
                
                marker.icon = UIImage(named: "smallLogo")
                marker.map = googlemapviewref
                
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
                                                                print(addressString)
                                                                self.CurrenLocation = addressString
                                                                //self.searchFeildLocTfref.text = addressString
                                                                self.currentAddressModel = AddressStruct(citystr: pm.thoroughfare ?? "", statestr: pm.locality ?? "", countrystr: pm.country ?? "", pincodestr: pm.postalCode ?? "", addressstr: pm.name ?? "", latstr: "\(self.defaultLocation.coordinate.latitude)", longstr: "\(self.defaultLocation.coordinate.longitude)")
                                                            }
                                                        }
                                                        
                                                        
                                                        
                                                    })
                
                //Api Calling...
                self.MyPopularEventsMehtod(lat: "\(defaultLocation.coordinate.latitude)", Long: "\(defaultLocation.coordinate.longitude)")
            }
        }
    }
    
    //    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //      // center the map on tapped marker
    //      mapView.animate(toLocation: marker.position)
    //      // check if a cluster icon was tapped
    //      if marker.userData is GMUCluster {
    //        // zoom in on tapped cluster
    //        mapView.animate(toZoom: mapView.camera.zoom + 1)
    //        NSLog("Did tap cluster")
    //        return true
    //      }
    //
    //      NSLog("Did tap a normal marker")
    //      return false
    //    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //  if position.zoom < 10 {
        
        
        
        
        //        let latitude = position.target .latitude
        //        let longitude = position.target.longitude
        //
        //        let mapCamera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        //        mapView.camera = mapCamera
        //        googlemapviewref.clear()
        //
        //
        //        marker.position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        //        marker.title = UserName
        //        // marker.snippet = "USA"
        //
        //        marker.icon = UIImage(named: "UserLogo")
        //        marker.map = googlemapviewref
        
        
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        //        googlemapviewref.clear() // clearing Pin before adding new
        //        //        let marker = GMSMarker(position: coordinate)
        //        //
        //        //        marker.title = UserName
        //        //        // marker.snippet = "USA"
        //        //
        //        //        marker.icon = UIImage(named: "smallLogo")
        //        //        marker.map = googlemapviewref
        //
        //        defaultLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        //        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler:
        //                                            {(placemarks, error) in
        //                                                if (error != nil){
        //                                                    print("reverse geodcode fail: \(error!.localizedDescription)")
        //                                                }
        //                                                if let pm = placemarks as? [CLPlacemark] {
        //                                                    if pm.count > 0 {
        //                                                        let pm = placemarks![0]
        //                                                        var addressString : String = ""
        //                                                        if pm.subLocality != nil {
        //                                                            addressString = addressString + pm.subLocality! + ", "
        //                                                        }
        //                                                        if pm.thoroughfare != nil {
        //                                                            addressString = addressString + pm.thoroughfare! + ", "
        //                                                        }
        //                                                        if pm.locality != nil {
        //                                                            addressString = addressString + pm.locality! + ", "
        //                                                        }
        //                                                        if pm.country != nil {
        //                                                            addressString = addressString + pm.country! + ", "
        //                                                        }
        //                                                        if pm.postalCode != nil {
        //                                                            addressString = addressString + pm.postalCode! + " "
        //                                                        }
        //                                                        print(addressString)
        //                                                        self.CurrenLocation = addressString
        //                                                        self.searchFeildLocTfref.text = addressString
        //                                                        self.currentAddressModel = AddressStruct(citystr: pm.thoroughfare ?? "", statestr: pm.locality ?? "", countrystr: pm.country ?? "", pincodestr: pm.postalCode ?? "", latstr: "\(coordinate.latitude)", longstr: "\(coordinate.longitude)")
        //                                                    }
        //                                                }
        //                                            })
        //
        //        //api calling...
        //        self.MyPopularEventsMehtod()
    }
    
    
    
    
}


extension LocationSearchManuallyVC :ManualAddessDelegate {
    func ManualAddessData(Data: AddressStruct) {
        self.currentAddressModel = Data
        print(self.currentAddressModel)
        
        
    }
}
extension LocationSearchManuallyVC {
    @IBAction func onLaunchClicked(sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}
extension LocationSearchManuallyVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        googlemapviewref.clear()
        self.RadiusTfref.text = ""
        
        // clearing Pin before adding new
        //    let marker = GMSMarker(position: place.coordinate)
        //
        //    marker.title = UserName
        //    // marker.snippet = "USA"
        //
        //    marker.icon = UIImage(named: "smallLogo")
        //    marker.map = googlemapviewref
        
        defaultLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        defaultLocation2 = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let mapCamera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
        googlemapviewref.camera = mapCamera
        
        marker.position = CLLocationCoordinate2D(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        marker.title = UserName
        //marker.snippet = "USA"
        
        marker.icon = UIImage(named: "smallLogo")
        marker.map = googlemapviewref
        isPlaceSearching = true
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), completionHandler:
            {(placemarks, error) in
            if (error != nil){
            print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if let pm = placemarks as? [CLPlacemark] {
               if pm.count > 0 {
                   if let pm = placemarks?[0] {
                     var addressString :String = ""
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
                   print(addressString)
                   self.CurrenLocation = addressString
                  // self.searchFeildLocTfref.text = addressString
                       self.currentAddressModel = AddressStruct(citystr: pm.thoroughfare ?? "", statestr: pm.locality ?? "", countrystr: pm.country ?? "", pincodestr: pm.postalCode ?? "", addressstr: pm.name ?? "", latstr: "\(place.coordinate.latitude)", longstr: "\(place.coordinate.longitude)")
                       self.currentAddressModel2 = AddressStruct(citystr: pm.thoroughfare ?? "", statestr: pm.locality ?? "", countrystr: pm.country ?? "", pincodestr: pm.postalCode ?? "", addressstr: pm.name ?? "", latstr: "\(place.coordinate.latitude)", longstr: "\(place.coordinate.longitude)")
                    }
                }
            }
        })
        
        //Api calling...
        self.defaultLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        place.coordinate
        self.MyPopularEventsMehtod(lat: "\(place.coordinate.latitude)", Long: "\(place.coordinate.longitude)")
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
}
extension LocationSearchManuallyVC {
    //MARK:- login func
    func MyPopularEventsMehtod(lat: String,Long: String){
//        indicator.showActivityIndicator()
//         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
//        self.DistanceInKM = self.RadiusTfref.text ?? ""
//        var categoryId = ""
//        var categoryName = ""
//        self.currentTimeforApi()
//        if self.SearchScreenModelArr.count > 0 {
//            var categoryIDArr : [String] = []
//            var categoryNameArr : [String] = []
//            for i in 0..<self.SearchScreenModelArr.count{
//                categoryIDArr.append(self.SearchScreenModelArr[i].Category_id)
//                categoryNameArr.append(self.SearchScreenModelArr[i].CategoryName)
//            }
//
//            categoryId = categoryIDArr.joined(separator: ",")
//            categoryName = categoryNameArr.joined(separator: ",")
//        }
//
////        lat:16.02053
////        long:79.923035
////        NationWide:0
////        DistanceinMiles:30
////        categorys:
//
//        let parameters = [
//            "id":UserId,
//            "lat":lat,
//            "long":Long,
//            "categorys":categoryId,
//            "searchtype":"",
//            "currentdate":self.CurrentDatestr,
//            "endtime":self.CurrentTimeStr,
//            "DistanceinMiles":self.DistanceInKM,
//            "NationWide":self.isnationWide,
//            "device_type":"IOS",
//            "device_id":UIDevice.current.identifierForVendor!.uuidString,
//            "device_token":newDeviceId
//
//        ] as! [String:String]
//        NetworkManager.Apicalling(url: API_URl.NearByEventsURL, paramaters: parameters, httpMethodType: .post, success: { (response:nearByEventsModel) in
//            print(response.data)
//            if response.status == "1" {
//                indicator.hideActivityIndicator()
//                if let response = response.data as? [nearByEventsModelData] {
//                    self.popularEventsArr = response
//                    for i in 0..<self.popularEventsArr.count {
//                        var defaultLocationstr = CLLocation()
//                        if let lat = self.popularEventsArr[i].latitude as? String,let long = self.popularEventsArr[i].longitude as? String{
//                            defaultLocationstr = CLLocation(latitude: Double(lat) ?? 0.00, longitude: Double(long) ?? 0.00)
//                        }
//
//
//                        let marker = GMSMarker(position: defaultLocationstr.coordinate)
//                        marker.appearAnimation = .pop
//                        marker.title = self.popularEventsArr[i].event_name ?? ""
//                        if let address = self.popularEventsArr[i].streetaddress,
//                           let State = self.popularEventsArr[i].state as? String,
//                           let Country = self.popularEventsArr[i].country as? String,
//                           let Pincode = self.popularEventsArr[i].zipcode as? String {
//
//                            marker.snippet = address + " , " + State + " , " + Country + " , " + Pincode
//                        }
//
//
//                        // if let url_str = self.popularEventsArr[i].photo as? String {
//                        marker.icon = UIImage(named: "smallLogo")
//
//
//                        let frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//                        let imageViewRef = UIImageView(frame: frame)
//                        if let imagestr = self.popularEventsArr[i].zipcode as? String {  if imagestr != "" {
//                            imageViewRef.sd_setImage(
//                                with: URL(string: imagestr),
//                                placeholderImage: UIImage(named: "smallLogo"))
//                        }
//                        imageViewRef.image = UIImage(named: "smallLogo")
//                        }else {
//                            imageViewRef.image = UIImage(named: "smallLogo")
//                        }
//                        marker.iconView = imageViewRef
//
//                        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
//                        //                             marker.icon.sd_setImage(with: URL(string: API_URl.ImageBaseURL +  url_str), placeholderImage: UIImage(named: "papularEvent"))
//                        //}
//                        marker.map = self.googlemapviewref
//                    }
//
//                    self.eventtblref.reloadData()
//                }
//            }else {
//                indicator.hideActivityIndicator()
//                //self.ShowAlert(message: response.message ?? "Something went wrong...")
//            }
//        }) { (errorMsg) in
//
//            indicator.hideActivityIndicator()
//            if let err = errorMsg as? String{
//                self.ShowAlert(message: err)
//            }
//        }
    }
    
}
extension LocationSearchManuallyVC {
    func addRadiusCircle(location: CLLocation,distanceInMile: Int){
        
        self.DistanceInKM = "\(distanceInMile)"
        let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        let circ = GMSCircle(position: circleCenter, radius: Double(distanceInMile) * 1609.34)
        
        let mapCamera = GMSCameraPosition.camera(withLatitude: circleCenter.latitude, longitude: circleCenter.longitude, zoom: 8)
        googlemapviewref.camera = mapCamera
        
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 246/255, green: 146/255, blue: 28/255, alpha: 1.0)
        circ.strokeWidth = 2.5;
        circ.map = self.googlemapviewref;
    }
    
 
}
extension LocationSearchManuallyVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popularEventsArr.count
    }
    
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: searchEventCell2 = tableView.dequeueReusableCell(withIdentifier: "searchEventCell2", for: indexPath) as! searchEventCell2
        cell.backViewref.layer.shadowColor = UIColor.gray.cgColor
        cell.backViewref.layer.masksToBounds = false
        cell.backViewref.layer.shadowOffset = CGSize(width: 0.0 , height: 3.0)
        cell.backViewref.layer.shadowOpacity = 1.0
        cell.backViewref.layer.shadowRadius = 1.0
        
        if let myeventName = self.popularEventsArr[indexPath.row].event_name {
            cell.MyEventNamelblref.text = myeventName
        }
        
        if let Hostname = self.popularEventsArr[indexPath.row].hostname {
            cell.MyEventHostNamelblref.text = Hostname
        }
        
        if let contactInfo = self.popularEventsArr[indexPath.row].contactinfo {
            cell.MyEventHostCoantactInfoLblef.text = contactInfo
        }
        
        if let membercount = self.popularEventsArr[indexPath.row].membercount {
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
        
        cell.infoBtnref.tag = indexPath.row
        cell.infoBtnref.addTarget(self, action: #selector(InfoBntref), for: .touchUpInside)
         return cell
    }
    @objc func InfoBntref(sender: UIButton){
        
        IsMenuOpend = true
        self.EventbackWeidthref.constant = 0
        self.memuIconBtnref.setImage(#imageLiteral(resourceName: "menuForward"), for: .normal)
        self.EventBackViewref.isHidden = true
        self.menuLeadref.constant = 0
        
        if let lat = self.popularEventsArr[sender.tag].latitude as? String, let long = self.popularEventsArr[sender.tag].longitude as? String {

            let mapCamera = GMSCameraPosition.camera(withLatitude: Double(lat) ?? 0.00, longitude: Double(long) ?? 0.09, zoom: 16)
        googlemapviewref.camera = mapCamera
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.movetonextvc(id: "SearchEventInfoVC", storyBordid: "DashBoard")
 
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchEventInfoVC") as! SearchEventInfoVC
        nxtVC.popularEventsArr = popularEventsArr[indexPath.row]
        nxtVC.VcFrom = "MapView"
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension LocationSearchManuallyVC {
    //MARK - Extension File
    
    @IBAction func statetfref(_ sender: Any) {
        if self.countrynameTfref.text ?? "" == "" {
            self.showToast2(message: "Please select country first...", font: .systemFont(ofSize: 12.0))
        }else {
            self.getStateListMethos(countryname: self.countrynameTfref.text ?? "")
            self.StateBntref.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.stateTFref {
            let newLength = textField.text?.count
            if(newLength ?? 0 <= 1){
                self.StateBntref.isHidden = false
                return true
            }else{
                self.StateBntref.isHidden = true
                return false
            }
        }else {
            return true
        }
    }
    
    @IBAction func ContinueBtnref(_ sender: Any) {
        //  self.movetonextvc(id: "LocationSearchEventVC", storyBordid: "DashBoard")
        var address_str = ""
        if let zipCode =  self.zipCodeTFref.text as? String  {
            address_str += zipCode + ","
        }
        if let Address = self.addressTFref.text as? String {
            address_str += Address + ","
        }
        if  let cityName =  self.cityTfref.text as? String  {
            address_str += cityName + ","
        }
        
        if let statename =  self.stateTFref.text as? String  {
            address_str += statename + ","
        }
        if let countryname =  self.countrynameTfref.text as? String  {
            address_str += countryname + ","
        }
        switch self.ManualSearchValidation() {
        case .Success:
            print("done")
            self.mydressFinder(Address: address_str)
            self.manualSearchViewEnableAndDisable()
        case .Error(let errorStr) :
            print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
    
//    @IBAction func backBtnref(_ sender: Any) {
//        self.popToBackVC()
//    }
    
}
