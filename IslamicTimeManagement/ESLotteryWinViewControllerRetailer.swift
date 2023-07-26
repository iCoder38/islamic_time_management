//
//  ESLotteryWinViewControllerRetailer.swift
//  Eshaan
//
//  Created by IOSdev on 11/26/20.
//  Copyright © 2020 evs. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ESLotteryWinViewControllerRetailer: UIViewController, UIGestureRecognizerDelegate {
    
    var ar_22 : NSArray!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoLottery: UILabel!

    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var monthyLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    //MARK: - Life Cycle -
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrayers: UILabel!
    @IBOutlet weak var lblQuran: UILabel!
    @IBOutlet weak var lblDua: UILabel!
    @IBOutlet weak var lblTreating: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var viewHeadeListing: UIView!

    @IBOutlet weak var view_upper:UIView! {
        didSet {
            view_upper.backgroundColor = .brown
        }
    }
    
    var startDate = String()
    var endDate = String()

    var btnClickTag = Int()
    
    //Mark:- Extra Check First
    var responseDictionary:[String:Any] = [:]
     var responseArray:[[String:Any]] = [[:]]
    
//    var responseArray:NSMutableArray! = []
    
    @IBOutlet weak var btn_u_1: UIButton! {
        didSet {
            btn_u_1.backgroundColor = .clear
            btn_u_1.setTitle("Day", for: .normal)
        }
    }
    @IBOutlet weak var btn_u_2: UIButton! {
        didSet {
            btn_u_2.backgroundColor = .clear
            btn_u_2.setTitle("Prayers", for: .normal)
        }
    }
    @IBOutlet weak var btn_u_3: UIButton! {
        didSet {
            btn_u_3.backgroundColor = .clear
            btn_u_3.setTitle("Quran", for: .normal)
        }
    }
    @IBOutlet weak var btn_u_4: UIButton! {
        didSet {
            btn_u_4.backgroundColor = .clear
            btn_u_4.setTitle("Dua", for: .normal)
        }
    }
    @IBOutlet weak var btn_u_5: UIButton! {
        didSet {
            btn_u_5.backgroundColor = .clear
            btn_u_5.setTitle("Treating \nothers", for: .normal)
        }
    }
    @IBOutlet weak var btn_u_6: UIButton! {
        didSet {
            btn_u_6.backgroundColor = .clear
            btn_u_6.setTitle("Total", for: .normal)
        }
    }
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "TOTAL BRICKS"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tableView.isHidden = true
        self.sideBarMenuClick()
        
        // 1
        self.btn_u_1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_1.setTitleColor(.black, for: .normal)
        self.btn_u_1.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_1.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        // 2
        self.btn_u_2.frame = CGRect(x: self.btn_u_1.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_2.setTitleColor(.black, for: .normal)
        self.btn_u_2.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_2.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        // 2
        self.btn_u_3.frame = CGRect(x: self.btn_u_1.frame.size.width+self.btn_u_2.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_3.setTitleColor(.black, for: .normal)
        self.btn_u_3.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_3.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        // 2
        self.btn_u_4.frame = CGRect(x: self.btn_u_1.frame.size.width+self.btn_u_2.frame.size.width+self.btn_u_3.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_4.setTitleColor(.black, for: .normal)
        self.btn_u_4.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_4.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        // 2
        self.btn_u_5.frame = CGRect(x: self.btn_u_1.frame.size.width+self.btn_u_2.frame.size.width+self.btn_u_3.frame.size.width+self.btn_u_4.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_5.setTitleColor(.black, for: .normal)
        self.btn_u_5.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_5.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        // 2
        self.btn_u_6.frame = CGRect(x: self.btn_u_1.frame.size.width+self.btn_u_2.frame.size.width+self.btn_u_3.frame.size.width+self.btn_u_4.frame.size.width+self.btn_u_5.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 70)
        self.btn_u_6.setTitleColor(.black, for: .normal)
        self.btn_u_6.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.btn_u_6.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        self.view_upper.addSubview(self.btn_u_2)
        self.view_upper.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todayLabel.isHidden = false
        self.weeklyLabel.isHidden = true
        self.monthyLabel.isHidden = true
        self.yearlyLabel.isHidden = true
        self.historyListAPI(status: 1)
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }

    
    @IBAction func todayButtonTapped(_ sender: Any) {
        self.todayLabel.isHidden = false
        self.weeklyLabel.isHidden = true
        self.monthyLabel.isHidden = true
        self.yearlyLabel.isHidden = true
        historyListAPI(status: 1)
    }
    
    @IBAction func weeklyButtonTapped(_ sender: Any) {
        self.todayLabel.isHidden = true
        self.weeklyLabel.isHidden = false
        self.monthyLabel.isHidden = true
        self.yearlyLabel.isHidden = true
        historyListAPI(status: 2)
    }
    
    @IBAction func monthlyButtonTapped(_ sender: Any) {
        self.todayLabel.isHidden = true
        self.weeklyLabel.isHidden = true
        self.monthyLabel.isHidden = false
        self.yearlyLabel.isHidden = true
        historyListAPI(status: 3)
    }
    
    @IBAction func yearlyButtonTapped(_ sender: Any) {
        self.todayLabel.isHidden = true
        self.weeklyLabel.isHidden = true
        self.monthyLabel.isHidden = true
        self.yearlyLabel.isHidden = false
        historyListAPI(status: 4)
    }

    
    //MARK: - Call API Method
    func historyListAPI(status: Int){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!"
            
            let date = Date()
            var myDate = Date()
            endDate = date.getFormattedDate(format: "yyyy-MM-dd")
            if(status == 1){
                btnClickTag = 1
                // self.lblDate.text = "Day"
               startDate = endDate
            }
            if(status == 2){
                btnClickTag = 1
                // self.lblDate.text = "Day"
                myDate.changeDays(by: -7)
                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
            }
            if(status == 3){
                btnClickTag = 3
                // self.lblDate.text = "Date"
                myDate.changeDays(by: -30)
                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
            }
            if(status == 4){
                btnClickTag = 4
                // self.lblDate.text = "Date"
                myDate.changeDays(by: -364)
                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
            }

            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["action":"evalutionhistory","userId":String(dict["userId"]as? Int ?? 0),"pageNo":"","startDate":startDate,"endDate":endDate]as [String : Any]as [String : Any]
                
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
                            print("response \(responseObject)")
                            MBProgressHUD.hide(for:self.view, animated: true)
                            if let dict = responseObject as? [String:Any] {
                                
                                self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
                                print(self.responseArray)
                                
//                                self.ar_22.
                                /*self.responseArray.removeAllObjects()
                                
                                var ar : NSArray!
                                ar = (dict["data"] as! Array<Any>) as NSArray
                                self.responseArray.addObjects(from: ar as! [Any])*/
                                
                                
                                if(self.responseArray.count != 0){
                                    self.tableView.isHidden = false
                                    
                                    // self.viewHeadeListing.isHidden = false
                                    
                                    self.tableView.delegate = self
                                    self.tableView.dataSource = self
                                    
                                    self.tableView.reloadData()
                                    
                                } else {
                                    // self.viewHeadeListing.isHidden = true
                                    self.tableView.isHidden = true
                                }
                            }
                        }
                    }
                }
            }
        }
        
    
    
}

