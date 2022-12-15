//
//  ManualSearchVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit
import CoreLocation
protocol ManualAddessDelegate{
    func ManualAddessData(Data: AddressStruct)
}

struct addresslatlong {
    var lat : String
    var long : String
}

class ManualSearchVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var cityTfref: UITextField!
    @IBOutlet weak var stateTFref: UITextField!
    @IBOutlet weak var zipCodeTFref: UITextField!
    @IBOutlet weak var countrynameTfref: UITextField!
    @IBOutlet weak var StateBntref: UIButton!
    var Countrypickerview = UIPickerView()
    var Statepickerview2 = UIPickerView()
    
    var isnationWide = ""
    var distance_miles = ""
    
    var CountryModel : [countryModelData] = []
    var StateModel : [StateModelData] = []
    
    var latstr = ""
    var longstr = ""
    var SearchScreenModelArr: [CategorySecondModel] = []
    let geocoder = CLGeocoder()
    
    var searchLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    
    
    var delegatestr : ManualAddessDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if  let cityName =  self.cityTfref.text as? String  {
            address_str += cityName
        }
        if let zipCode =  self.zipCodeTFref.text as? String  {
            address_str += zipCode
        }
        if let statename =  self.stateTFref.text as? String  {
            address_str += statename
        }
        if let countryname =  self.countrynameTfref.text as? String  {
            address_str += countryname
        }
         switch self.ManualSearchValidation() {
        case .Success:
            print("done")
            self.mydressFinder(Address: address_str)
         case .Error(let errorStr) :
            print(errorStr)
            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
    
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
}
extension ManualSearchVC{
    func ManualSearchValidation()-> ApiCheckValidation {
        // cityTfref.text ?? "" == "" ||
        //  || zipCodeTFref.text ?? "" == ""
        if stateTFref.text ?? "" == ""  || countrynameTfref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds required...")
        }else {
            return ApiCheckValidation.Success
        }
    }
    
    func mydressFinder(Address: String) {
        guard let cityName =  self.cityTfref.text as? String else {
            return
        }
        guard let statename =  self.stateTFref.text as? String else {
            return
        }
        guard let countryname =  self.countrynameTfref.text as? String else {
            return
        }
        guard let zipCode =  self.zipCodeTFref.text as? String else {
            return
        }
         var mylatlongstr :addresslatlong?
        geocoder.geocodeAddressString(Address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
                
                let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchdateRangeVC") as! SearchdateRangeVC
                nxtVC.currentAddressModel = AddressStruct(citystr: cityName, statestr: statename, countrystr: countryname,pincodestr: zipCode,latstr: " ", longstr: " ")
                nxtVC.searchType = "manual"
                nxtVC.distance_miles = self.distance_miles
                nxtVC.nationwide = self.isnationWide
                nxtVC.SearchScreenModelArr = self.SearchScreenModelArr
                self.navigationController?.pushViewController(nxtVC, animated: true)
            }
            if let placemark = placemarks?.first {
                if let coordinates:CLLocationCoordinate2D = placemark.location?.coordinate{
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                mylatlongstr = addresslatlong (lat: "\(coordinates.latitude)", long: "\(coordinates.longitude)")
                
//                self.delegatestr?.ManualAddessData(Data: )
//                       self.popToBackVC()
                    
                    
                    let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                    let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchdateRangeVC") as! SearchdateRangeVC
                    nxtVC.currentAddressModel = AddressStruct(citystr: cityName, statestr: statename, countrystr: countryname,pincodestr: zipCode,latstr: "\(coordinates.latitude)", longstr: "\(coordinates.longitude)")
                    nxtVC.searchType = "manual"
                    nxtVC.distance_miles = self.distance_miles
                    nxtVC.nationwide = self.isnationWide
                    nxtVC.SearchScreenModelArr = self.SearchScreenModelArr
                    self.navigationController?.pushViewController(nxtVC, animated: true)
                 }
               
             }
        })
        
    }
    
}
extension ManualSearchVC :UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == Countrypickerview {
            return 1
        }else {
        return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == Countrypickerview {
        return CountryModel.count
        }else {
            return StateModel.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == Countrypickerview {
        return CountryModel[row].name
        }else {
            return StateModel[row].name
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         if pickerView == Countrypickerview {
            self.StateBntref.isHidden = false
            self.stateTFref.text = ""
            self.cityTfref.text = ""
            self.zipCodeTFref.text = ""
            self.countrynameTfref.text =  CountryModel[row].name
        }else {
            self.cityTfref.text = ""
            self.zipCodeTFref.text = ""
            self.stateTFref.text = StateModel[row].name
        }
     }
}
extension ManualSearchVC {
   
    
    //MARK:-
    func getCountryListMethos(){
        indicator.showActivityIndicator()
          let parameters = [
            "":""
         ]
        NetworkManager.Apicalling(url: API_URl.Get_CountryCode_URL, paramaters: parameters, httpMethodType: .post, success: { (response:countryModel) in
             if response.status == "1" {
                indicator.hideActivityIndicator()
                if let responsedata = response.data as? [countryModelData]{
                    self.CountryModel = responsedata
                    self.Countrypickerview.reloadAllComponents()
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
    
    func getStateListMethos(countryname:String){
        indicator.showActivityIndicator()
          let parameters = [
            "countryname":countryname
         ]
        NetworkManager.Apicalling(url: API_URl.Get_StateCode_URL, paramaters: parameters, httpMethodType: .post, success: { (response:StateModel) in
             if response.status == "1" {
                indicator.hideActivityIndicator()
                if let responsedata = response.data as? [StateModelData]{
                    self.StateModel = responsedata
                    //self.Statepickerview2.reloadAllComponents()
                     DispatchQueue.main.async {[weak self] in
                        self?.Statepickerview2.reloadComponent(0) //HERE..!!!
                    }
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
