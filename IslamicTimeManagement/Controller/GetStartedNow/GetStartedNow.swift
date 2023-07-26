//
//  GetStartedNow.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit

class GetStartedNow: UIViewController {
    
    // ***************************************************************** // nav
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CREATE AN ACCOUNT"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
            btnSignIn.layer.cornerRadius = 24
            btnSignIn.clipsToBounds = true
            btnSignIn.backgroundColor = .black
            btnSignIn.setTitle("Sign In", for: .normal)
            btnSignIn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btnCreateAnAccount:UIButton! {
        didSet {
            btnCreateAnAccount.layer.cornerRadius = 24
            btnCreateAnAccount.clipsToBounds = true
            btnCreateAnAccount.backgroundColor = .black
            btnCreateAnAccount.setTitle("Create an account", for: .normal)
            btnCreateAnAccount.setTitleColor(.white, for: .normal)
        }
    }
    
    
    var dict : [String : Any] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if(UserDefaults.standard.string(forKey: "loginStatus") == "1")
        {
            self.dict = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            
            if  self.dict["ExpiryStatus"] as? Int == 0 {
                
//                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaymentsViewController")
//                self.navigationController?.pushViewController(push, animated: true)
            }
            else
            {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
                self.navigationController?.pushViewController(push, animated: true)
            }
            
        }
        self.btnSignIn.addTarget(self, action: #selector(signInClickMethod), for: .touchUpInside)
        self.btnCreateAnAccount.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
    }
    
    @objc func signInClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func signUpClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
}
