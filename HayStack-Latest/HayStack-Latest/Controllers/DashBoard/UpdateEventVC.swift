//
//  UpdateEventVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 27/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
class UpdateEventVC: UIViewController ,UITextFieldDelegate{
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
    
    
    var FirstScreenModel: CreateEventFirstModel?
    
    var CountryModel : [countryModelData] = []
    var StateModel : [StateModelData] = []
    var Countrypickerview = UIPickerView()
    var Statepickerview2 = UIPickerView()
    // @IBOutlet weak var
    var isImagetaken = false
    var imagetype = ""
    var MyEventsDetails : SearchEventModeldata?
    let geocoder = CLGeocoder()
    
    var selectedBtnName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerViewref.addBottomShadow()
        
        //Statepicker
        countryNameTfref.inputView = Countrypickerview
        countryNameTfref.textAlignment = .left
        countryNameTfref.placeholder = "Select Your Country"
        
        Countrypickerview.delegate = self
        Countrypickerview.dataSource = self
        
        stateTfref.delegate = self
        // self.stateTfref.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
        
        //Countrypicker
        stateTfref.inputView = Statepickerview2
        stateTfref.textAlignment = .left
        stateTfref.placeholder = "Select Your State"
        stateTfref.delegate = self
        Statepickerview2.delegate = self
        Statepickerview2.dataSource = self
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
    
    @IBAction func statetfref(_ sender: Any) {
        if self.countryNameTfref.text ?? "" == "" {
            self.showToast2(message: "Please select country first...", font: .systemFont(ofSize: 12.0))
        }else {
            self.getStateListMethos(countryname: self.countryNameTfref.text ?? "")
            self.StateBntref.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.stateTfref {
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
    
    
    
    
    @IBAction func addImageEventBntref(_ sender: Any) {
        self.isImagetaken = false
        ImagePickerManager().pickImage(self){ image,str  in
            //here is the image
            self.eventImgref.image = image
            self.imagetype = str
            self.isImagetaken = true
        }
    }
    
    
    @IBAction func UpdateTheEventbtnref(_ sender: Any) {
        
        
        switch self.UpdateEventFirstVaidation() {
        case .Success:
            if let cityname = self.FirstScreenModel?.CityName as? String,let satename =  self.FirstScreenModel?.StateName as? String,let countrycode =  self.FirstScreenModel?.CountryName as? String,let pincode = self.FirstScreenModel?.ZipCode as? String {
                let myAddress =  cityname + "," + satename + ","  + countrycode + ","  + pincode
                self.findMyAddressLatAndLong(Address: myAddress)
            }else {
                self.UpdateEventInfoMethod(lat: self.MyEventsDetails?.latitude ?? "",Long: self.MyEventsDetails?.longitude ?? "")
            }
        case .Error(let errorStr) :
            print(errorStr)
            self.showToast2(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
        
        
        
    }
    
    func findMyAddressLatAndLong(Address:String){
        geocoder.geocodeAddressString(Address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                if let coordinates:CLLocationCoordinate2D = placemark.location?.coordinate{
                    print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                    self.UpdateEventInfoMethod(lat: "\(coordinates.latitude)", Long: "\(coordinates.longitude)")
                }
                
            }
        })
    }
    
}

extension UpdateEventVC{
    func UpdateEventInfoMethod(lat:String,Long:String){
        indicator.showActivityIndicator()
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        self.FirstScreenModel = CreateEventFirstModel(EventName: EventNametfref.text ?? "", StreetAddress: streetAddressTfref.text ?? "", CityName: cityTfref.text ?? "", StateName: stateTfref.text ?? "", ZipCode: zipCodeTfref.text ?? "", CountryName: countryNameTfref.text ?? "", HostName: hostNameTfref.text ?? "", HostType: hostTypeTfref.text ?? "", ContactEmailOrPass: ContactInfoTfref.text ?? "", StartTime: StartTimeTfref.text ?? "", StartDate: StartDateTfref.text ?? "", EndDate: EndDateTfref.text ?? "", EndTime: EndTimeTfref.text ?? "", EventDiscription: EventDiscription.text ?? "", EventImage: self.eventImgref.image,imagetype: self.imagetype)
        
        var imageData = Data()
        if let img = FirstScreenModel?.EventImage {
            if let datastr:Data = img.pngData() {
                // Handle operations with data here...
                imageData = datastr
            }
        }
        
        var parameters = [
            "event_name": self.FirstScreenModel?.EventName,
            "streetaddress":self.FirstScreenModel?.StreetAddress,
            "city":self.FirstScreenModel?.CityName,
            "id":self.MyEventsDetails?.id,
            "userid":UserId,
            "state":self.FirstScreenModel?.StateName,
            "zipcode":self.FirstScreenModel?.ZipCode,
            "startdate":self.FirstScreenModel?.StartDate,
            "starttime":self.FirstScreenModel?.StartTime,
            "enddate":self.FirstScreenModel?.EndDate,
            "endtime":self.FirstScreenModel?.EndTime,
            "hostname":self.FirstScreenModel?.HostName,
            "contactinfo":self.FirstScreenModel?.ContactEmailOrPass,
            "event_description":self.FirstScreenModel?.EventDiscription,
            "country":self.FirstScreenModel?.CountryName,
            "latitude":lat,
            "longitude":Long,
            // "category":self.MyEventsDetails?.category,
            "eventtype":self.MyEventsDetails?.typ,
            "hosttype":self.MyEventsDetails?.hosttype,
        ] as! [String: String]
        
        NetworkManager2.Apicalling(url: API_URl.UpdateEvent_URL, paramaters: parameters, ImageData: FirstScreenModel?.EventImage,imagetype: self.imagetype ?? "jpg", httpMethodType: .post, success: { (response:UserModel) in
            if response.status == "1" {
                indicator.hideActivityIndicator()
//                self.ShowAlertWithPop(message: response.message ?? "Event updated successfully.")
                
                let alertController = UIAlertController(title: kApptitle, message: response.message ?? "Event updated successfully.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
                    let nxtVC = Storyboard.instantiateViewController(withIdentifier: "MyEventsVC") as! MyEventsVC
                    nxtVC.selectedBtnName = self.selectedBtnName
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
extension UpdateEventVC{
    
    func UpdateEventFirstVaidation()-> ApiCheckValidation {
        if EventNametfref.text ?? "" == "" || countryNameTfref.text ?? "" == "" || streetAddressTfref.text ?? "" == "" || cityTfref.text ?? "" == "" || stateTfref.text ?? "" == "" || zipCodeTfref.text ?? "" == "" || hostNameTfref.text ?? "" == "" || ContactInfoTfref.text ?? "" == "" || StartDateTfref.text ?? "" == "" || StartTimeTfref.text ?? "" == "" || EndDateTfref.text ?? "" == "" || EndTimeTfref.text ?? "" == "" || EventDiscription.text ?? "" == ""{
            return ApiCheckValidation.Error("All Feilds required...")
        }else if !(self.isImagetaken) {
            return ApiCheckValidation.Error("Please add event image as well...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
extension UpdateEventVC :UIPickerViewDataSource,UIPickerViewDelegate {
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
            self.countryNameTfref.text =  CountryModel[row].name
        }else {
            self.stateTfref.text = StateModel[row].name
        }
    }
}
extension UpdateEventVC {
    
    
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
