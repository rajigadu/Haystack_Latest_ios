//
//  CompanySmallBusinessRegistrationVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
import GoogleMaps
import MapKit
import GooglePlaces

class CompanySmallBusinessRegistrationVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!
    
    @IBOutlet weak var fnametfref: UITextField!
    @IBOutlet weak var lnameTfref: UITextField!
    @IBOutlet weak var emailTfref: UITextField!
    @IBOutlet weak var companeyTfref: UITextField!
    @IBOutlet weak var mobileTfref: UITextField!
    @IBOutlet weak var addressTfref: UITextField!
    @IBOutlet weak var PasswordTfref: UITextField!
    @IBOutlet weak var ConfirmPasswordTfref: UITextField!
    
    @IBOutlet weak var contentAcceptBtnref: UIButton!
    @IBOutlet weak var TermaAndConditionTfref: UIButton!
    
    var isContentSelected = false
    var istermsSelected = false
    
    var defaultLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var zoomLevel: Float = 15.0
    let marker : GMSMarker = GMSMarker()
    
    
    let geocoderstr = GMSGeocoder()
    
    let geocoder = CLGeocoder()
    var CurrenLocation = ""
    var myadressselected = false
    
    var latitude_User = ""
    var longitude_User = ""
    var country_User = ""
    var address_User = ""
    var city_User = ""
    var zipcode_User = ""
    var state_User = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.headerVewref.addBottomShadow()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addressBtnref(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    @IBAction func SignInBtnref(_ sender: Any) {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //       let vc = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "LoginVC", storyBordid: "Main")
        
        
    }
    @IBAction func ContentAceptBtnref(_ sender: Any){
        if istermsSelected {
            istermsSelected = false
            self.contentAcceptBtnref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        }else {
            istermsSelected = true
            self.contentAcceptBtnref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
    }
    @IBAction func termaConditionTfref(_ sender: Any){
        if isContentSelected {
            isContentSelected = false
            self.TermaAndConditionTfref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
        }else {
            isContentSelected = true
            self.TermaAndConditionTfref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
    }
    
    @IBAction func SignUpBntref(_ sender: Any) {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        //       let vc = storyBoard.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        // self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")
        switch self.RegistrationValidation() {
        case .Success:
            print("done")
            self.Registration()
        case .Error(let errorStr) :
            print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
        
    }
    
    @IBAction func forgotPassbtnref(_ sender: Any) {
        //        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //       let vc = storyBoard.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "ForgotPassVC", storyBordid: "Main")
        
    }
    
}
extension CompanySmallBusinessRegistrationVC: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == UserNameTfref {
//            if (string == " ") {
//                return false
//            }
//        }
//        return true
//    }
    
    
    func RegistrationValidation()-> ApiCheckValidation {
        if fnametfref.text ?? "" == "" || lnameTfref.text ?? "" == "" || emailTfref.text ?? "" == "" || mobileTfref.text ?? "" == "" || companeyTfref.text ?? "" == "" || addressTfref.text ?? "" == "" || PasswordTfref.text ?? "" == "" || ConfirmPasswordTfref.text ?? "" == "" {
            return ApiCheckValidation.Error("All feilds are required...")
        }else if let Emailstr = emailTfref.text,!isValidEmail(Emailstr) {
            return ApiCheckValidation.Error("Please enter Valid Email...")
        }else if let Passstr = PasswordTfref.text,Passstr.count < 6 {
            return ApiCheckValidation.Error("Please enter Valid Password...")
        }else if let Passstr = PasswordTfref.text,let Passstr2 = ConfirmPasswordTfref.text {
            if Passstr != Passstr2 {
                return ApiCheckValidation.Error("Please enter Valid Password...")
            }else {
                return ApiCheckValidation.Success
            }
        }else if self.contentAcceptBtnref.imageView?.image == UIImage(named: "unselectBtn") {
            return ApiCheckValidation.Error("Please check auth info button check!")
        }else if self.contentAcceptBtnref.imageView?.image == UIImage(named: "unselectBtn") {
            return ApiCheckValidation.Error("Please Terms and Conditions button check!")
        } else {
            return ApiCheckValidation.Success
        }
    }
}
extension CompanySmallBusinessRegistrationVC {
    
    
    //MARK:- login func
    func Registration(){
        indicator.showActivityIndicator()
        guard let FName = fnametfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let Lname = lnameTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let email = emailTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let companey = companeyTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let mobile = mobileTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let password = PasswordTfref.text else{
            indicator.hideActivityIndicator()
            return}
        guard let address = addressTfref.text else{
            indicator.hideActivityIndicator()
            return}
        
        var deviceID = UserDefaults.standard.string(forKey: "device_id") ?? ""
        
        
        let parameters = [
            "acc_type":"Company/Small Business",
            "fname": FName,
            "lname":Lname,
            "email":email,
            "password":password,
            "number":mobile,
            "latitude":self.latitude_User,
            "longitude":self.longitude_User,
            "country":self.country_User,
            "companyname":companey,
            "address":self.address_User,
            "city":self.city_User,
            "zipcode":self.zipcode_User,
            "state":self.state_User,
            "device_type":"IOS",
            "device_id":UIDevice.current.identifierForVendor!.uuidString,
            "device_token":deviceID
        ]
        NetworkManager.Apicalling(url: API_URl.SignUPURL, paramaters: parameters, httpMethodType: .post, success: { (response:RegisterUserModel) in
            print(response.uid)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                let alertController = UIAlertController(title: kApptitle, message: response.message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    self.movetonextvc(id: "LoginVC", storyBordid: "Main")
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
extension CompanySmallBusinessRegistrationVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.addressTfref.text = ""
        
        defaultLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let mapCamera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
        
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
                        self.latitude_User = "\(place.coordinate.latitude)"
                        self.longitude_User = "\(place.coordinate.longitude)"
                        self.country_User = pm.country ?? ""
                        self.address_User = addressString
                        self.city_User = pm.thoroughfare ?? ""
                        self.zipcode_User = pm.postalCode ?? ""
                        self.state_User = pm.locality ?? ""
                        self.addressTfref.text = addressString
                    }
                }
            }
        })
        
        //Api calling...
        //self.MyPopularEventsMehtod(lat: "\(place.coordinate.latitude)", Long: "\(place.coordinate.longitude)")
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
