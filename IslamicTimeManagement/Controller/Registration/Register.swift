//
//  Register.swift
//  ShootWorthy
//
//  Created by Apple on 21/12/20.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation


class Register: UIViewController, UITextFieldDelegate , CLLocationManagerDelegate {
    
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
//                lblNavigationTitle.text = "CREATE AN ACCOUNT"
                lblNavigationTitle.text = "SIGN UP"

                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    var whoIam:String!
    
    @IBOutlet weak var viewLoginBG:UIView!
    
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            btnDontHaveAnAccount.setTitle("Already have an account ? - Sign In", for: .normal)
        }
    }
    
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            btnForgotPassword.setTitle("Forgot Password", for: .normal)
            btnForgotPassword.setTitleColor(BUTTON_DARK_APP_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSignIn, bCornerRadius: 24, bBackgroundColor: .black, bTitle: "Sign up", bTitleColor: .white)
        }
    }
    
    
    @IBOutlet weak var lblEmailTitle:UILabel! {
        didSet {
            lblEmailTitle.textColor = UIColor.init(red: 185.0/255.0, green: 185.0/255.0, blue: 185.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
//    @IBOutlet weak var txtPhoneNumber:UITextField!
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

    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var btnPasswordHiddenBox: UIButton!
    @IBOutlet weak var imgPasswordHidden: UIImageView!
    @IBOutlet weak var lblLoginMessage:UILabel! {
        didSet {
            lblLoginMessage.text = "Create an Account"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(whoIam as Any)
        
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        self.view.backgroundColor = UIColor.init(red: 252.0/255.0, green: 252.0/255.0, blue: 252.0/255.0, alpha: 1)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.btnSignIn.addTarget(self, action: #selector(signInClickMethod), for: .touchUpInside)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btnDontHaveAnAccount.addTarget(self, action: #selector(dontClickMethod), for: .touchUpInside)
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
    
    @IBAction func btn_box(sender: UIButton) {
        if (btnCheckBox.isSelected == true) {
            imgCheckBox.image = #imageLiteral(resourceName: "uncheckB")
            btnCheckBox.isSelected = false
        }
        else {
            imgCheckBox.image = #imageLiteral(resourceName: "checkB")
            btnCheckBox.isSelected = true
        }
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsConditionVC")
        self.navigationController?.pushViewController(push, animated: true)
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
    
    
    @objc func dontClickMethod() {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "LoginId") as? Login
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    @objc func signInClickMethod() {
        if self.txtName.text == "" {
            let alert = UIAlertController(title: String("Alert"), message: String("Name should not be empty."), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtEmail.text == "" {
            
            let alert = UIAlertController(title: String("Alert"), message: String("Email should not be empty."), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             }))
            self.present(alert, animated: true, completion: nil)
            
        } else if !isValidEmail(testStr: self.txtEmail.text!) {
            
            print("Validate EmailID")
            let alert = UIAlertController(title: "Error!", message: "Please Enter a valid E-Mail Address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        } else if self.txtPassword.text == "" {
            
            let alert = UIAlertController(title: String("Alert"), message: String("Password should not be empty."), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
             }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if(btnCheckBox.isSelected == true){
                self.registrationWb()
            }else{
                let alert = UIAlertController(title: "Alert", message: "Accept the Terms and Conditions.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func registrationWb() {
        
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
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    let values = ["action":"registration",
                                  "email":txtEmail.text ?? "",
                                  "password":txtPassword.text ?? "",
                                  "fullName":txtName.text ?? "",
//                                  "contactNumber":txtPhoneNumber.text ?? "",
                                  "latitude":"", // strLat,
                                  "longitude":"", // strLong,
                                  "address":"",
                                  "role":"Member",
                                  "deviceToken":String(self.str_user_device_token)] as [String : Any]
                    
                    print("Values \(values)")
                    request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                    AF.request(request).responseJSON { response in
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
                                let alertController = UIAlertController(title: "Alert", message:self.responseDictionary["msg"] as? String, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }else{
                                UserDefaults.standard.setValue("2", forKey: "loginStatus")
                                self.dataDictionary = self.responseDictionary["data"] as! [String:Any]
                                self.userId = self.dataDictionary["userId"] as? Int
                                self.name = self.dataDictionary["fullName"] as? String
                                self.email = self.dataDictionary["email"] as? String
                                self.contactNumber = self.dataDictionary["contactNumber"] as? String
                                self.address = self.dataDictionary["address"] as? String
                                let dictLogin : NSDictionary? = self.dataDictionary as NSDictionary
                                
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(self.userId, forKey:"UserID")
                                prefs.set(self.name, forKey:"Name")
                                prefs.set(self.email, forKey:"Email")
                                prefs.set(self.address, forKey:"Address")
                                prefs.set(self.contactNumber, forKey: "ContactNumber")
                                prefs.set(dictLogin, forKey: "kAPI_LOGIN_DATA")
                                prefs.synchronize()

                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentsViewController")
                                self.navigationController?.pushViewController(push, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validpassword(mypassword : String) -> Bool {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 8 characters total
            // let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
            let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: mypassword)
    }
}
