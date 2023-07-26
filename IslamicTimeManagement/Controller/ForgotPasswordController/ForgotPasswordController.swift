//
//  ESForgotPasswordController.swift
//  Eshaan
//
//  Created by IOSdev on 10/28/20.
//  Copyright © 2020 evs. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ForgotPasswordController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var submitButton: UIButton!
    var responseDictionary:[String:Any] = [:]
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var viewLoginBG:UIView!

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
        }
    }
    
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "FORGOT PASSWORD"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        roundedShadowBorderOnView(view: viewLoginBG)
    }
    
    func roundedShadowBorderOnView(view: UIView)
    {
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 10
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func menuButtonTapped() {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if( emailTextField.text!.isEqual("") ) {
                let alertController = UIAlertController(title: "Alert", message: "Please fill the vacant field", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                    print("you have pressed the Ok button");
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }else{
                
                let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
                spinnerActivity.label.text = "Loading";
                spinnerActivity.detailsLabel.text = "Please Wait!!";
                
                if let apiString = URL(string:BaseUrl) {
                    var request = URLRequest(url:apiString)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let values = ["action":"forgotPassword","email":emailTextField.text!]as [String : Any]as [String : Any]
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
                                    self.responseDictionary = dict
                                    
                                    let alertController = UIAlertController(title: "Alert", message: self.responseDictionary["msg"]as? String ?? "", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        self.navigationController?.popViewController(animated: true)
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
}

