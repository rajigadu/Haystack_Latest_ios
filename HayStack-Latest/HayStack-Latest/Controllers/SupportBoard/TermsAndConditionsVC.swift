//
//  TermsAndConditionsVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 13/05/21.
//

import UIKit
import WebKit
class TermsAndConditionsVC: UIViewController {
    @IBOutlet weak var headerVewref: UIView!

    @IBOutlet weak var termsWebViewref: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.headerVewref.addBottomShadow()
        self.tabBarController?.tabBar.isHidden = true
        
        let myURLString = "https://haystackevents.com/haystack-army/ios/termsconditions.php"
        let url = URL(string: myURLString)
        let request = URLRequest(url: url!)
        
        termsWebViewref.navigationDelegate = self
        termsWebViewref.load(request)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtnref(_sender : Any){
        self.popToBackVC()
    }

}
extension TermsAndConditionsVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
