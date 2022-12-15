//
//  CreateEventsecondVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 14/05/21.
//

import UIKit
protocol secondEventScreenDelegate{
     func secondEventScreenData(Data: [CategorySecondModel])
}
class CreateEventsecondVC: UIViewController {
    
    var secondScreenModelArr: [CategorySecondModel] = []
    var secondEventDelegate :secondEventScreenDelegate?
    
    @IBOutlet weak var AdvertisePublicBtnref: UIButton!
    @IBOutlet weak var AdvertisePrivateBtnref: UIButton!
    @IBOutlet weak var HostContactPublicBtnref: UIButton!
    @IBOutlet weak var HostContactPrivateBtnref: UIButton!
    
    
    var FirstScreenModel: CreateEventFirstModel?
    
    var AdvertiseStatus = ""
    var HostcontactStatus = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.AdvertisePublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.AdvertisePrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostContactPublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostContactPrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        
        
        self.secondEventDelegate?.secondEventScreenData(Data: self.secondScreenModelArr)
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func backBtnref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func AdvertisePublicBtn(_ sender: Any) {
        self.AdvertisePublicBtnref.setImage(#imageLiteral(resourceName: "selectedbtn"), for: .normal)
        self.AdvertisePrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
//        self.HostContactPublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
//        self.HostContactPrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.AdvertiseStatus = "Public"

    }
    @IBAction func AdvertisePrivateBtn(_ sender: Any) {
        self.AdvertisePublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.AdvertisePrivateBtnref.setImage(#imageLiteral(resourceName: "selectedbtn"), for: .normal)
       // self.HostContactPublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
       // self.HostContactPrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.AdvertiseStatus = "Private"
    }
    @IBAction func HostContactPublicBtn(_ sender: Any) {
       // self.AdvertisePublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
       // self.AdvertisePrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostContactPublicBtnref.setImage(#imageLiteral(resourceName: "selectedbtn"), for: .normal)
        self.HostContactPrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostcontactStatus = "Public"

    }
    @IBAction func HostContactPrivateBtn(_ sender: Any) {
       // self.AdvertisePublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
       // self.AdvertisePrivateBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostContactPublicBtnref.setImage(#imageLiteral(resourceName: "selectbtn"), for: .normal)
        self.HostContactPrivateBtnref.setImage(#imageLiteral(resourceName: "selectedbtn"), for: .normal)
        self.HostcontactStatus = "Private"
    }
    
    @IBAction func ContinueBtnref(_ sender: Any) {
        //self.movetonextvc(id: "AddMembersToEventVC", storyBordid: "DashBoard")
        
        let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        let nxtVC = Storyboard.instantiateViewController(withIdentifier: "AddMembersToEventVC") as! AddMembersToEventVC
        nxtVC.AdvertiseStatus = self.AdvertiseStatus
        nxtVC.HostcontactStatus = self.HostcontactStatus
        nxtVC.FirstScreenModel = self.FirstScreenModel
        nxtVC.secondScreenModelArr = self.secondScreenModelArr
        self.navigationController?.pushViewController(nxtVC, animated: true)

    }
    
}
