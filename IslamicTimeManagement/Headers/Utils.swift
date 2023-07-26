
//

import UIKit
import CoreLocation

// MARK:- BASE URL -
//let APPLICATION_BASE_URL = ""

// 207,231,244
let NAVIGATION_COLOR = UIColor.init(red: 36.0/255.0, green: 81.0/255.0, blue: 193.0/255.0, alpha: 1)

let APP_BASIC_COLOR = UIColor.init(red: 50.0/255.0, green: 97.0/255.0, blue: 138.0/255.0, alpha: 1)

let BUTTON_DARK_APP_COLOR = UIColor.init(red: 169.0/255.0, green: 163.0/255.0, blue: 131.0/255.0, alpha: 1)

let APP_BUTTON_COLOR = UIColor.black// UIColor.init(red: 43.0/255.0, green: 100.0/255.0, blue: 191.0/255.0, alpha: 1)


let NAVIGATION_TITLE_COLOR  = UIColor.white
let NAVIGATION_BACK_COLOR   = UIColor.white
let CART_COUNT_COLOR        = UIColor.black


// URLs
let URL_HARILOSS_SUPPORT_GROUP  = "https://www.google.co.in"
//let BaseUrl = "http://demo2.evirtualservices.co/islamic-time-management/site/services/index"

// Live Base Url //
let BaseUrl = "https://app.islamictimemanagement.com/services/index"






let ALERT_MESSAGE       = "Alert!"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE        = "Server Not Responding. Please check your Internet Connection."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact to Server Admin."


// NAVIGATION TITLES
let WELCOME_PAGE_NAVIGATION_TITLE = "CONTINUE AS A"
let DISCLAIMER_PAGE_NAVIGATION_TITLE = "DISCLAIMER"
let REGISTRATION_PAGE_NAVIGATION_TITLE = "SIGN UP"
let COMPLETE_ADDRESS_PAGE_NAVIGATION_TITLE = "COMPLETE ADDRESS"
let LOGIN_PAGE_NAVIGATION_TITLE = "SIGN IN"
let DASHBOARD_PAGE_NAVIGATION_TITLE = "DASHBOARD"
let ORDER_FOOD_PAGE_NAVIGATION_TITLE = "ORDER FOOD"
let CART_LIST_NAVIGATION_TITLE = "CART"
let REVIEW_ORDER_NAVIGATION_TITLE = "REVIEW ORDER"
let DELIVERY_ADDRESS_NAVIGATION_TITLE = "DELIVERY ADDRESS"
let SUCCESS_NAVIGATION_TITLE = "SUCCESS"
let FOOD_ORDER_DETAILS_NAVIGATION_TITLE = "FOOD ORDER DETAILS"

class Utils: NSObject {
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show(viewController, sender: self)
        
    }
    
    // button
    class func textFieldUI(textField:UITextField,tfName:String,tfCornerRadius:CGFloat,tfpadding:CGFloat,tfBorderWidth:CGFloat,tfBorderColor:UIColor,tfAppearance:UIKeyboardAppearance,tfKeyboardType:UIKeyboardType,tfBackgroundColor:UIColor,tfPlaceholderText:String) {
        textField.text = tfName
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(tfpadding)
        textField.layer.borderWidth = tfBorderWidth
        textField.layer.borderColor = tfBorderColor.cgColor
        textField.keyboardAppearance = tfAppearance
        textField.keyboardType = tfKeyboardType
        textField.backgroundColor = tfBackgroundColor
        textField.placeholder = tfPlaceholderText
    }
    
    //MARK:- TEXT FIELD UI -
    class func setPaddingWithImage(textfield: UITextField,placeholder:String,bottomLineColor:UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = bottomLineColor.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.placeholder = placeholder
        textfield.leftViewMode = .always
        
        textfield.backgroundColor = .clear
    }
    
    /*
     btnDriver.layer.cornerRadius = 8
     btnDriver.clipsToBounds = true
     btnDriver.backgroundColor = NAVIGATION_COLOR
     btnDriver.setTitleColor(.black, for: .normal)
     btnDriver.setTitle("Driver", for: .normal)
     */
    
    // button
    class func buttonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bTitle:String,bTitleColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.setTitle(bTitle, for: .normal)
        button.setTitleColor(bTitleColor, for: .normal)
    }
    
    // text field
    class func textFieldStyle(textField:UITextField,tfCornerRadius:CGFloat,tfBackgroundColor:UIColor,tfTitle:String,tfTitleColor:UIColor,tfpadding:CGFloat) {
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.backgroundColor = tfBackgroundColor
        textField.text = tfTitle
        textField.textColor = tfTitleColor
        textField.setLeftPaddingPoints(tfpadding)
    }
    
    
    // MARK:- SCREEN ( MEMBERSHIP ) -
    /*
     btnSelectFour.layer.borderWidth = 1
     btnSelectFour.layer.borderColor = UIColor.white.cgColor
     btnSelectFour.layer.cornerRadius = 15
     btnSelectFour.clipsToBounds = true
     */
    
    class func membershipButtonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bBorderWidth:CGFloat,bBorderColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.layer.borderWidth = bBorderWidth
        button.layer.borderColor = bBorderColor.cgColor
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


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.subAdministrativeArea,$0?.first?.locality,$0?.first?.subLocality, $1) }
    }
    
    func countryCode(completion: @escaping (_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.isoCountryCode, $1) }
    }
    
    func fullAddressFull(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?,_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.administrativeArea,$0?.first?.locality,$0?.first?.subLocality,$0?.first?.isoCountryCode, $1) }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    /*func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }*/
}


extension UIView {

 func addBottomLine(color: UIColor, height: CGFloat) {

   let bottomView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: height))
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    bottomView.autoresizingMask = .flexibleWidth
    bottomView.backgroundColor = color
    self.addSubview(bottomView)
 }

}
