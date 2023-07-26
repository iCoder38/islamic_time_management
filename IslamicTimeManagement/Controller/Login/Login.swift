//
//  Login.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation

class Login: UIViewController, UITextFieldDelegate , CLLocationManagerDelegate {

    var str_user_device_token:String!
    
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
                lblNavigationTitle.text = LOGIN_PAGE_NAVIGATION_TITLE
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viewLoginBG:UIView!
    
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            btnDontHaveAnAccount.setTitle("Don't have an account ? - Sign Up", for: .normal)
        }
    }
    
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            btnForgotPassword.setTitle("Forgot Password?", for: .normal)
            btnForgotPassword.setTitleColor(NAVIGATION_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
            btnSignIn.layer.cornerRadius = 24
            btnSignIn.clipsToBounds = true
            btnSignIn.backgroundColor = .black
            btnSignIn.setTitle("Sign In", for: .normal)
            btnSignIn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btnCheckUncheck:UIButton!
    
    @IBOutlet weak var lblEmailTitle:UILabel! {
        didSet {
            lblEmailTitle.textColor = UIColor.init(red: 185.0/255.0, green: 185.0/255.0, blue: 185.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btnPasswordHiddenBox: UIButton!
    @IBOutlet weak var imgPasswordHidden: UIImageView!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var status:String?
    var userId:Int?
    var message:String?
    var name:String?
    var email:String?
    var contactNumber:String?
    var address:String?
    var locationManager = CLLocationManager()
    // var strLat = String()
    // var strLong = String()


    @IBOutlet weak var lblLoginMessage:UILabel! {
        didSet {
            lblLoginMessage.text = "Hello\nSign into your Account"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = UIColor.init(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
        }
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.btnSignIn.addTarget(self, action: #selector(validationBeforeLogin), for: .touchUpInside)
        self.btnDontHaveAnAccount.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
        self.btnForgotPassword.addTarget(self, action: #selector(forgotClickMethod), for: .touchUpInside)

        roundedShadowBorderOnView(view: viewLoginBG)
    }
    
    func roundedShadowBorderOnView(view: UIView) {
        
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 10
        
    }

    @IBAction func btnPassword_Hide(sender: UIButton) {
        if (btnPasswordHiddenBox.isSelected == true) {
            imgPasswordHidden.image = #imageLiteral(resourceName: "invisible")
            btnPasswordHiddenBox.isSelected = false
            self.txtPassword.isSecureTextEntry = true
        }
        else {
            imgPasswordHidden.image = #imageLiteral(resourceName: "eye")
            btnPasswordHiddenBox.isSelected = true
            self.txtPassword.isSecureTextEntry = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // determineMyCurrentLocation()
        // self.strLat = UserDefaults.standard.string(forKey: "latitude") ?? ""
        // self.strLong = UserDefaults.standard.string(forKey: "longitude") ?? ""
//        if(strLat == "" || strLong == "") {
//            let uiAlert = UIAlertController(title: "Alert!", message: "Location Permission Required \nPlease enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
//            self.present(uiAlert, animated: true, completion: nil)
//            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//            }))
//        }
        
    }
    
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        UserDefaults.standard.setValue(userLocation.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.setValue(userLocation.coordinate.longitude, forKey: "longitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK:- KEYBOARD WILL SHOW -
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    // MARK:- KEYBOARD WILL HIDE -
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func signUpClickMethod() {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "RegisterId") as? Register
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    @objc func forgotClickMethod() {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as? ForgotPasswordController
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    // MARK:- VALIDATION BEFORE REGISTRATION -
    @objc func validationBeforeLogin() {
        if String(txtEmail.text!) == "" {
            self.validationAlertPopup(strAlertTitle: "Alert", strMessage: "Email Address ", strMessageAlert: "should not be Empty")
            
        } else if String(txtPassword.text!) == "" {
            self.validationAlertPopup(strAlertTitle: "Alert", strMessage: "Password ", strMessageAlert: "should not be Empty")
        } else {
             self.loginWb()
         }
    }
    
    @objc func validationAlertPopup(strAlertTitle:String,strMessage:String,strMessageAlert:String) {
        let alert = UIAlertController(title: String(strAlertTitle), message: String(strMessage)+String(strMessageAlert), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
         }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginWb() {
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "key_my_device_token") {
            print("defaults savedString: \(myString)")
            
            self.str_user_device_token = "\(myString)"
            
        } else {
            
            self.str_user_device_token = ""
            
        }
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if(txtEmail.text!.isEqual("") ||  txtPassword.text!.isEqual("")) {
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
                if let apiString = URL(string: BaseUrl) {
                    var request = URLRequest(url:apiString)
                    request.httpMethod = "POST"
                    request.setValue("application/json",
                                     forHTTPHeaderField: "Content-Type")
                    let values = ["action":"login",
                                  "email":txtEmail.text ?? "",
                                  "password":txtPassword.text ?? "",
                                  "device":"IOS",
                                  "latitude":"",//self.strLat,
                                  "longitude": "",//strLong,
                                  "deviceToken": String(self.str_user_device_token)] as [String : Any]
                    
                    print("Values \(values)")
                    
                    request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                    AF.request(request).responseJSON { response in
                        // do whatever you want here
                        switch response.result {
                        case .failure(let error):
                            MBProgressHUD.hide(for:self.view, animated: true)
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
                            if self.status == "Fails" {
                                
                                let alertController = UIAlertController(title: "Alert", message:"Invalid Credentials", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                                
                            } else {
                                
                                
                                 self.dataDictionary = self.responseDictionary["data"] as! [String:Any]
                                 let dictLogin : NSDictionary? = self.dataDictionary as NSDictionary
                                UserDefaults.standard.setValue("1", forKey: "loginStatus")
                                self.userId = self.dataDictionary["userId"] as? Int
                                self.name = self.dataDictionary["fullName"] as? String
                                self.email = self.dataDictionary["email"] as? String
                                self.contactNumber = self.dataDictionary["contactNumber"] as? String
                                self.address = self.dataDictionary["address"] as? String
                             
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(self.userId, forKey:"UserID")
                                prefs.set(self.name, forKey:"Name")
                                prefs.set(self.email, forKey:"Email")
                                prefs.set(self.address, forKey:"Address")
                                prefs.set(self.contactNumber, forKey: "ContactNumber")
                                prefs.set(dictLogin, forKey: "kAPI_LOGIN_DATA")
                                prefs.synchronize()
                                
                                UserDefaults.standard.setValue("1", forKey: "profileUpdate")
                             
                                UserDefaults.standard.set(self.dataDictionary["totalValue"], forKey: "totalValue")
                                
                                if  self.dataDictionary["ExpiryStatus"] as? Int == 0 {
                                
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentsViewController")
                                    self.navigationController?.pushViewController(push, animated: true)
                                }
                                else {
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                                    self.navigationController?.pushViewController(push, animated: true)
                                    
                                }
                               
                            }
                        }
                    }
                }
            }
        }
    }
}
