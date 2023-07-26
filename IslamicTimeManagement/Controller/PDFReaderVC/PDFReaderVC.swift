//
//  ESForgotPasswordController.swift
//  Eshaan
//
//  Created by IOSdev on 10/28/20.
//  Copyright © 2020 evs. All rights reserved.
//

import UIKit
import MBProgressHUD
import WebKit

class PDFReaderVC: UIViewController,UITextFieldDelegate {
    var responseDictionaryPdf:[String:Any] = [:]
    @IBOutlet weak var webView: WKWebView!
    
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
            lblNavigationTitle.text = "PDF VIEWER"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        let imgUrl = responseDictionaryPdf["media"]as?String ?? ""
        if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: urlString)
            webView.load(URLRequest(url: url!)
        )}
    }
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
}
