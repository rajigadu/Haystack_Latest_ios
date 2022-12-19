//
//  finalSuccessEventVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 14/05/21.
//

import UIKit

class finalSuccessEventVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAnottherEventbtnref(_ sender: Any) {
        self.movetonextvc(id: "AddNewEventVC", storyBordid: "DashBoard")

    }
    
    @IBAction func Closebtnref(_ sender: Any) {
        self.movetonextvc(id: "mainTabvC", storyBordid: "DashBoard")

    }
 

}
