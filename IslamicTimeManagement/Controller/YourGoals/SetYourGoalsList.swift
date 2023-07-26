//
//  SetYourGoalsList.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
import Alamofire
import MBProgressHUD


class SetYourGoalsList: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    var responseDictionary:[String:Any] = [:]
//    var responseArray:[[String:Any]] = [[:]]
    
    var responseArray:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "YOUR GOALS"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnPlus:UIButton! {
        didSet {
            btnPlus.tintColor = .white
        }
    }
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tbleView.isHidden = true
        self.btnPlus.addTarget(self, action: #selector(plusClickMethod), for: .touchUpInside)
        lblNoRecord.isHidden = false
        sideBarMenuClick()
    }
    
    @objc func plusClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddGoalVC")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func sideBarMenuClick() {
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getGoalResponseData(pageNo : 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    // print(self.indexCounterOfButton as Any)
                    
                    self.getGoalResponseData(pageNo: page)
                
                    
                    
                    // prayer = 0 , quran = 1 , dua = 2 , others = 3
                }
            }
        }
    }
    
    func getGoalResponseData(pageNo: Int) {
        if isInternetAvailable() == false {
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["action":"goallist",
                              "pageNo":pageNo,
                              "userId": String(dict["userId"]as? Int ?? 0)]as [String : Any]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
                        // do whatever you want here
                        MBProgressHUD.hide(for:self.view, animated: true)
                        switch response.result {
                        case .failure(let error):
                            let alertController = UIAlertController(title: "Alert", message: "Some error Occured", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                            print(error)
                            if let data = response.data,
                               let responseString = String(data: data, encoding: .utf8) {
                                print(responseString)
                                print("response \(responseString)")
                            }
                        case .success(let responseObject):
                            DispatchQueue.main.async {
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                            print("response \(responseObject)")
                            MBProgressHUD.hide(for:self.view, animated: true)
                            if let dict = responseObject as? [String:Any] {
                                
//                                self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
//                                print(self.responseArray)
                                
                                var ar : NSArray!
                                ar = (dict["data"] as! Array<Any>) as NSArray
                                self.responseArray.addObjects(from: ar as! [Any])
                                
                                if(self.responseArray.count != 0) {
                                    
                                    self.tbleView.isHidden = false
                                    self.lblNoRecord.isHidden = true
                                    self.tbleView.reloadData()
                                    self.loadMore = 1
                                    
                                } else {
                                    
                                    self.tbleView.isHidden = true
                                    
                                }
                            }
                        }
                    }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SetYourGoalsListTableCell = tableView.dequeueReusableCell(withIdentifier: "SetYourGoalsListTableCell") as! SetYourGoalsListTableCell
        cell.backgroundColor = .clear
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.backgroundColor = UIColor.white
        
        
//        let dict : [String :Any] = self.responseArray[indexPath.row]
        
        let item = self.responseArray[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text = (item!["name"] as! String)
        cell.lblSubTitle.text = (item!["dateTime"] as! String)
        cell.lblDes.text = (item!["description"] as! String)
        
        cell.btnDel.tag = indexPath.row
        cell.btnDel.addTarget(self, action: #selector(btnDelClickMe(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnDelClickMe(_ sender: UIButton){
        let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
//            let dict : [String :Any] = self.responseArray[sender.tag]
            let item = self.responseArray[sender.tag] as? [String:Any]
            
            self.getDeleteRecords(goalId: "\(item!["goalId"]!)")
        }
        alertController.addAction(cancel)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
    func getDeleteRecords(goalId: String){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let values = ["action":"deletegoal",
                              "goalId":goalId,
                              "userId": String(dict["userId"]as? Int ?? 0)]as [String : Any]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
                        // do whatever you want here
                        MBProgressHUD.hide(for:self.view, animated: true)
                        switch response.result {
                        case .failure(let error):
                            let alertController = UIAlertController(title: "Alert", message: "Some error Occured", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                            print(error)
                            if let data = response.data,
                               let responseString = String(data: data, encoding: .utf8) {
                                print(responseString)
                                print("response \(responseString)")
                            }
                        case .success(let responseObject):
                            DispatchQueue.main.async {
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                            print("response \(responseObject)")
                            MBProgressHUD.hide(for:self.view, animated: true)
                            if let dict = responseObject as? [String:Any] {
                                print("delete response :: \(dict)")
                                self.getGoalResponseData(pageNo: 1)
                            }
                        }
                    }
            }
        }
    }
}


class SetYourGoalsListTableCell  : UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblDes:UILabel!
    @IBOutlet weak var btnDel: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
    }
}
