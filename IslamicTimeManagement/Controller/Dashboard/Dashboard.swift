//
//  Dashboard.swift
//  ComplyBag
//
//  Created by Apple on 09/01/21.
//

import UIKit

class Dashboard: UIViewController {
    
    var dictOfNotificationPopup:NSDictionary!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .black
        }
    }
    @IBOutlet weak var btnEdit:UIButton!
    
    @IBOutlet weak var btnStopSchedule:UIButton! {
        didSet {
            btnStopSchedule.layer.cornerRadius = 4
            btnStopSchedule.clipsToBounds = true
            btnStopSchedule.backgroundColor = UIColor.init(red: 240.0/255.0, green: 210.0/255.0, blue: 70.0/255.0, alpha: 1) // 240, 210, 70
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
     @IBOutlet weak var btnGroup:UIButton!
    
    @IBOutlet weak var btnNewRequest:UIButton! {
        didSet {
            btnNewRequest.layer.cornerRadius = 6
            btnNewRequest.clipsToBounds = true
            btnNewRequest.backgroundColor = .black
            btnNewRequest.setTitle("Quiz", for: .normal)
            btnNewRequest.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btnDeliveredHistory:UIButton! {
        didSet {
            btnDeliveredHistory.layer.cornerRadius = 6
            btnDeliveredHistory.clipsToBounds = true
            btnDeliveredHistory.backgroundColor = .black
            btnDeliveredHistory.setTitle("Goals", for: .normal)
            btnDeliveredHistory.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var imgVieww:UIImageView!
    
    @IBOutlet weak var switchh:UISwitch! {
        didSet {
            switchh.isHidden = true
        }
    }
    
    @IBOutlet weak var bottomVieww:UIView! {
        didSet {
            bottomVieww.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnEdit.addTarget(self, action: #selector(editClickMethod), for: .touchUpInside)
        self.btnGroup.addTarget(self, action: #selector(groupClickMethod), for: .touchUpInside)

        self.btnDeliveredHistory.addTarget(self, action: #selector(shopNowClickMethod), for: .touchUpInside)
        self.btnNewRequest.addTarget(self, action: #selector(orderClickMethod), for: .touchUpInside)

        let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
        self.lblTitle.text = "Welcome, \n"+(dict["fullName"]as? String ?? "")
       
        self.switchh.addTarget(self, action: #selector(switchhClickMethod), for: .valueChanged)
        self.sideBarMenuClick()
    }
    
    @objc func orderClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectQuizLevelId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    // MARK:- JOB HISTORY -
    @objc func shopNowClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SetYourGoalsListId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    // MARK:- EDIT -
    @objc func editClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Profile")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func groupClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EvaluateYourselfId")
        self.navigationController?.pushViewController(push, animated: true)
    }

    
    @objc func switchhClickMethod() {
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    // MARK:- PUSH TO SPOT SCHEDULING -
    @objc func pushToDashboardPD() {
         // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PDSpotSchedulingId") as? PDSpotScheduling
         // self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
}
