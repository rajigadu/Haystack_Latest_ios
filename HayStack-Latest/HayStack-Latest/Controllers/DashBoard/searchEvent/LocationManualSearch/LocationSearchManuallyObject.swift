//
//  LocationSearchManuallyObject.swift
//  HayStack-Latest
//
//  Created by Rajesh Gandru on 02/03/23.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

extension LocationSearchManuallyVC{
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
//        guard let cityName =  self.cityTfref.text as? String else {
//            return
//        }
        guard let statename =  self.stateTFref.text else {
            return
        }
        guard let countryname =  self.countrynameTfref.text else {
            return
        }
//        guard let zipCode =  self.zipCodeTFref.text as? String else {
//            return
//        }
         var mylatlongstr :addresslatlong?
        self.geocoder.geocodeAddressString(Address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
                
                let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                let nxtVC = Storyboard.instantiateViewController(withIdentifier: "SearchdateRangeVC") as! SearchdateRangeVC
                nxtVC.currentAddressModel = AddressStruct(citystr: self.cityTfref.text ?? "", statestr: statename, countrystr: countryname,pincodestr: self.zipCodeTFref.text ?? "",addressstr: self.addressTFref.text ?? "", latstr: " ", longstr: " ")
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
                    //MARK: - Implimentaion Of UI
                    self.googlemapviewref.clear()
                    self.RadiusTfref.text = ""
                    self.defaultLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    self.defaultLocation2 = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    let mapCamera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 16)
                    self.googlemapviewref.camera = mapCamera
                    
                    self.marker.position = CLLocationCoordinate2D(latitude: self.defaultLocation.coordinate.latitude, longitude: self.defaultLocation.coordinate.longitude)
                    self.marker.title = self.UserName
                    //marker.snippet = "USA"
                    
                    self.marker.icon = UIImage(named: "smallLogo")
                    self.marker.map = self.googlemapviewref
                    let marker2 : GMSMarker = GMSMarker()
                    marker2.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    marker2.title = Address
                    //marker.snippet = "USA"
                    marker2.icon = UIImage(named: "smallLogo")
                    marker2.map = self.googlemapviewref
                    self.isPlaceSearching = true

                    
                    self.currentAddressModel = AddressStruct(citystr: self.cityTfref.text ?? "", statestr: self.stateTFref.text ?? "", countrystr: self.countrynameTfref.text ?? "", pincodestr: self.zipCodeTFref.text ?? "", addressstr: self.addressTFref.text ?? "", latstr: "\(coordinates.latitude)", longstr: "\(coordinates.longitude)")
                    
                    self.currentAddressModel2 = AddressStruct(citystr: self.cityTfref.text ?? "", statestr: self.stateTFref.text ?? "", countrystr: self.countrynameTfref.text ?? "", pincodestr: self.zipCodeTFref.text ?? "", addressstr: self.addressTFref.text ?? "", latstr: "\(coordinates.latitude)", longstr: "\(coordinates.longitude)")

                    //Api calling...
                    self.defaultLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    self.MyPopularEventsMehtod(lat: "\(coordinates.latitude)", Long: "\(coordinates.longitude)")

                 }
               
             }
        })
        
    }
    
}
extension LocationSearchManuallyVC :UIPickerViewDataSource,UIPickerViewDelegate {
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
            self.addressTFref.text = ""
            self.countrynameTfref.text =  CountryModel[row].name
        }else {
            self.cityTfref.text = ""
            self.zipCodeTFref.text = ""
            self.addressTFref.text = ""
            self.stateTFref.text = StateModel[row].name
        }
     }
}
extension LocationSearchManuallyVC {
   
    
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
