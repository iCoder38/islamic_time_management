//
//  ESChangePasswordViewController.swift
//  
//
//  Created by IOSdev on 11/20/20.
//

import UIKit
import Alamofire
import MBProgressHUD

class TermsConditionVC: UIViewController {
    @IBOutlet weak var submitButton: UIButton!
    
    var responseDictionary:[String:Any] = [:]
    var message:String?
    var dataDictionary:[String:Any] = [:]
    var status:String?

    
    @IBOutlet weak var txtView: UITextView!
    
    
    // ***************************************************************** // nav
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
            }
        }
            
        @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "TERMS OF USE"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.getTermandCondition()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getTermandCondition() {
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
                    let values = ["action":"termAndConditions"] as [String : Any]
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
                                    let str = self.responseDictionary["msg"] as? String ?? ""
                                    let data = Data(str.utf8)
                                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                                        self.txtView.attributedText = attributedString
                                    }
                                }
                            }
                    }
                }
            }
        }
    }



extension TermsConditionVC:UITextFieldDelegate {
    @objc  func menuButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
