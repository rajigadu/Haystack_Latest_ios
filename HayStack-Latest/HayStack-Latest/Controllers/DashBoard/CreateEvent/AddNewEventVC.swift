//
//  AddNewEventVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
import IQKeyboardManagerSwift
struct CreateEventFirstModel {
    var EventName: String?
    var StreetAddress: String?
    var CityName: String?
    var StateName: String?
    var ZipCode: String?
    var CountryName: String?
    var HostName: String?
    var HostType: String?
    var ContactEmailOrPass: String?
    var StartTime: String?
    var StartDate: String?
    var EndDate: String?
    var EndTime: String?
    var EventDiscription: String?
    var EventImage: UIImage?
    var imagetype: String?
}

struct CategorySecondModel {
    var Category_id: String
    var CategoryName: String
    var photo: String
}


struct CreateEventMemberFourthModel {
    var membername: String
    var memberNumber: String
    var memberEmail: String
}



class AddNewEventVC: UIViewController,UITextFieldDelegate{

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
    var FinalPushingEvent : FinalPushingEvent?
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
        
        
      
        //Api Calling...
        self.getCountryListMethos()
        
         // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

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
    

    @IBAction func CreateTheEventbtnref(_ sender: Any) {
       
        
        switch self.CreateEventFirstVaidation() {
        case .Success:
//            print("done")
             self.PassDataToNextScreen()
         case .Error(let errorStr) :
            print(errorStr)
            self.showToast2(message: errorStr, font: .systemFont(ofSize: 12.0))
        }
    }
    
    
    
    func PassDataToNextScreen(){
        
       if !(self.isImagetaken) {
           self.FirstScreenModel = CreateEventFirstModel(EventName: EventNametfref.text ?? "", StreetAddress: streetAddressTfref.text ?? "", CityName: cityTfref.text ?? "", StateName: stateTfref.text ?? "", ZipCode: zipCodeTfref.text ?? "", CountryName: countryNameTfref.text ?? "", HostName: hostNameTfref.text ?? "", HostType: hostTypeTfref.text ?? "", ContactEmailOrPass: ContactInfoTfref.text ?? "", StartTime: StartTimeTfref.text ?? "", StartDate: StartDateTfref.text ?? "", EndDate: EndDateTfref.text ?? "", EndTime: EndTimeTfref.text ?? "", EventDiscription: EventDiscription.text ?? "", EventImage: #imageLiteral(resourceName: "papularEvent"),imagetype: self.imagetype)
       }else {
        self.FirstScreenModel = CreateEventFirstModel(EventName: EventNametfref.text ?? "", StreetAddress: streetAddressTfref.text ?? "", CityName: cityTfref.text ?? "", StateName: stateTfref.text ?? "", ZipCode: zipCodeTfref.text ?? "", CountryName: countryNameTfref.text ?? "", HostName: hostNameTfref.text ?? "", HostType: hostTypeTfref.text ?? "", ContactEmailOrPass: ContactInfoTfref.text ?? "", StartTime: StartTimeTfref.text ?? "", StartDate: StartDateTfref.text ?? "", EndDate: EndDateTfref.text ?? "", EndTime: EndTimeTfref.text ?? "", EventDiscription: EventDiscription.text ?? "", EventImage: self.eventImgref.image,imagetype: self.imagetype)
       }
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AllCategoryListVC") as! AllCategoryListVC
        nxtVC.FirstEventDelegate = self
        nxtVC.FirstScreenModel = self.FirstScreenModel
        self.navigationController?.pushViewController(nxtVC, animated: true)

        //self.movetonextvc(id: "AllCategoryListVC", storyBordid: "DashBoard")
    }

}
extension AddNewEventVC{
   
     func CreateEventFirstVaidation()-> ApiCheckValidation {
        if EventNametfref.text ?? "" == "" || countryNameTfref.text ?? "" == "" || streetAddressTfref.text ?? "" == "" || cityTfref.text ?? "" == "" || stateTfref.text ?? "" == "" || zipCodeTfref.text ?? "" == "" || hostNameTfref.text ?? "" == "" || ContactInfoTfref.text ?? "" == "" || StartDateTfref.text ?? "" == "" || StartTimeTfref.text ?? "" == "" || EndDateTfref.text ?? "" == "" || EndTimeTfref.text ?? "" == "" || EventDiscription.text ?? "" == ""{
            return ApiCheckValidation.Error("All Feilds required...")
        }
//        else if !(self.isImagetaken) {
//            return ApiCheckValidation.Error("Please add event image as well...")
//        }
        else {
            return ApiCheckValidation.Success
        }
    }
}
extension AddNewEventVC :FirstEventScreenDelegate {
    func FirstEventScreenData(Data: CreateEventFirstModel) {
        self.EventNametfref.text = Data.EventName
         self.countryNameTfref.text = Data.CountryName
         self.streetAddressTfref.text = Data.StreetAddress
         self.cityTfref.text = Data.CityName
         self.stateTfref.text = Data.StateName
         self.zipCodeTfref.text = Data.ZipCode
         self.hostNameTfref.text = Data.HostName
         self.hostTypeTfref.text = Data.HostType
         self.ContactInfoTfref.text = Data.ContactEmailOrPass
         self.StartDateTfref.text = Data.StartDate
         self.StartTimeTfref.text = Data.StartTime
         self.EndDateTfref.text = Data.EndDate
         self.EndTimeTfref.text = Data.EndTime
         self.EventDiscription.text = Data.EventDiscription
    }
    
    
}
extension AddNewEventVC :UIPickerViewDataSource,UIPickerViewDelegate {
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
             self.stateTfref.text = ""
             self.zipCodeTfref.text = ""
             self.cityTfref.text = ""
             self.streetAddressTfref.text = ""
             self.StateBntref.isHidden = false
        }else {
            self.stateTfref.text = StateModel[row].name
        }
     }
}
extension AddNewEventVC {
   
    
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
