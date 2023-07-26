//
//  Register.swift
//  ShootWorthy
//
//  Created by Apple on 21/12/20.
//

import UIKit
import Alamofire
import MBProgressHUD


class HelpVC: UIViewController {
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var status:String?
    var message:String?
    
    // ***************************************************************** // nav
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .black
        }
    }
    
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "HELP"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var lblNumber:UILabel!
    @IBOutlet weak var lblDetails:UILabel!
    
    // ***************************************************************** // nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHelp()
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    @IBAction func btnCallConnectAction(_ sender: UIButton) {
        guard let url = URL(string: "telprompt://\(lblNumber.text ?? "")"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func btnEmailTimeAction(_ sender: UIButton) {
        if let url = URL(string: "mailto:\(lblEmail.text ?? "")") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func getHelp() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["action":"help"] as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
                        // do whatever you want here
                        switch response.result {
                        case .failure(let error):
                            // SVProgressHUD.dismiss()
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
                                self.responseDictionary = dict
                            }
                            self.status = self.responseDictionary["status"] as? String
                            if self.status == "Fails"
                            {
                                self.message = self.responseDictionary["msg"] as? String
                                let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                            else
                            {
                                let dict = self.responseDictionary["data"] as? [String: String]
                                self.lblEmail.text = dict?["eamil"]
                                self.lblNumber.text = dict?["phone"]
                            }
                        }
                    }
            }
        }
    }
}
