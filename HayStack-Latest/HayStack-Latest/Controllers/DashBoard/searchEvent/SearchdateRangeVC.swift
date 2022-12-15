//
//  SearchdateRangeVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 15/05/21.
//

import UIKit

struct searchEventDateModel {
    var startDate : String
    var startTime : String
    var EndDate : String
    var EndTime : String
}

class SearchdateRangeVC: UIViewController {
    @IBOutlet weak var StartDateTfref: UITextField!
    @IBOutlet weak var StartTimeTfref: UITextField!
    @IBOutlet weak var EndDatetfref: UITextField!
    @IBOutlet weak var EndTimeTfref: UITextField!
    
    var currentAddressModel : AddressStruct?
    var searchType = ""
    var distance_miles = ""
    var nationwide = ""
    var SearchScreenModelArr: [CategorySecondModel] = []
    var searchEventDate :searchEventDateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTime()
        // Do any additional setup after loading the view.
    }
    
     func currentTime() {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM-dd-yyyy"
        self.StartDateTfref.text = formatter2.string(from: Date())
        self.EndDatetfref.text = formatter2.string(from: Date())

        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        self.EndTimeTfref.text = formatter.string(from: Date())
        self.StartTimeTfref.text = formatter.string(from: Date())

       // self.addressLblref.text = locality + administrativeArea + country
       // myadressselected = false

     }
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    
    @IBAction func continueBntref(_ sender: Any) {
//        switch self.SearchDateValidation() {
//        case .Success:
//            print("done")
            self.movetoNextVc()
//        case .Error(let errorStr) :
//            print(errorStr)
//            self.showToast(message: errorStr, font: .systemFont(ofSize: 12.0))
//        }
    }
    
    func movetoNextVc(){
        self.searchEventDate = searchEventDateModel(startDate: self.StartDateTfref.text ?? "", startTime: self.StartTimeTfref.text ?? "", EndDate: self.EndDatetfref.text ?? "", EndTime: self.EndTimeTfref.text ?? "")
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "searchEventListVC") as! searchEventListVC
        nxtVC.currentAddressModel = self.currentAddressModel
        nxtVC.searchType = self.searchType
        nxtVC.distance_miles = self.distance_miles
        nxtVC.nationwide = self.nationwide
        nxtVC.SearchScreenModelArr = self.SearchScreenModelArr
        nxtVC.searchEventDate = self.searchEventDate
        self.navigationController?.pushViewController(nxtVC, animated: true)
    }
    
}
extension SearchdateRangeVC{
    func SearchDateValidation()-> ApiCheckValidation {
        if StartDateTfref.text ?? "" == "" || StartTimeTfref.text ?? "" == "" || EndDatetfref.text ?? "" == "" || EndTimeTfref.text ?? "" == ""{
            return ApiCheckValidation.Error("All feilds are required...")
        }else {
            return ApiCheckValidation.Success
        }
    }
}
