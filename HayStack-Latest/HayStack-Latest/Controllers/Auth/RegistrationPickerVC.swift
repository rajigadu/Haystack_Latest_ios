//
//  RgistrationPickerVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit

class RegistrationPickerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func soldierPickbtnref(_ sender: Any) {
 
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "SoldierRegistrationVC") as! SoldierRegistrationVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "UserRegistrationVC", storyBordid: "Main")


    }
    
  
    
    @IBAction func SpousePickbtnref(_ sender: Any) {
 
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//       let vc = storyBoard.instantiateViewController(withIdentifier: "SpouseRegistationVC") as! SpouseRegistationVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        self.movetonextvc(id: "CompanySmallBusinessRegistrationVC", storyBordid: "Main")


    }
}

