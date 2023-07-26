//
//  PaymentsViewController.swift
//  AutoMedic
//
//  Created by Shyam on 24/11/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import UIKit
//import Stripe
import Alamofire
import MBProgressHUD
import StoreKit

class PaymentsViewController: UIViewController , UITextFieldDelegate,SKProductsRequestDelegate ,SKPaymentTransactionObserver{
    
    var myProduct: SKProduct?
    
       @IBOutlet weak var lblTotalAmount: UILabel!
       @IBOutlet weak var lblCardNumber: UILabel!
       @IBOutlet weak var lblExpDate: UILabel!
       
       @IBOutlet weak var cardNumberField: UITextField!
       @IBOutlet weak var expiryTextField: UITextField!
       @IBOutlet weak var cvvTextField: UITextField!
       @IBOutlet weak var userNameTextField: UITextField!
       @IBOutlet weak var mmTextField: UITextField!
       @IBOutlet weak var yyNameTextField: UITextField!
       
       @IBOutlet weak var lblTip: UILabel!
       
       @IBOutlet weak var btn1: UIButton!
       @IBOutlet weak var btn2: UIButton!
       @IBOutlet weak var btn3: UIButton!
       @IBOutlet weak var btn4: UIButton!
       
       let produto_value =  "Islamic_4_dollar"

      var requestProd = SKProductsRequest()
       var products = [SKProduct]()

    
       var strMM = String()
       var strTotalAmount = String()
       var strInvoiceID = String()
       var strBookID = String()
       var strTip = String()
       
       var idddTrn = String()
       var useTotalAmount = String()
       


    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
      print("here!")
        if let product = response.products.first{
            myProduct = product
            print(product.productIdentifier)
             print(product.price)
             print(product.localizedTitle)
             print(product.localizedDescription)
            
        }
  }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions
          {
            switch transaction.transactionState {
            case .purchasing:
                break
                
            case .purchased, .restored:
             
                UserDefaults.standard.set(true, forKey: "oneYerSubscription")
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                let tokenID = transaction.transactionIdentifier!
                self.UpdatePaymentAPI(strTransactionId: tokenID)
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                               SKPaymentQueue.default().remove(self)
                break
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                               SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
    
    
    
    @IBAction func tapPayBtn() {
        guard let myProduct  =   myProduct else{
            return
        }
        if SKPaymentQueue.canMakePayments(){
            let payemnt = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payemnt)
        }
    }
    
    
    // ***************************************************************** // nav
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
            lblNavigationTitle.text = "PAYMENT"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchAvailableProducts()
        
        if !UserDefaults.standard.bool(forKey: "oneYerSubscription")
        {
            
        }
        else
        {
            
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    
    func fetchAvailableProducts() {
      
        let productID:NSSet = NSSet(object: self.produto_value);
        let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
           productsRequest.delegate = self;
           productsRequest.start();
       }
    
    func validateProductIdentifiers() {
           let productsRequest = SKProductsRequest(productIdentifiers: Set(["Islamic_4_dollar", "com.evs.Islamic_4doller"]))

           // Keep a strong reference to the request.
           self.requestProd = productsRequest;
           productsRequest.delegate = self
           productsRequest.start()
       }

    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
   
    
//    @objc func firstCheckValidation() {
//        if userNameTextField.text == "" {
//            let alert = UIAlertController(title: "Name", message: "Name should not be blank", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else
//            if cardNumberField.text == "" {
//                let alert = UIAlertController(title: "Card Number", message: "Card number should not be blank", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else if lblExpDate.text == "" {
//                let alert = UIAlertController(title: "Exp Month", message: "Expiry Month should not be blank", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else if cvvTextField.text == "" {
//                let alert = UIAlertController(title: "Security Code", message: "Security Code should not be blank", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//
//                let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
//                spinnerActivity.label.text = "Loading";
//                spinnerActivity.detailsLabel.text = "Please Wait!!";
//
//                let cardParams = STPCardParams()
//                cardParams.number = String(cardNumberField.text!) // "4242424242424242"
//                cardParams.expMonth =  UInt(Int(mmTextField.text ?? "") ?? 0)
//                cardParams.expYear =  UInt(Int(yyNameTextField.text ?? "") ?? 0) // 25
//                cardParams.cvc = String(cvvTextField.text ?? "") // "242"
//
//                STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
//                    guard let token = token else {
//                        // Handle the error
//                        MBProgressHUD.hide(for:self.view, animated: true)
//                        let alert = UIAlertController(title: "Alert!", message: "Payment Error", preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { action in
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                        return
//                    }
//                    let tokenID = token.tokenId
//                    print(tokenID)
//                    self.idddTrn = tokenID
//                    self.UpdatePaymentAPI(strTransactionId: tokenID)
//                }
//        }
//    }
    //MARK: - IBActions
    
//    @IBAction func tapPayNowBtn(_ sender : UIButton) {
//        firstCheckValidation()
//    }
//
    //MARK: - Call Api
    func UpdatePaymentAPI( strTransactionId : String ) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
                let dictRequestSendOnServer:NSMutableDictionary = NSMutableDictionary()
                dictRequestSendOnServer.setValue( "updatepayment", forKey: "action")
                dictRequestSendOnServer.setValue( "3.99", forKey: "amount")
                dictRequestSendOnServer.setValue( String(dict["userId"]as? Int ?? 0), forKey: "userId")
                dictRequestSendOnServer.setValue( strTransactionId, forKey: "transactionId")
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: dictRequestSendOnServer)
                AF.request(request).responseJSON { response in
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
                            MBProgressHUD.hide(for:self.view, animated: true)
                        }
                    case .success(let responseObject):
                        DispatchQueue.main.async {
                        }
                        print("response \(responseObject)")
                        MBProgressHUD.hide(for:self.view, animated: true)
                        if let dict = responseObject as? [String:Any] {
                            print("dictdict :: \(dict)")
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                            UserDefaults.standard.setValue("1", forKey: "profileUpdate")
                            UserDefaults.standard.setValue("1", forKey: "loginStatus")
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                            self.navigationController?.pushViewController(push, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "." {
            return false
        }
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if textField == cardNumberField {
                if updatedText.count > 16 {
                    return false
                }
                else
                {
                    self.lblCardNumber.text = updatedText
                }
            } else if textField == cvvTextField {
                if updatedText.count > 3 {
                    return false
                }
            } else if textField == expiryTextField {
                
                if updatedText.count > 5 {
                    return false
                }
                else
                {
                    self.lblExpDate.text = updatedText
                }
            } else if textField == mmTextField {
                if updatedText.count > 2 {
                    return false
                }
                else
                {
                    strMM = updatedText
                    self.lblExpDate.text = updatedText
                }
            }  else if textField == yyNameTextField {
                if updatedText.count > 2 {
                    return false
                }
                else
                {
                    self.lblExpDate.text = "\(strMM) / \(updatedText)"
                }
            }
        }
        return true
    }
}
