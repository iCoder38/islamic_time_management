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

class LibraryDetailPageVC: UIViewController,UITextFieldDelegate {
    var responseDictionary:[String:Any] = [:]
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
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
            lblNavigationTitle.text = "THIS SIDE OF PARADISE"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = responseDictionary["name"]as? String ?? ""
        lblDescription.text = responseDictionary["description"]as? String ?? ""

        let imgUrl = responseDictionary["image"]as?String ?? ""
        if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.img.dowloadFromServer(link: urlString, contentMode: .scaleAspectFit)
        }
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PDFReaderVC") as? PDFReaderVC
        vc?.responseDictionaryPdf = responseDictionary
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}

