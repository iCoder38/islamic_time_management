//
//  EvaluateYourself.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

struct evaluate_WB: Encodable {
    let action: String
    let categoryId: Int
    // let pageNo: Int
}

class EvaluateYourself: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
    var responseDictionary:[String:Any] = [:]
    // var responseArray:[[String:Any]] = [[:]]
    
    var catIdP = Int()
    var catIdD = Int()
    var catIdT = Int()
    var catIdQ = Int()
    
    var indexCounterOfButton = Int()
    var selectedIndexOfTbl = Int()
    
    var arrIndexCount:[[String:Any]] = [[:]]
    var arrJSONRequest:[[String:Any]] = [[:]]
    
    var responseArray:NSMutableArray! = []
    
    var arr_save_all_checked_data:NSMutableArray! = []
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "EVALUATE YOURSELF"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView!
    
    @IBOutlet weak var btnPrayer:UIButton!
    @IBOutlet weak var btnDua:UIButton!
    @IBOutlet weak var btnTreatingOthers:UIButton!
    @IBOutlet weak var btnQuraan:UIButton!
    var arrCat:[[String:Any]] = [[:]]
    
    @IBOutlet weak var btnNext: UIButton! {
        didSet {
            btnNext.setTitle("Submit", for: .normal)
        }
    }
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sideBarMenuClick()
        self.arrIndexCount.removeAll()
        selectedIndexOfTbl = -11
        buttonTagNaxt = 0
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        self.tbleView.isHidden = true
        
//        self.bar
        
        //
        
