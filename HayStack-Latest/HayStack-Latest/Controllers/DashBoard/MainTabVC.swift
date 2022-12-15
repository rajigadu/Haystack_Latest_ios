//
//  mainTabvC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 12/05/21.
//

import UIKit
 
class mainTabvC: UITabBarController {
    var tabItem = UITabBarItem()

    override func viewDidLoad() {
        super.viewDidLoad()
       self.selectedIndex = 0
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        
        let calenderselectedImage =  UIImage.init(named: "selectedHome")?.withRenderingMode(.alwaysOriginal)
        let calenderDeselectedImage =  UIImage.init(named: "HomeIcon")?.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![0]
        tabItem.image = calenderDeselectedImage
        tabItem.selectedImage = calenderselectedImage
        
        
        let notificationselectedImage =  UIImage.init(named: "selectedGroups")?.withRenderingMode(.alwaysOriginal)
        let notificationDeselectedImage =  UIImage.init(named: "GroupsIcon")?.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![1]
        tabItem.image = notificationDeselectedImage
        tabItem.selectedImage = notificationselectedImage
        
        let homeselectedImage =  UIImage.init(named: "addNewEvent")?.withRenderingMode(.alwaysOriginal)
        let homeDeselectedImage =  UIImage.init(named: "addNewEvent")?.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![2]
       tabItem.image = homeDeselectedImage
       tabItem.selectedImage = homeselectedImage
        
        
        let historyselectedImage =  UIImage.init(named: "selectedProfile")?.withRenderingMode(.alwaysOriginal)
        let historyDeselectedImage =  UIImage.init(named: "Profile")?.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![3]
        tabItem.image = historyDeselectedImage
        tabItem.selectedImage = historyselectedImage
        
        
        let settingselectedImage =  UIImage.init(named: "selectedRefer")?.withRenderingMode(.alwaysOriginal)
        let settingDeselectedImage =  UIImage.init(named: "referAfriend")?.withRenderingMode(.alwaysOriginal)
        tabItem = self.tabBar.items![4]
        tabItem.image = settingDeselectedImage
        tabItem.selectedImage = settingselectedImage
//        tabBar.barTintColor = UIColor.tabBarTintColor().withAlphaComponent(0.5)
//        tabBar.isOpaque = true
       
//        if selectedIndex == 2 {
//            UITabBar.appearance().shadowImage = UIImage.init(named: "clear")
//            UITabBar.appearance().backgroundImage = UIImage()
//           // UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundColor = UIColor.clear
//
//                  // UITabBar.appearance().barTintColor = UIColor.tabBarTintColor().withAlphaComponent(0.5)
//        }
        
        if selectedIndex == 2 {
        
            let transperentBlackColor = UIColor.white
            //UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 12.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.layer.cornerRadius = 22
            tabBar.backgroundImage = image
            
            
        }

        UIGraphicsEndImageContext()
        
        
        }
        
        self.tabBarController?.tabBar.layer.cornerRadius = 20
        self.tabBarController?.tabBar.layer.masksToBounds = true

  
    }
    


}
 
@IBDesignable class TabBarWithCorners: UITabBar {
    @IBInspectable var color: UIColor?
    @IBInspectable var radii: CGFloat = 15.0

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()

        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = color?.cgColor ?? UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0   , height: -3);
        shapeLayer.shadowOpacity = 0.2
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath
        

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))

        return path.cgPath
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame            = self.frame
        tabFrame.size.height    = 65 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y       = self.frame.origin.y +   ( self.frame.height - 65 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 20
        self.frame            = tabFrame



        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })


    }

}
