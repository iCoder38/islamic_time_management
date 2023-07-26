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

class ChangePasswordController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var submitButton: UIButton!
    var responseDictionary:[String:Any] = [:]
    @IBOutlet weak var txtOldPass: UITextField!
    @IBOutlet weak var txtNewPass:UITextField!
    @IBOutlet weak var txtConfirmPass:UITextField!
    @IBOutlet weak var viewLoginBG:UIView!

    
    @IBOutlet weak var btnPasswordHiddenBox3: UIButton!
    @IBOutlet weak var imgPasswordHidden3: UIImageView!
    
    @IBOutlet weak var btnPasswordHiddenBox2: UIButton!
    @IBOutlet weak var imgPasswordHidden2: UIImageView!
    
    @IBOutlet weak var btnPasswordHiddenBox1: UIButton!
    @IBOutlet weak var imgPasswordHidden1: UIImageView!
    
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
        }
    }
    
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHANGE PASSWORD"
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
    
    @IBAction func btnPassword_Hide3(sender: UIButton) {
        if (btnPasswordHiddenBox3.isSelected == true) {
            imgPasswordHidden3.image = #imageLiteral(resourceName: "invisible")
            btnPasswordHiddenBox3.isSelected = false
            self.txtConfirmPass.isSecureTextEntry = true
        }
        else {
            imgPasswordHidden3.image = #imageLiteral(resourceName: "eye")
            btnPasswordHiddenBox3.isSelected = true
            self.txtConfirmPass.isSecureTextEntry = false
        }
    }
    @IBAction func btnPassword_Hide2(sender: UIButton) {
        if (btnPasswordHiddenBox2.isSelected == true) {
            imgPasswordHidden2.image = #imageLiteral(resourceName: "invisible")
            btnPasswordHiddenBox2.isSelected = false
            self.txtNewPass.isSecureTextEntry = true
        }
        else {
            imgPasswordHidden2.image = #imageLiteral(resourceName: "eye")
            btnPasswordHiddenBox2.isSelected = true
            self.txtNewPass.isSecureTextEntry = false
        }
    }
    @IBAction func btnPassword_Hide1(sender: UIButton) {
        if (btnPasswordHiddenBox1.isSelected == true) {
            imgPasswordHidden1.image = #imageLiteral(resourceName: "invisible")
            btnPasswordHiddenBox1.isSelected = false
            self.txtOldPass.isSecureTextEntry = true
        }
        else {
            imgPasswordHidden1.image = #imageLiteral(resourceName: "eye")
            btnPasswordHiddenBox1.isSelected = true
            self.txtOldPass.isSecureTextEntry = false
        }
    }
    @objc func backClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func validationAlertPopup(strAlertTitle:String,strMessage:String,strMessageAlert:String) {
        let alert = UIAlertController(title: String(strAlertTitle), message: String(strMessage)+String(strMessageAlert), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if String(txtOldPass.text ?? "") == "" {
                self.validationAlertPopup(strAlertTitle: "Alert", strMessage: "Old Password ", strMessageAlert: "should not be Empty")
            } else if String(txtNewPass.text ?? "") == "" {
                self.validationAlertPopup(strAlertTitle: "Alert", strMessage: "New Password ", strMessageAlert: "should not be Empty")
            } else if String(txtNewPass.text ?? "") != String(txtConfirmPass.text ?? "") {
                self.validationAlertPopup(strAlertTitle: "Alert", strMessage: "Please make sure ", strMessageAlert: "your passwords match.")
            } else{
                let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
                spinnerActivity.label.text = "Loading";
                spinnerActivity.detailsLabel.text = "Please Wait!!";
                
                if let apiString = URL(string:BaseUrl) {
                    var request = URLRequest(url:apiString)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
                    let values = ["action":"changePassword",
                                  "oldPassword":txtOldPass.text ?? "",
                                  "newPassword":txtNewPass.text ?? "",
                                  "userId": String(dict["userId"]as? Int ?? 0)]as [String : Any]as [String : Any]
                    
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
                                    self.responseDictionary = dict
                                    
                                    self.txtNewPass.text = ""
                                    self.txtOldPass.text = ""
                                    self.txtConfirmPass.text = ""
                                    
                                    let alertController = UIAlertController(title: "Alert", message: self.responseDictionary["msg"]as? String ?? "", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                                        self.navigationController?.pushViewController(push, animated: true)
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

