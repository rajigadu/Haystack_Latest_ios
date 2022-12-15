//
//  AllCategoryListVC.swift
//  HayStack-Army
//
//  Created by rajesh gandru on 14/05/21.
//

import UIKit
import SDWebImage

protocol FirstEventScreenDelegate{

 func FirstEventScreenData(Data: CreateEventFirstModel)
    
}

class AllCategoryCell: UITableViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var checkBtnref: UIButton!
    @IBOutlet weak var CategoryNamelblref : UILabel!
}

class AllCategoryListVC: UIViewController {
    @IBOutlet weak var AllCategorytblref: UITableView!
    
    
    
    var allcategoryseen = ""
    var selectedCategory = [Int]()
    
    
    var FirstEventDelegate :FirstEventScreenDelegate?
    var AllCategorysArr :[CreateEventListModelData] = []
    
    var FirstScreenModel: CreateEventFirstModel?
    var secondScreenModelArr: [CategorySecondModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        if allcategoryseen != "SearchEvent"{
        self.FirstEventDelegate?.FirstEventScreenData(Data: FirstScreenModel!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCategorysListMethod()
    }
    

    @IBAction func backBntref(_ sender: Any) {
        self.popToBackVC()
    }
    
    @IBAction func ContinueToCreateAnEventbtnref(_ sender: Any) {
        if allcategoryseen == "SearchEvent"{
             let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "LocationSearchEventVC") as! LocationSearchEventVC
             nxtVC.SearchEventDelegate = self
            nxtVC.SearchScreenModelArr = self.secondScreenModelArr
            self.navigationController?.pushViewController(nxtVC, animated: true)
            
         }else {
        // self.movetonextvc(id: "CreateEventsecondVC", storyBordid: "DashBoard")
            
            let Storyboard : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
            let nxtVC = Storyboard.instantiateViewController(withIdentifier: "CreateEventsecondVC") as! CreateEventsecondVC
            nxtVC.FirstScreenModel = self.FirstScreenModel
            nxtVC.secondEventDelegate = self
            nxtVC.secondScreenModelArr = self.secondScreenModelArr
            self.navigationController?.pushViewController(nxtVC, animated: true)
        }
    }
}
extension AllCategoryListVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.AllCategorysArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AllCategoryCell = tableView.dequeueReusableCell(withIdentifier: "AllCategoryCell", for: indexPath) as! AllCategoryCell
        cell.CategoryNamelblref.text = self.AllCategorysArr[indexPath.row].category
        
        
        if let url_str =  self.AllCategorysArr[indexPath.row].photo as? String  {
         cell.categoryImage.sd_setImage(with: URL(string: url_str), placeholderImage: UIImage(named: "background3"))
         }
       //
        if selectedCategory.contains(indexPath.row) {
//        if self.secondScreenModelArr.contains(object where object.cate == name) {
//            if self.secondScreenModelArr.contains(where: { $0.Category_id == self.AllCategorysArr[indexPath.row].id }) {
             cell.checkBtnref.setImage(#imageLiteral(resourceName: "CheckBox"), for: .normal)
             
        }else {
            cell.checkBtnref.setImage(#imageLiteral(resourceName: "unselectBtn"), for: .normal)
        }
        
        cell.checkBtnref.tag = indexPath.row
        cell.checkBtnref.addTarget(self, action: #selector(checkbtnref), for: .touchUpInside)
        
        return cell
    }
    
    @objc func checkbtnref(sender: UIButton){
        let selectedContent = self.AllCategorysArr[sender.tag]
        if selectedCategory.contains(sender.tag){
           // let indexstr = selectedCategory.filter { $0 == 3 }
            if let indexstr = selectedCategory.firstIndex(where: {$0 == sender.tag}) {
                self.selectedCategory.remove(at: indexstr)
                if let indexstr2 = self.secondScreenModelArr.firstIndex(where: {$0.Category_id == self.secondScreenModelArr[indexstr].Category_id }) {
                     self.secondScreenModelArr.remove(at: indexstr2)
                }
            }
        }else {
            self.selectedCategory.append(sender.tag)
             self.secondScreenModelArr.append(CategorySecondModel(Category_id: selectedContent.id ?? "", CategoryName: selectedContent.category ?? "", photo: selectedContent.photo ?? ""))
        }
        
//
//        if secondScreenModelArr.count > sender.tag {
//            if secondScreenModelArr[sender.tag].Category_id == selectedContent.id {
//                self.secondScreenModelArr.remove(at: sender.tag)
//            }
//        }else {
//            self.secondScreenModelArr.append(CategorySecondModel(Category_id: selectedContent.id ?? "", CategoryName: selectedContent.category ?? "", photo: selectedContent.photo ?? ""))
//        }
        self.AllCategorytblref.reloadData()
    }
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
          guard let url = URL(string: urlString) else {
  return closure(nil)
          }
          let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
              guard error == nil else {
                  print("error: \(String(describing: error))")
                  return closure(nil)
              }
              guard response != nil else {
                  print("no response")
                  return closure(nil)
              }
              guard data != nil else {
                  print("no data")
                  return closure(nil)
              }
              DispatchQueue.main.async {
                  closure(UIImage(data: data!))
              }
          }; task.resume()
      }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContent = self.AllCategorysArr[indexPath.row]
        if secondScreenModelArr.count > indexPath.row {
            if secondScreenModelArr[indexPath.row].Category_id == selectedContent.id {
                self.secondScreenModelArr.remove(at: indexPath.row)
            }
        }else {
            self.secondScreenModelArr.append(CategorySecondModel(Category_id: selectedContent.id ?? "", CategoryName: selectedContent.category ?? "", photo: selectedContent.photo ?? ""))
        }
        
        self.AllCategorytblref.reloadData()
    }
    
}


extension AllCategoryListVC {
    //MARK:- login func
    func getCategorysListMethod(){
        indicator.showActivityIndicator()
        
         var UserId = UserDefaults.standard.string(forKey: "userID")  ?? ""
        
        let parameters = [
            "id": UserId//(host id)
         ] as [String : Any]
        NetworkManager.Apicalling(url: API_URl.getCategorysList_URL, paramaters: parameters, httpMethodType: .post, success: { (response:CreateEventListModel) in
            print(response.data)
            if response.status == "1" {
                indicator.hideActivityIndicator()
                if let responsedata = response.data as? [CreateEventListModelData]{
                    self.AllCategorysArr = responsedata
                    self.AllCategorytblref.reloadData()
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

extension AllCategoryListVC :secondEventScreenDelegate {
    func secondEventScreenData(Data: [CategorySecondModel]) {
        self.secondScreenModelArr = Data
        self.AllCategorytblref.reloadData()
    }
}
extension AllCategoryListVC :SearchEventScreenDelegate {
    func SearchEventScreenData(Data: [CategorySecondModel]) {
        self.secondScreenModelArr = Data
        self.AllCategorytblref.reloadData()
    }
}