extension ESLotteryWinViewControllerRetailer : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:totalBricks = tableView.dequeueReusableCell(withIdentifier: "totalBricks") as! totalBricks
//        let cell = tableView.dequeueReusableCell(withIdentifier: "totalBricks", for: indexPath) as! totalBricks
        
//        if cell == nil {
//               cell = tableView.dequeueReusableCell(withIdentifier: "totalBricks") as? totalBricks
//           }
        
        /*let item = self.responseArray[indexPath.row] as? [String:Any]
        print(item as Any)
        
        self.ar_22 = (item!["JsonData"] as! Array<Any>) as NSArray
        // print(self.ar_22 as Any)
        
        /*print(self.ar_22[0] as Any)
        print(self.ar_22[1] as Any)
        print(self.ar_22[2] as Any)
        print(self.ar_22[3] as Any)*/
        
        cell.btn_1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_1.setTitleColor(.black, for: .normal)
        cell.btn_1.titleLabel?.font = .systemFont(ofSize: 10.0, weight: .regular)
        cell.btn_1.drawBorder(edges: [.bottom,.right], borderWidth: 1, color: UIColor.darkGray, margin: cell.frame.width)
        
        cell.btn_2.frame = CGRect(x: cell.btn_1.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_2.setTitleColor(.black, for: .normal)
        cell.btn_2.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_2.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_3.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_3.setTitleColor(.black, for: .normal)
        cell.btn_3.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_3.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_4.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_4.setTitleColor(.black, for: .normal)
        cell.btn_4.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_4.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_5.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width+cell.btn_4.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_5.setTitleColor(.black, for: .normal)
        cell.btn_5.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_5.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_6.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width+cell.btn_4.frame.size.width+cell.btn_5.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_6.setTitleColor(.black, for: .normal)
        cell.btn_6.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_6.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        if(btnClickTag == 3 || btnClickTag == 4) {

            var Msg_Date_ = (item!["created"] as! String)


            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            let datee = dateFormatterGet.date(from: Msg_Date_)
            Msg_Date_ =  dateFormatterPrint.string(from: datee ?? Date())

            var stringg = (item!["created"] as! String)//self.responseArray[indexPath.row]["created"]as? String ?? ""
            var fullNameArr = stringg.components(separatedBy:" ")

            var firstName: String = fullNameArr[0]

            cell.btn_1.setTitle(firstName, for: .normal)
                //.text = self.responseArray[indexPath.row]["created"]as? String ?? ""

        } else {

//            cell.btn_1.setTitle(self.responseArray[indexPath.row]["dayName"]as? String ?? "", for: .normal)
            cell.btn_1.setTitle((item!["dayName"] as! String), for: .normal)
             // cell.lblDate.text = self.responseArray[indexPath.row]["dayName"]as? String ?? ""

        }
        
        /*
         print(self.ar_22[0] as Any)
         print(self.ar_22[1] as Any)
         print(self.ar_22[2] as Any)
         print(self.ar_22[3] as Any)
         */
        if arrJSON != nil {

            cell.btn_2.setTitle("\(self.ar_22[0]["totalEvalulate"]!)", for: .normal)
            cell.btn_3.setTitle("\(self.ar_22[1]["totalEvalulate"]!)", for: .normal)
            cell.btn_4.setTitle("\(self.ar_22[2]["totalEvalulate"]!)", for: .normal)
            cell.btn_5.setTitle("\(self.ar_22[3]["totalEvalulate"]!)", for: .normal)
            
            if (self.responseArray[indexPath.row]["totalValue"]as? String) != nil  {
                // cell.lblTotal.text = self.responseArray[indexPath.row]["totalValue"]as? String ?? ""
//                cell.btn_6.setTitle("\(item!["totalValue"]!)", for: .normal)
            } else {
                // cell.lblTotal.text = String(self.responseArray[indexPath.row]["totalValue"]as? Int ?? 0)
//                cell.btn_6.setTitle("\(item!["totalValue"]!)", for: .normal)
            }
            
        }
        */
        
        
        
        
        
        let arrJSON = self.responseArray[indexPath.row]["JsonData"] as? [AnyObject]
        print(arrJSON)
        
        
        let dict = arrJSON?[0] as? [String:Any] ?? [:]
        let dict1 = arrJSON?[1] as? [String:Any] ?? [:]
        let dict2 = arrJSON?[2] as? [String:Any] ?? [:]
        let dict3 = arrJSON?[3] as? [String:Any] ?? [:]

        /*print(dict)
        print(dict1)
        print(dict2)
        print(dict3)*/

        cell.backgroundColor = .brown
        
        cell.btn_1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_1.setTitleColor(.black, for: .normal)
        cell.btn_1.titleLabel?.font = .systemFont(ofSize: 10.0, weight: .regular)
        cell.btn_1.drawBorder(edges: [.bottom,.right], borderWidth: 1, color: UIColor.darkGray, margin: cell.frame.width)

        cell.btn_2.frame = CGRect(x: cell.btn_1.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_2.setTitleColor(.black, for: .normal)
        cell.btn_2.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_2.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_3.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_3.setTitleColor(.black, for: .normal)
        cell.btn_3.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_3.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_4.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_4.setTitleColor(.black, for: .normal)
        cell.btn_4.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_4.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_5.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width+cell.btn_4.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_5.setTitleColor(.black, for: .normal)
        cell.btn_5.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_5.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        cell.btn_6.frame = CGRect(x: cell.btn_1.frame.size.width+cell.btn_2.frame.size.width+cell.btn_3.frame.size.width+cell.btn_4.frame.size.width+cell.btn_5.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        cell.btn_6.setTitleColor(.black, for: .normal)
        cell.btn_6.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        cell.btn_6.addRightBorder(borderColor: UIColor.black, borderWidth: 1.0)
        
        
        
        
        if(btnClickTag == 3 || btnClickTag == 4){
            var Msg_Date_ = self.responseArray[indexPath.row]["created"]as? String ?? ""
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            let datee = dateFormatterGet.date(from: Msg_Date_)
            Msg_Date_ =  dateFormatterPrint.string(from: datee ?? Date())
            
            var stringg = self.responseArray[indexPath.row]["created"]as? String ?? ""
            var fullNameArr = stringg.components(separatedBy:" ")
            
            var firstName: String = fullNameArr[0]
            
            cell.btn_1.setTitle(firstName, for: .normal)
                //.text = self.responseArray[indexPath.row]["created"]as? String ?? ""
            
        } else {
            
            cell.btn_1.setTitle(self.responseArray[indexPath.row]["dayName"]as? String ?? "", for: .normal)
             // cell.lblDate.text = self.responseArray[indexPath.row]["dayName"]as? String ?? ""
            
        }
        
        if arrJSON != nil {

            cell.btn_2.setTitle("\(dict["totalEvalulate"]!)", for: .normal)
            cell.btn_3.setTitle("\(dict1["totalEvalulate"]!)", for: .normal)
            cell.btn_4.setTitle("\(dict2["totalEvalulate"]!)", for: .normal)
            cell.btn_5.setTitle("\(dict3["totalEvalulate"]!)", for: .normal)
            
            if (self.responseArray[indexPath.row]["totalValue"]as? String) != nil  {
                // cell.lblTotal.text = self.responseArray[indexPath.row]["totalValue"]as? String ?? ""
                cell.btn_6.setTitle(self.responseArray[indexPath.row]["totalValue"]as? String ?? "", for: .normal)
            } else {
                // cell.lblTotal.text = String(self.responseArray[indexPath.row]["totalValue"]as? Int ?? 0)
                cell.btn_6.setTitle(String(self.responseArray[indexPath.row]["totalValue"]as? Int ?? 0), for: .normal)
            }
            
        }
        
        return cell
    }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
       }
    
}

