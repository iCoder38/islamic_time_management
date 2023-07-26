//
//  SelectQuizLevel.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
import Alamofire
import MBProgressHUD

@available(iOS 13.0, *)
class SelectQuizLevel: UIViewController  {
    var responseDictionary:[String:Any] = [:]
    var responseArray:[[String:Any]] = [[:]]

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SELECT QUIZ LEVEL"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getQuizeResponseData()
    }

    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    func getQuizeResponseData() {
        
        if isInternetAvailable() == false {
            
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
                let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
                let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
                spinnerActivity.label.text = "Loading";
                spinnerActivity.detailsLabel.text = "Please Wait!!";
                
                if let apiString = URL(string:BaseUrl) {
                    var request = URLRequest(url:apiString)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let values = ["action":"lavellist",
                                  "userId": String(dict["userId"] as? Int ?? 0)] as [String : Any] as [String : Any]
                    
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
                                    self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
                                    print(self.responseArray)
                                    if(self.responseArray.count != 0){
                                        self.tbleView.isHidden = false
                                        self.tbleView.reloadData()
                                    }else{
                                        self.tbleView.isHidden = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

@available(iOS 13.0, *)
extension SelectQuizLevel: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.responseArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelectQuizTableCell = tableView.dequeueReusableCell(withIdentifier: "selectQuizTableCell") as! SelectQuizTableCell
        cell.backgroundColor = .clear
        cell.accessoryType = .none
        
        let dict : [String :Any] = self.responseArray[indexPath.row]
        cell.lblTitle.text = "LEVEL \(indexPath.row + 1)"
        
        let block = dict["block"]as?Int // id //
        
        if(block == 1) {
            cell.btnOpenClose.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.btnOpenClose.setTitleColor(.white, for: .normal)
            cell.btnOpenClose.setTitle("UNLOCKED", for: .normal)
        } else {
            cell.btnOpenClose.backgroundColor = UIColor.init(red: 250.0/255.0, green: 0.0/255.0, blue: 75.0/255.0, alpha: 1)
            cell.btnOpenClose.setTitleColor(.white, for: .normal)
            cell.btnOpenClose.setTitle("LOCKED", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict : [String :Any] = self.responseArray[indexPath.row]
        let block =  dict["block"]as? Int ?? 0
        if (block == 0){
            let alert = UIAlertController(title: "Alert", message: "Please try again after 24 hours/Complete previous level to unlock the next level", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuizQuestionAnswerVerticallyVC") as? QuizQuestionAnswerVerticallyVC
            vc?.strTitile = "LEVEL \(indexPath.row + 1)"
            vc?.strType = String(dict["id"]as? Int ?? 0)
            self.navigationController?.pushViewController(vc!, animated: false)
        }        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