//        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EvaluateSuccessMonthlyWiseVCid")
//        self.navigationController?.pushViewController(push, animated: false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCategoryAPI()
    }
    
   
    
    func getCategoryAPI() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let values = ["action":"category"]as [String : Any]as [String : Any]
                
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
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
                                
                                self.arrCat = dict["data"] as? [[String : Any]] ?? [[:]]
                                print(self.arrCat)
                                
                                if(self.arrCat.count != 0) {
                                    
                                    for index in 0..<self.arrCat.count {
                                        let dict = self.arrCat[index]
                                        var paraInfo : [String :Any]  = [:]
                                        paraInfo = ["id": dict["id"]as?Int ?? 0,"cateroryName":"","totalEvalulate":0] // totalEvalulate
                                        self.arrJSONRequest.insert(paraInfo, at: index)
                                    }
                                    
                                    self.arrJSONRequest.removeLast()

                                    if(self.arrCat.count >= 0) {
                                        self.indexCounterOfButton = 0
                                        let dict : [String :Any] = self.arrCat[0]
                                        self.catIdT = dict["id"]as?Int ?? 0
                                        
                                        self.getEvaluationListAPI(categoryId: self.catIdT, pageNumber: 1)
                                        
                                        self.btnTreatingOthers.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
                                    }
                                    
                                    if(self.arrCat.count >= 1) {
                                        
                                        let dict : [String :Any] = self.arrCat[1]
                                        self.catIdD = dict["id"]as?Int ?? 0
                                        self.btnDua.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
                                        
                                    }
                                    
                                    if(self.arrCat.count >= 2) {
                                        
                                        let dict : [String :Any] = self.arrCat[2]
                                        self.catIdP = dict["id"]as?Int ?? 0
                                        self.btnPrayer.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
                                        
                                    }
                                    
                                    if(self.arrCat.count >= 3) {
                                        
                                        let dict : [String :Any] = self.arrCat[3]
                                        self.catIdQ = dict["id"]as?Int ?? 0
                                        self.btnQuraan.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
                                        
                                    }
                                    
                                } else {
                                    self.tbleView.isHidden = true
                                }
                            }
                        }
                    }
            }
        }
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    print(self.indexCounterOfButton as Any)
                    
                    if self.indexCounterOfButton == 0 {
                        self.getEvaluationListAPI(categoryId: 6,pageNumber: page)
                    } else if self.indexCounterOfButton == 1 {
                        self.getEvaluationListAPI(categoryId: 10,pageNumber: page)
                    } else if self.indexCounterOfButton == 2 {
                        self.getEvaluationListAPI(categoryId: 7,pageNumber: page)
                    } else {
                        self.getEvaluationListAPI(categoryId: 8,pageNumber: page)
                    }
                
                    
                    
                    // prayer = 0 , quran = 1 , dua = 2 , others = 3
                }
            }
        }
    }*/
    
    func getEvaluationListAPI(categoryId : Int,pageNumber:Int) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            /*let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            // let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let values = ["action":"evaluatelist","categoryId":categoryId]as [String : Any]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
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
                                
                                var ar : NSArray!
                                ar = (dict["data"] as! Array<Any>) as NSArray
                                print(ar as Any)
                                 self.responseArray.addObjects(from: ar as! [Any])
                                
                                // self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
                                
                                print(self.responseArray as Any)
                                
                                if(self.responseArray.count != 0) {
                                    
                                    self.tbleView.isHidden = false
                                    self.tbleView.reloadData()
                                    self.loadMore = 1
                                    
                                } else {
                                    
                                    self.tbleView.isHidden = true
                                    
                                }
                            }
                        }
                    }
            }*/
            
            // let values = ["action":"evaluatelist","categoryId":categoryId]as [String : Any]as [String : Any]
            
            
            if (pageNumber == 1) {
                let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true)
                spinnerActivity.label.text = "Loading";
                spinnerActivity.detailsLabel.text = "Please Wait!!";
            }
            
            
            _ = BaseUrl
            
            let parameters = evaluate_WB(action: "evaluatelist",
                                         categoryId: categoryId
                                         // pageNo: pageNumber
            )
            
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(BaseUrl,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                              print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                
                                
                                print(self.arr_save_all_checked_data as Any)
                                
                                if self.arr_save_all_checked_data.count == 0 {
                                    
                                    for indexx in 0..<ar.count {
                                        let item = ar[indexx] as? [String:Any]
                                        
                                        let custom_dict = [
                                            "categoryId":"\(item!["categoryId"]!)",
                                            "cateroryName":(item!["cateroryName"] as! String),
                                            "evaluateId":"\(item!["evaluateId"]!)",
                                            "marks":"\(item!["marks"]!)",
                                            "name":(item!["name"] as! String),
                                            "status":"no"
                                        ]
                                        
                                        self.responseArray.add(custom_dict)
                                        
                                        
                                        
                                    }
                                    
                                } else {
                                    print("yes, there is some data in it")
                                    
                                    print(self.arr_save_all_checked_data.count as Any)
                                    
                                    
                                    for indexx in 0..<ar.count {
                                        let item = ar[indexx] as? [String:Any]
                                        
                                        let custom_dict = [
                                            "categoryId":"\(item!["categoryId"]!)",
                                            "cateroryName":(item!["cateroryName"] as! String),
                                            "evaluateId":"\(item!["evaluateId"]!)",
                                            "marks":"\(item!["marks"]!)",
                                            "name":(item!["name"] as! String),
                                            "status":"no"
                                        ]
                                        
                                        self.responseArray.add(custom_dict)
                                        
                                    }
                                    
                                    print(self.responseArray as Any)
                                    
                                    for index_1 in 0..<self.responseArray.count {
                                        let item_1 = ar[index_1] as? [String:Any]
                                        
                                        for indexx in 0..<self.arr_save_all_checked_data.count {
                                            let item = self.arr_save_all_checked_data[indexx] as? [String:Any]
                                            
                                            if "\(item!["evaluateId"]!)" == "\(item_1!["evaluateId"]!)" {
                                                
                                                self.responseArray.removeObject(at: index_1)
                                                
                                                
                                                let custom_dict = [
                                                    "categoryId":"\(item_1!["categoryId"]!)",
                                                    "cateroryName":(item_1!["cateroryName"] as! String),
                                                    "evaluateId":"\(item_1!["evaluateId"]!)",
                                                    "marks":"\(item_1!["marks"]!)",
                                                    "name":(item_1!["name"] as! String),
                                                    "status":"yes"
                                                ]
                                                print("oyeah")
                                                
                                                self.responseArray.insert(custom_dict, at: index_1)
                                                
                                                // self.responseArray.add(custom_dict)
                                                
                                            }
                                            
                                            
                                        }
                                          
                                    }
                                    
                                    
                                    print(self.responseArray as Any)
                                    
                                    
                                    
                                        /*for index_1 in 0..<ar.count {
                                            let item_1 = ar[index_1] as? [String:Any]
                                            
                                            for indexx in 0..<self.arr_save_all_checked_data.count {
                                                let item = self.arr_save_all_checked_data[indexx] as? [String:Any]
                                                print(item as Any)
                                                print(item_1 as Any)
                                                
                                                
                                                if "\(item!["evaluateId"]!)" == "\(item_1!["evaluateId"]!)" {
                                                    
                                                    let custom_dict = [
                                                        "categoryId":"\(item!["categoryId"]!)",
                                                        "cateroryName":(item!["cateroryName"] as! String),
                                                        "evaluateId":"\(item!["evaluateId"]!)",
                                                        "marks":"\(item!["marks"]!)",
                                                        "name":(item!["name"] as! String),
                                                        "status":"yes"
                                                    ]
                                                    
                                                    self.responseArray.add(custom_dict)
                                                    
                                                } else {
                                                    
                                                    let custom_dict = [
                                                        "categoryId":"\(item!["categoryId"]!)",
                                                        "cateroryName":(item!["cateroryName"] as! String),
                                                        "evaluateId":"\(item!["evaluateId"]!)",
                                                        "marks":"\(item!["marks"]!)",
                                                        "name":(item!["name"] as! String),
                                                        "status":"no"
                                                    ]
                                                    
                                                    self.responseArray.add(custom_dict)
                                                    
                                                }
                                                 
                                            }
                                            
                                        }*/
                                        
                                   
                                    
                                    
                                     
                                }
                                
                                
                                // self.tbleView.delegate = self
                                // self.tbleView.dataSource = self
                                
                                self.tbleView.isHidden = false
                                self.tbleView.reloadData()
                                // self.loadMore = 1
                                
                                MBProgressHUD.hide(for:self.view, animated: true)
                                
                               
                            } else {
                                print("no")
                                MBProgressHUD.hide(for:self.view, animated: true)
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                // Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                                let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                                
                                
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HCDashboardId")
                                    self.navigationController?.pushViewController(push, animated: false)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        case let .failure(error):
                            print(error)
                            MBProgressHUD.hide(for:self.view, animated: true)
                            
                            Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                            
                        }
            }
            
        }
    }
    
    var arrSelectedStudent :[Int] = []
    var selectAll:Bool = false
    var buttonTagNaxt = Int()
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        /*if(indexCounterOfButton == 0) {
            indexCounterOfButton = 1
            view1.isHidden = true
            view2.isHidden = false
            view3.isHidden = true
            view4.isHidden = true
            //selectAll = false
            self.arrIndexCount.removeAll()
            self.arrSelectedStudent.removeAll()
            
            // self.btnNext.setTitle("NEXT", for: .normal)
            
            self.getEvaluationListAPI(categoryId: self.catIdD, pageNumber: 1)
        }
        else if(indexCounterOfButton == 1) {
            indexCounterOfButton = 2
            view1.isHidden = true
            view2.isHidden = true
            view3.isHidden = false
            view4.isHidden = true
            //selectAll = false
            self.arrIndexCount.removeAll()
            self.arrSelectedStudent.removeAll()
            
            // self.btnNext.setTitle("NEXT", for: .normal)
            
            self.getEvaluationListAPI(categoryId: self.catIdT, pageNumber: 1)
        }
        else if(indexCounterOfButton == 2) {
            indexCounterOfButton = 3
            view1.isHidden = true
            view2.isHidden = true
            view3.isHidden = true
            view4.isHidden = false
           // selectAll = false
            self.arrIndexCount.removeAll()
            self.arrSelectedStudent.removeAll()

            // self.btnNext.setTitle("SUBMIT", for: .normal)
            
            self.getEvaluationListAPI(categoryId: self.catIdQ, pageNumber: 1)
        }
        else if(indexCounterOfButton == 3) {
            self.areYouSureYourWantToSubmitPopUp()
        }*/
        //
        self.areYouSureYourWantToSubmitPopUp()
        
    }
    
    
    @IBAction func btnTreatingOthersTapped(_ sender: UIButton) {
        self.indexCounterOfButton = 0
        view1.isHidden = false
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = true
        self.arrIndexCount.removeAll()
        self.arrSelectedStudent.removeAll()

        let dict : [String :Any] = self.arrCat[0]
        self.catIdT = dict["id"]as?Int ?? 0
        
        self.responseArray.removeAllObjects()
        self.getEvaluationListAPI(categoryId: self.catIdT, pageNumber: 1)
        
        self.btnTreatingOthers.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
        // self.btnNext.setTitle("NEXT", for: .normal)
    }
    @IBAction func btnDua(_ sender: UIButton) {
        self.indexCounterOfButton = 1
        let dict : [String :Any] = self.arrCat[1]
        self.catIdD = dict["id"]as?Int ?? 0
        view1.isHidden = true
        view2.isHidden = false
        view3.isHidden = true
        view4.isHidden = true
        self.arrIndexCount.removeAll()
        self.arrSelectedStudent.removeAll()

        self.responseArray.removeAllObjects()
        self.getEvaluationListAPI(categoryId: self.catIdD, pageNumber: 1)
        
        self.btnDua.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
        // self.btnNext.setTitle("NEXT", for: .normal)
    }
    @IBAction func btnPrayer(_ sender: UIButton) {
        self.indexCounterOfButton = 2
        let dict : [String :Any] = self.arrCat[2]
        self.catIdP = dict["id"]as?Int ?? 0
        
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = false
        view4.isHidden = true
        self.arrIndexCount.removeAll()
        self.arrSelectedStudent.removeAll()

        self.responseArray.removeAllObjects()
        self.getEvaluationListAPI(categoryId: self.catIdP, pageNumber: 1)
        
        self.btnPrayer.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
       //  self.btnNext.setTitle("NEXT", for: .normal)
    }
    @IBAction func btnQuraan(_ sender: UIButton) {
        self.indexCounterOfButton = 3
        let dict : [String :Any] = self.arrCat[3]
        self.catIdQ = dict["id"]as?Int ?? 0
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
        view4.isHidden = false
        self.arrIndexCount.removeAll()
        self.arrSelectedStudent.removeAll()

        self.responseArray.removeAllObjects()
        self.getEvaluationListAPI(categoryId: self.catIdQ, pageNumber: 1)
        
        self.btnQuraan.setTitle((dict["name"]as?String ?? "").uppercased(), for: .normal)
        
        self.btnNext.setTitle("SUBMIT", for: .normal)
    }
    
    @objc func areYouSureYourWantToSubmitPopUp() {
        
        print(self.responseArray as Any)
        print(self.arr_save_all_checked_data as Any)
        
        /*var str_check_data = "0"
        for indexx in 0..<self.responseArray.count {
            let item = self.responseArray[indexx] as? [String:Any]
            
            if (item!["status"] as! String == "yes") {
                
                
                print("test")
                str_check_data = "1"
                // return
            }
            
        }*/
        
        
        if self.arr_save_all_checked_data.count == 0 {
         
            let alert = UIAlertController(title: "Alert", message: "No option has selected, please select an option.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
             self.submitEvaluationData()
            
        }
        
        /*let element1 = self.arrJSONRequest[0]["totalEvalulate"] as? Int ?? 0
        let element2 = self.arrJSONRequest[1]["totalEvalulate"] as? Int ?? 0
        let element3 = self.arrJSONRequest[2]["totalEvalulate"] as? Int ?? 0
        let element4 = self.arrJSONRequest[3]["totalEvalulate"] as? Int ?? 0
        
        if(element1 > 0 || element2 > 0 || element3 > 0 || element4 > 0) {
            self.submitEvaluationData()
        }else{
            let alert = UIAlertController(title: "Alert", message: "No option has selected, please select an option.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
    }
    
    func submitEvaluationData() {
        if isInternetAvailable() == false {
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                
                
                
                print(self.responseArray as Any)
                
                print(self.arr_save_all_checked_data as Any)
                
                var totalValueCount = Double()

                
                
                if(self.arr_save_all_checked_data.count != 0) {
                    for index in 0..<self.arr_save_all_checked_data.count {
                        let element = self.arr_save_all_checked_data[index] as? [String:Any]
                        
                        print("\(element!["marks"]!)")
                        totalValueCount += Double(element!["marks"] as! String)!
                        
//                        totalValueCount += Double("\(element!["totalEvalulate"]!)")
                        
                    }
                }
                
                print(totalValueCount)
                
                
                
                
                

                
                
                // print(arrJSONRequest as Any)
                // print(arr_save_all_checked_data as Any)
                
                var arr_dummy:NSMutableArray! = []
                
                // manage
                var str_check_prayer:String! = "0"
                var str_check_quran:String! = "0"
                var str_check_dua:String! = "0"
                var str_check_others:String! = "0"
                
                for indexx_3 in 0..<self.arr_save_all_checked_data.count {
                    let item_3 = self.arr_save_all_checked_data[indexx_3] as? [String:Any]
//
                    
                    print(item_3 as Any)
                    // ["name": Maghrib Salah, "categoryId": 6, "status": yes, "marks": 40, "cateroryName": Prayers, "evaluateId": 51]
                    
                    
                    if (item_3!["categoryId"] as! String) == "6" {
                        str_check_prayer = "1"
                    } else if (item_3!["categoryId"] as! String) == "10" {
                        str_check_quran = "1"
                    } else if (item_3!["categoryId"] as! String) == "7" {
                        str_check_dua = "1"
                    } else {
                        str_check_others = "1"
                    }
                    
                    
                    
                    let custom_dict = [
                        "id":(item_3!["categoryId"] as! String),
                        "cateroryName":(item_3!["cateroryName"] as! String),
                        "totalEvalulate":(item_3!["marks"] as! String),
                    ]
                    
                    arr_dummy.add(custom_dict)

                }
                
                
                print(str_check_prayer)
                print(str_check_quran)
                print(str_check_dua)
                print(str_check_others)
                
                print(arr_dummy)
                
                // add empty prayer
                if str_check_prayer == "0" {
                    let custom_dict = [
                        "id":"6",
                        "cateroryName":"Prayer",
                        "totalEvalulate":"0",
                    ]
                    
                    arr_dummy.add(custom_dict)
                }
                
                // add empty quran
                if str_check_quran == "0" {
                    let custom_dict = [
                        "id":"10",
                        "cateroryName":"Quran",
                        "totalEvalulate":"0",
                    ]
                    
                    arr_dummy.add(custom_dict)
                }
                
                // add empty dua
                if str_check_dua == "0" {
                    let custom_dict = [
                        "id":"7",
                        "cateroryName":"Dua",
                        "totalEvalulate":"0",
                    ]
                    
                    arr_dummy.add(custom_dict)
                }
                
                // add empty other
                if str_check_others == "0" {
                    let custom_dict = [
                        "id":"8",
                        "cateroryName":"Good deeds ",
                        "totalEvalulate":"0",
                    ]
                    
                    arr_dummy.add(custom_dict)
                }
                
                
                
                
                
                
                print(arr_dummy)
                
                // add multiple single data
                /*
                 if self.indexCounterOfButton == 0 {
                     self.getEvaluationListAPI(categoryId: 6,pageNumber: page)
                 } else if self.indexCounterOfButton == 1 {
                     self.getEvaluationListAPI(categoryId: 10,pageNumber: page)
                 } else if self.indexCounterOfButton == 2 {
                     self.getEvaluationListAPI(categoryId: 7,pageNumber: page)
                 } else {
                     self.getEvaluationListAPI(categoryId: 8,pageNumber: page)
                 }
                 */
                
                var str_add_prayers:Int! = 0
                var str_add_quran:Int! = 0
                var str_add_dua:Int! = 0
                var str_add_others:Int! = 0
                
                var arr_convert_array_for_json:NSMutableArray! = []
                
                for check_index in 0..<arr_dummy.count {
                    let item = arr_dummy[check_index] as? [String:Any]
                    print(item as Any)
                    
                    if (item!["id"] as! String == "6") {
                        let myString1 = (item!["totalEvalulate"] as! String)
                        let myInt1 = Int(myString1)
                        
                        str_add_prayers += Int(myInt1!)
                        print(str_add_prayers)
                    }
                    
                    // quran
                    if (item!["id"] as! String == "10") {
                        let myString1 = (item!["totalEvalulate"] as! String)
                        let myInt1 = Int(myString1)
                        
                        str_add_quran += Int(myInt1!)
                        print(str_add_quran)
                    }
                    
                    
                    // dua
                    if (item!["id"] as! String == "7") {
                        let myString1 = (item!["totalEvalulate"] as! String)
                        let myInt1 = Int(myString1)
                        
                        str_add_dua += Int(myInt1!)
                        print(str_add_dua)
                    }
                    
                    // other
                    if (item!["id"] as! String == "8") {
                        let myString1 = (item!["totalEvalulate"] as! String)
                        let myInt1 = Int(myString1)
                        
                        str_add_others += Int(myInt1!)
                        print(str_add_others)
                    }
                    
                }
                
                // send final prayers
                let custom_dict = [
                    "id":"6",
                    "cateroryName":"Prayers",
                    "totalEvalulate":"\(str_add_prayers!)",
                ]
                arr_convert_array_for_json.add(custom_dict)
                
                // send final quran
                let custom_dict_2 = [
                    "id":"10",
                    "cateroryName":"Quran",
                    "totalEvalulate":"\(str_add_quran!)",
                ]
                arr_convert_array_for_json.add(custom_dict_2)
                
                // send final dua
                let custom_dict_3 = [
                    "id":"7",
                    "cateroryName":"Dua",
                    "totalEvalulate":"\(str_add_dua!)",
                ]
                arr_convert_array_for_json.add(custom_dict_3)
                
                // send final other
                let custom_dict_4 = [
                    "id":"8",
                    "cateroryName":"Good deeds ",
                    "totalEvalulate":"\(str_add_others!)",
                ]
                arr_convert_array_for_json.add(custom_dict_4)
                
                
                
                
                
                
                
                
                
                
                
                
                
                print(arr_convert_array_for_json as Any)
                
                
                let paramsArray = arr_convert_array_for_json
                let paramsJSON = JSON(paramsArray)
                let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
                
                
                if(paramsString == "[\n\n]") {
                    let values = ["action":"submitevalution",
                                  "userId":String(dict["userId"]as? Int ?? 0),
                                  "totalValue":totalValueCount,
                                  "JsonData":""]as [String : Any]as [String : Any]
                    request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                    
                    print(values)
                    
                } else {
                    
                    let values = [
                        "action":"submitevalution",
                        "userId":String(dict["userId"]as? Int ?? 0),
                        "totalValue":totalValueCount,
                        "JsonData":paramsString
                        
                    ] as [String : Any]
                    request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                    
                    print(values)
                    
                }

                AF.request(request)
                    .responseJSON { response in
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
                                if(dict["status"]as? String ?? "" != "Fails"){
                                    let alertController = UIAlertController(title: "Alert", message: dict["msg"]as? String ?? "", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                                        
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let menuVC  = storyboard.instantiateViewController(withIdentifier: "EvaluateSuccessId") as? EvaluateSuccess
                                        
                                        UserDefaults.standard.set(dict["totalValue"], forKey: "totalValue")
                                        
                                        self.navigationController?.pushViewController(menuVC!, animated: true)

                                        
                                        // 91 //
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                }else{
                                    let alertController = UIAlertController(title: "Alert", message: dict["msg"]as? String ?? "", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                }
                            }
                        }
                    }
                 }
              }
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return self.responseArray.count}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EvaluateYourselfTableCell = tableView.dequeueReusableCell(withIdentifier: "evaluateYourselfTableCell") as! EvaluateYourselfTableCell
        cell.backgroundColor = .clear
        
        let dict = self.responseArray[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text = String( dict!["name"]as?String ?? "")
        cell.lblBrickQuantuty.text = "\(dict!["marks"]!)"
        
        cell.lblBrickQuantuty.textColor = .black
        
        if (dict!["status"] as! String) == "yes" {
            
            cell.btncheck.setImage(UIImage(named: "checkd5"), for: .normal)
        } else {
            
            cell.btncheck.setImage(UIImage(named: "check5"), for: .normal)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var intIndex:Int!
        // arr_save_all_checked_data
        
        
        // print(self.arr_save_all_checked_data.count as Any)
        // print(self.arr_save_all_checked_data as Any)
        
        //
        print(indexPath.row as Any)
        let item = self.responseArray[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        if (item!["status"] as! String) == "no" {
            
            let custom_dict = [
                "categoryId":"\(item!["categoryId"]!)",
                "cateroryName":(item!["cateroryName"] as! String),
                "evaluateId":"\(item!["evaluateId"]!)",
                "marks":"\(item!["marks"]!)",
                "name":(item!["name"] as! String),
                "status":"yes"
            ]
            
            self.responseArray.removeObject(at: indexPath.row)
            self.responseArray.insert(custom_dict, at: indexPath.row)
            
            self.arr_save_all_checked_data.add(custom_dict)
            
        } else {
            
            let custom_dict = [
                "categoryId":"\(item!["categoryId"]!)",
                "cateroryName":(item!["cateroryName"] as! String),
                "evaluateId":"\(item!["evaluateId"]!)",
                "marks":"\(item!["marks"]!)",
                "name":(item!["name"] as! String),
                "status":"no"
            ]

            self.responseArray.removeObject(at: indexPath.row)
            
            
            
            for indexx_2 in 0..<self.arr_save_all_checked_data.count {
                let item_2 = self.arr_save_all_checked_data[indexx_2] as? [String:Any]
            
                if "\(item_2!["evaluateId"]!)" == "\(custom_dict["evaluateId"]!)" {
                    print("YES DATA IS AVAILABLE")
            
                    print(indexx_2)
                    intIndex = indexx_2
                    
                    /*if (item_2!["status"] as! String) == "no" {
                        let custom_dict_2 = [
                            "categoryId":"\(item!["categoryId"]!)",
                            "cateroryName":(item!["cateroryName"] as! String),
                            "evaluateId":"\(item!["evaluateId"]!)",
                            "marks":"\(item!["marks"]!)",
                            "name":(item!["name"] as! String),
                            "status":"yes"
                        ]

                        self.arr_save_all_checked_data.removeObject(at: indexx_2)
                        self.arr_save_all_checked_data.insert(custom_dict, at: indexx_2)
                    } else {
                        let custom_dict_2 = [
                            "categoryId":"\(item!["categoryId"]!)",
                            "cateroryName":(item!["cateroryName"] as! String),
                            "evaluateId":"\(item!["evaluateId"]!)",
                            "marks":"\(item!["marks"]!)",
                            "name":(item!["name"] as! String),
                            "status":"no"
                        ]

                        self.arr_save_all_checked_data.removeObject(at: indexx_2)
                        self.arr_save_all_checked_data.insert(custom_dict, at: indexx_2)
                    }*/
                    
                    
                    
                }
            
            }
            
            
            
            
            self.responseArray.insert(custom_dict, at: indexPath.row)
            
        }
        
        
        print(intIndex as Any)
        
        if intIndex != nil {
            print("remove now")
            self.arr_save_all_checked_data.removeObject(at: intIndex)
        }
        
        print(self.arr_save_all_checked_data as Any)
//        print(self.responseArray as Any)
        
        self.tbleView.reloadData()
        
        
        
        
        
        
        
        
        
        
        
        // print(self.arr_save_all_checked_data.count as Any)
        // print(self.arr_save_all_checked_data as Any)
        
        
        
            
            /*for indexx_1 in 0..<self.arr_save_all_checked_data.count {
                let item_1 = self.arr_save_all_checked_data[indexx_1] as? [String:Any]
                // print(item_1 as Any)
                
                
                for indexx in 0..<self.responseArray.count {
                    let item = self.responseArray[indexx] as? [String:Any]
                    // print(item as Any)
                    
                    
                    if ("\(item_1!["evaluateId"]!)") == ("\(item!["evaluateId"]!)") {
                        print("matched")
                        
                        // print(item as Any)
                        
                        // print(indexx as Any)
                        
                        
                        if (item!["status"] as! String) == "no" {
                            
                            let custom_dict = [
                                "categoryId":"\(item!["categoryId"]!)",
                                "cateroryName":(item!["cateroryName"] as! String),
                                "evaluateId":"\(item!["evaluateId"]!)",
                                "marks":"\(item!["marks"]!)",
                                "name":(item!["name"] as! String),
                                "status":"yes"
                            ]
                            
                             self.responseArray.insert(custom_dict, at: indexx)
                            
                        } else {
                            
                            let custom_dict = [
                                "categoryId":"\(item!["categoryId"]!)",
                                "cateroryName":(item!["cateroryName"] as! String),
                                "evaluateId":"\(item!["evaluateId"]!)",
                                "marks":"\(item!["marks"]!)",
                                "name":(item!["name"] as! String),
                                "status":"no"
                            ]
                            
                            self.responseArray.insert(custom_dict, at: indexx)
                            
                        }
                         
                    }
                    
                }
                
            }*/
            
        
        
        
        
        /*
         let custom_dict = [
             "categoryId":"\(item!["categoryId"]!)",
             "cateroryName":(item!["cateroryName"] as! String),
             "evaluateId":"\(item!["evaluateId"]!)",
             "marks":"\(item!["marks"]!)",
             "name":(item!["name"] as! String),
             "status":"no"
         ]
         */
        // let dict : [String :Any] = self.responseArray[indexPath.row]
        
//        for index in 0..<self.arrJSONRequest.count {
//            let paraInfo = self.arrJSONRequest[index]
//            if(paraInfo["id"]as?Int ?? 0 == dict["categoryId"]as?Int ?? 0){
//                    let marks = dict["marks"]as? Int ?? 0
//                    let getMarks = paraInfo["totalEvalulate"]as? Int ?? 0
//                    let totalEvaluate = marks + getMarks
//                        let paraInfo:NSMutableDictionary = NSMutableDictionary()
//                        paraInfo.setValue( totalEvaluate, forKey: "totalEvalulate")
//                        paraInfo.setValue( dict["cateroryName"]as?String ?? "", forKey: "cateroryName")
//                        paraInfo.setValue( dict["categoryId"]as? Int ?? 0, forKey: "id")
//                        self.arrJSONRequest.remove(at: index)
//                        self.arrJSONRequest.insert(paraInfo as? [String:Any] ?? [:], at: index)
//            }
//        }
       // self.arrJSONRequest.removeLast()
        
//        if let index = arrSelectedStudent.index(of: indexPath.row) {
//            arrSelectedStudent.remove(at: index)
//            self.arrIndexCount.remove(at: index)
//        }else{
//            arrSelectedStudent.append(indexPath.row)
//            self.arrIndexCount.insert(dict, at: arrSelectedStudent.count - 1)
//        }
        
        
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