class totalBricks : UITableViewCell {
    @IBOutlet weak var btn_1: UIButton! {
        didSet {
            btn_1.backgroundColor = .clear
//            btn_1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
    @IBOutlet weak var btn_2: UIButton! {
        didSet {
            btn_2.backgroundColor = .clear
//            btn_2.frame = CGRect(x: btn_1.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
    @IBOutlet weak var btn_3: UIButton! {
        didSet {
            btn_3.backgroundColor = .clear
//            btn_3.frame = CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
    @IBOutlet weak var btn_4: UIButton! {
        didSet {
            btn_4.backgroundColor = .clear
//            btn_4.frame = CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width+btn_3.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
    @IBOutlet weak var btn_5: UIButton! {
        didSet {
            btn_5.backgroundColor = .clear
//            btn_5.frame = CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width+btn_3.frame.size.width+btn_4.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
    @IBOutlet weak var btn_6: UIButton! {
        didSet {
            btn_6.backgroundColor = .clear
//            btn_6.frame = CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width+btn_3.frame.size.width+btn_4.frame.size.width+btn_5.frame.size.width, y: 0, width: self.view.frame.size.width/6, height: 80)
        }
    }
//    @IBOutlet weak var lblPrayers: UILabel!
//    @IBOutlet weak var lblQuran: UILabel!
//    @IBOutlet weak var lblDua: UILabel!
//    @IBOutlet weak var lblTreating: UILabel!
//    @IBOutlet weak var lblTotal: UILabel!
}


public extension String {
func isNumber() -> Bool {
    return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && self.rangeOfCharacter(from: CharacterSet.letters) == nil
}
    
}






////
////  ESLotteryWinViewControllerRetailer.swift
////  Eshaan
////
////  Created by IOSdev on 11/26/20.
////  Copyright © 2020 evs. All rights reserved.
////
//
//import UIKit
//import Alamofire
//import MBProgressHUD
//
//class ESLotteryWinViewControllerRetailer: UIViewController, UIGestureRecognizerDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var lblNoLottery: UILabel!
//
//    @IBOutlet weak var todayLabel: UILabel!
//    @IBOutlet weak var weeklyLabel: UILabel!
//    @IBOutlet weak var monthyLabel: UILabel!
//    @IBOutlet weak var yearlyLabel: UILabel!
//
//    //MARK: - Life Cycle
//    @IBOutlet weak var lblDate: UILabel!
//    @IBOutlet weak var lblPrayers: UILabel!
//    @IBOutlet weak var lblQuran: UILabel!
//    @IBOutlet weak var lblDua: UILabel!
//    @IBOutlet weak var lblTreating: UILabel!
//    @IBOutlet weak var lblTotal: UILabel!
//
//    @IBOutlet weak var viewHeadeListing: UIView!
//
//    var startDate = String()
//    var endDate = String()
//
//    var btnClickTag = Int()
//
//    var not_read = "0"
//
//    //Mark:- Extra Check First
//    var responseDictionary:[String:Any] = [:]
//    // var responseArray:[[String:Any]] = [[:]]
//
//    var responseArray:NSMutableArray! = []
//
//    @IBOutlet weak var navigationBar:UIView! {
//        didSet {
//            navigationBar.backgroundColor = NAVIGATION_COLOR
//        }
//    }
//    @IBOutlet weak var lblNavigationTitle:UILabel! {
//        didSet {
//            lblNavigationTitle.text = "TOTAL BRICKS"
//            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
//        }
//    }
//    @IBOutlet weak var btnMenu:UIButton! {
//        didSet {
//            btnMenu.tintColor = .white
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//        self.tableView.isHidden = true
//
//        self.sideBarMenuClick()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.todayLabel.isHidden = false
//        self.weeklyLabel.isHidden = true
//        self.monthyLabel.isHidden = true
//        self.yearlyLabel.isHidden = true
//        self.historyListAPI(status: 1)
//    }
//
//    @objc func sideBarMenuClick() {
//        self.view.endEditing(true)
//        if revealViewController() != nil {
//        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
//            revealViewController().rearViewRevealWidth = 300
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//          }
//    }
//
//
//    @IBAction func todayButtonTapped(_ sender: Any) {
//        self.todayLabel.isHidden = false
//        self.weeklyLabel.isHidden = true
//        self.monthyLabel.isHidden = true
//        self.yearlyLabel.isHidden = true
//        historyListAPI(status: 1)
//    }
//
//    @IBAction func weeklyButtonTapped(_ sender: Any) {
//        self.todayLabel.isHidden = true
//        self.weeklyLabel.isHidden = false
//        self.monthyLabel.isHidden = true
//        self.yearlyLabel.isHidden = true
//        historyListAPI(status: 2)
//    }
//
//    @IBAction func monthlyButtonTapped(_ sender: Any) {
//        self.todayLabel.isHidden = true
//        self.weeklyLabel.isHidden = true
//        self.monthyLabel.isHidden = false
//        self.yearlyLabel.isHidden = true
//        historyListAPI(status: 3)
//    }
//
//    @IBAction func yearlyButtonTapped(_ sender: Any) {
//        self.todayLabel.isHidden = true
//        self.weeklyLabel.isHidden = true
//        self.monthyLabel.isHidden = true
//        self.yearlyLabel.isHidden = false
//        historyListAPI(status: 4)
//    }
//
//
//    //MARK: - Call API Method
//    func historyListAPI(status: Int){
//        if isInternetAvailable() == false{
//            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else{
//            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
//            spinnerActivity.label.text = "Loading";
//            spinnerActivity.detailsLabel.text = "Please Wait!!"
//
//            let date = Date()
//            var myDate = Date()
//            endDate = date.getFormattedDate(format: "yyyy-MM-dd")
//            if(status == 1){
//                self.lblDate.text = "Day"
//               startDate = endDate
//            }
//            if(status == 2){
//                self.lblDate.text = "Day"
//                myDate.changeDays(by: -7)
//                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
//            }
//            if(status == 3){
//                btnClickTag = 3
//                self.lblDate.text = "Date"
//                myDate.changeDays(by: -30)
//                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
//            }
//            if(status == 4) {
//
//                btnClickTag = 4
//                self.lblDate.text = "Date"
//                myDate.changeDays(by: -364)
//                startDate = myDate.getFormattedDate(format: "yyyy-MM-dd")
//
//            }
//
//            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
//            if let apiString = URL(string:BaseUrl) {
//                var request = URLRequest(url:apiString)
//                request.httpMethod = "POST"
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                let values = [
//
//                    "action"    : "evalutionhistory",
//                    "userId"    : String(dict["userId"]as? Int ?? 0),
//                    // "pageNo"    : "",
//                    "startDate" : startDate,
//                    "endDate"   : endDate
//
//                ] as [String : Any] as [String : Any]
//
//                print("Values \(values)")
//
//                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
//                AF.request(request)
//                    .responseJSON { response in
//                        MBProgressHUD.hide(for:self.view, animated: true)
//                        switch response.result {
//                        case .failure(let error):
//                            let alertController = UIAlertController(title: "Alert", message: "Some error Occured", preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//                                print("you have pressed the Ok button");
//                            }
//                            alertController.addAction(okAction)
//                            self.present(alertController, animated: true, completion:nil)
//                            print(error)
//                            if let data = response.data,
//                               let responseString = String(data: data, encoding: .utf8) {
//                                print(responseString)
//                                print("response \(responseString)")
//                            }
//                        case .success(let responseObject):
//                            print("response \(responseObject)")
//                            MBProgressHUD.hide(for:self.view, animated: true)
//                            if let dict = responseObject as? [String:Any] {
//
//                                var ar : NSArray!
//                                ar = (dict["data"] as! Array<Any>) as NSArray
//                                self.responseArray.addObjects(from: ar as! [Any])
//
//                                // self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
//                                print(self.responseArray)
//                                if(self.responseArray.count != 0) {
//
//
//                                    self.tableView.isHidden = false
//                                    self.viewHeadeListing.isHidden = false
//
//                                    self.tableView.delegate = self
//                                    self.tableView.dataSource = self
//
//                                    self.not_read = "1"
//
//                                    self.tableView.reloadData()
//                                }else{
//                                    self.viewHeadeListing.isHidden = true
//                                    self.tableView.isHidden = true
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//
//
//
//}
//
//extension ESLotteryWinViewControllerRetailer : UITableViewDelegate , UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.responseArray.count
////        return 5
//   }
//
//   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//       let cell = tableView.dequeueReusableCell(withIdentifier: "totalBricks", for: indexPath) as! totalBricks
//
//       let item = self.responseArray[indexPath.row] as? [String:Any]
//
////       let arrJSON = self.responseArray[indexPath.row]["JsonData"] as? [AnyObject]
//
//       print(item as Any)
//
//       // print(item!["JsonData"] as Any)
//
//       /*print(arrJSON as Any)
//       print(self.responseArray as Any)
//       print(self.responseArray[0] as Any)*/
//
//
//       let dict = (item!["JsonData"] as? [String:Any])
//       print(dict as Any)
////
////       let dict1 = item!["JsonData"][1] as? [String:Any]
////       print(dict1 as Any)
////       let dict2 = item!["JsonData"][2] as? [String:Any]
////       print(dict2 as Any)
////       let dict3 = item!["JsonData"][3] as? [String:Any]
////       print(dict3 as Any)
//
//
//       let btn_1: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width/5, height: 50))
//       btn_1.backgroundColor = UIColor.clear
//       btn_1.setTitle("Click Me", for: .normal)
//       btn_1.setTitleColor(.black, for: .normal)
//
//       let btn_2: UIButton = UIButton(frame: CGRect(x: btn_1.frame.size.width, y: 0, width: cell.frame.size.width/5, height: 50))
//       btn_2.backgroundColor = UIColor.clear
//       btn_2.setTitle("Click Me", for: .normal)
//       btn_2.setTitleColor(.black, for: .normal)
//
//       let btn_3: UIButton = UIButton(frame: CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width, y: 0, width: cell.frame.size.width/5, height: 50))
//       btn_3.backgroundColor = UIColor.clear
//       btn_3.setTitle("Click Me", for: .normal)
//       btn_3.setTitleColor(.black, for: .normal)
//
//       let btn_4: UIButton = UIButton(frame: CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width+btn_3.frame.size.width, y: 0, width: cell.frame.size.width/5, height: 50))
//       btn_4.backgroundColor = UIColor.clear
//       btn_4.setTitle("Click Me", for: .normal)
//       btn_4.setTitleColor(.black, for: .normal)
//
//       let btn_5: UIButton = UIButton(frame: CGRect(x: btn_1.frame.size.width+btn_2.frame.size.width+btn_3.frame.size.width+btn_4.frame.size.width, y: 0, width: cell.frame.size.width/5, height: 50))
//       btn_5.backgroundColor = UIColor.clear
//       btn_5.setTitle("Click Me", for: .normal)
//       btn_5.setTitleColor(.black, for: .normal)
//
//       if(btnClickTag == 3 || btnClickTag == 4) {
//
//           var Msg_Date_ = (item!["created"]as! String)
//           let dateFormatterGet = DateFormatter()
//           dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//           let dateFormatterPrint = DateFormatter()
//           dateFormatterPrint.dateFormat = "yyyy-MM-dd"
//           let datee = dateFormatterGet.date(from: Msg_Date_)
//           Msg_Date_ =  dateFormatterPrint.string(from: datee ?? Date())
//           // cell.lblDate.text = self.responseArray[indexPath.row]["created"]as? String ?? ""
//           btn_1.setTitle(item!["created"] as! String, for: .normal)
//
//       } else {
//
//           // cell.lblDate.text = self.responseArray[indexPath.row]["dayName"]as? String ?? ""
//           btn_1.setTitle(item!["dayName"] as! String, for: .normal)
//       }
//
////       print(dict)
//
//
////           btn_2.setTitle(String(dict["totalEvalulate"]as? Int ?? 0), for: .normal)
////           btn_3.setTitle(String(dict1["totalEvalulate"]as? Int ?? 0), for: .normal)
////           btn_4.setTitle(String(dict2["totalEvalulate"]as? Int ?? 0), for: .normal)
////           btn_5.setTitle(String(dict3["totalEvalulate"]as? Int ?? 0), for: .normal)
//
//
//
//
//
//
//
//       // }
//
//
//       /*cell.lblPrayers.text = String(dict["totalEvalulate"]as? Int ?? 0)
//       cell.lblQuran.text = String(dict1["totalEvalulate"]as? Int ?? 0)
//       cell.lblDua.text = String(dict2["totalEvalulate"]as? Int ?? 0)
//       cell.lblTreating.text = String(dict3["totalEvalulate"]as? Int ?? 0)*/
//
//       /*if (self.responseArray[indexPath.row]["totalValue"] as? String) != nil  {
//
//           cell.lblTotal.text = self.responseArray[indexPath.row]["totalValue"]as? String ?? ""
//
//       } else {
//
//           cell.lblTotal.text = String(self.responseArray[indexPath.row]["totalValue"]as? Int ?? 0)
//
//       }*/
//
//
//       cell.addSubview(btn_1)
//       cell.addSubview(btn_2)
//       cell.addSubview(btn_3)
//       cell.addSubview(btn_4)
//       cell.addSubview(btn_5)
//
//       return cell
//   }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 100
//   }
//
//}
//
//class totalBricks : UITableViewCell {
////    @IBOutlet weak var lblDate: UILabel! {
////        didSet {
////            lblDate.textColor = .clear
////        }
////    }
////    @IBOutlet weak var lblPrayers: UILabel! {
////        didSet {
////            lblPrayers.textColor = .clear
////        }
////    }
////    @IBOutlet weak var lblQuran: UILabel! {
////        didSet {
////            lblQuran.textColor = .clear
////        }
////    }
////    @IBOutlet weak var lblDua: UILabel! {
////        didSet {
////            lblDua.textColor = .clear
////        }
////    }
////    @IBOutlet weak var lblTreating: UILabel! {
////        didSet {
////            lblTreating.textColor = .clear
////        }
////    }
////    @IBOutlet weak var lblTotal: UILabel! {
////        didSet {
////            lblTotal.textColor = .clear
////        }
////    }
//}
//
//
//public extension String {
//func isNumber() -> Bool {
//    return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && self.rangeOfCharacter(from: CharacterSet.letters) == nil
//}}

extension UIButton {

     func drawBorder(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor, margin: CGFloat) {
        for item in edges {
            let borderLayer: CALayer = CALayer()
            borderLayer.borderColor = color.cgColor
            borderLayer.borderWidth = borderWidth
            switch item {
            case .top:
                borderLayer.frame = CGRect(x: margin, y: 0, width: frame.width - (margin*2), height: borderWidth)
            case .left:
                borderLayer.frame =  CGRect(x: 0, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .bottom:
                borderLayer.frame = CGRect(x: margin, y: frame.height - borderWidth, width: frame.width - (margin*2), height: borderWidth)
            case .right:
                borderLayer.frame = CGRect(x: frame.width - borderWidth, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .all:
                drawBorder(edges: [.top, .left, .bottom, .right], borderWidth: borderWidth, color: color, margin: margin)
            default:
                break
            }
            self.layer.addSublayer(borderLayer)
        }
    }

}

extension UIButton {
    
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: self.frame.size.width - borderWidth,y: 0, width:borderWidth, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
