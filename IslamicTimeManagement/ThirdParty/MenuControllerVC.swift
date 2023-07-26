//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD

class MenuControllerVC: UIViewController {
    
    let cellReuseIdentifier = "menuControllerVCTableCell"
    var bgImage: UIImageView?
    var roleIs:String!
    
    var status:String?
    
    var responseDictionary:[String:Any] = [:]
    
    var dict : [String : Any] = [:]
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            viewUnderNavigation.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MENU"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgBrick:UIButton!
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
            imgSidebarMenuImage.backgroundColor = .white
            imgSidebarMenuImage.layer.borderWidth = 1
            imgSidebarMenuImage.layer.borderColor = UIColor.black.cgColor
            imgSidebarMenuImage.layer.cornerRadius = imgSidebarMenuImage.frame.width / 2
            imgSidebarMenuImage.clipsToBounds = true
        }
    }
    
    
    var arrSidebarMenuUserProfileDeliveryServiceTitle = ["Dashboard", "Edit Profile","Goals", "Evaluate Yourself", "Quiz", "Library", "Change Password", "Help", "Delete Account","Logout"]
    var arrSidebarMenuUserProfileDeliveryServiceImage = ["home","editL","goalL","tripL","noteQL","scheduleL","lcokL","helpL","delete_account","logout"]
    
    
    
    @IBOutlet weak var lblTotalCount:UILabel!
    
    @IBOutlet weak var btnImage: UIButton!

    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            
            lblUserName.text = "User Name"
            lblUserName.textColor = .black
        }
    }
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
        }
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = NAVIGATION_COLOR
            tbleView.separatorColor = .white
        }
    }
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.tbleView.separatorColor = .white
        self.view.backgroundColor = .white
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.dict = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
        
        DispatchQueue.main.async {
            let countt = UserDefaults.standard.string(forKey: "totalValue")
            if(countt != "" || countt != "0" || countt != nil) {
                
                self.lblTotalCount.text = "\(UserDefaults.standard.string(forKey: "totalValue") ?? "") Bricks "
                self.imgBrick.isHidden = false
                
            } else {
                
                self.lblTotalCount.text = ""
                self.imgBrick.isHidden = true
                
            }
        }

        if(UserDefaults.standard.string(forKey: "profileUpdate") == "1") {
            DispatchQueue.main.async {
                self.lblUserName.text = (self.dict["fullName"]as? String ?? "").uppercased()
                self.imgSidebarMenuImage.image = UIImage(named: "logo")
                if (self.dict["image"]as? String ?? "" != "") {
                    self.imgSidebarMenuImage.sd_setImage(with: URL(string: (self.dict["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                }
            }
        } else {
            DispatchQueue.main.async {
                self.lblUserName.text = UserDefaults.standard.string(forKey:"fullName")
                if (UserDefaults.standard.string(forKey:"image") != "") {
                    self.imgSidebarMenuImage.dowloadFromServer(link:UserDefaults.standard.string(forKey:"image") ?? "", contentMode: .scaleToFill)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func btnClickBrickME(_ sender: Any) {
        let myString = "backOrMenu"
        UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ESLotteryWinViewControllerRetailer")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
    }
    
    
    
    @objc func delete_account_permanently() {
        
         
        
        let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
        
        let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        if let apiString = URL(string: BaseUrl) {
            var request = URLRequest(url:apiString)
            request.httpMethod = "POST"
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            let values = ["action":"userdelete",
                          "userId":String(dict["userId"]as? Int ?? 0)] as [String : Any]
            
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
                        
                        UserDefaults.standard.removeObject(forKey:"keyBackOrSlide")
                        UserDefaults.standard.removeObject(forKey:"loginStatus")
                        UserDefaults.standard.removeObject(forKey: "kAPI_LOGIN_DATA")
                        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedNowId") as! GetStartedNow
                        UserDefaults.standard.removeObject(forKey: "login_status")
                        self.setUpRootVC(rootVC: destinationController)
                       
                    }
                }
            }
        }
    }
    
    
    
    
    
    
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSidebarMenuUserProfileDeliveryServiceTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.lblName.text = arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row]
        cell.lblName.textColor = .white
        
        cell.imgProfile.image = UIImage(named: arrSidebarMenuUserProfileDeliveryServiceImage[indexPath.row])
        cell.imgProfile.backgroundColor = .clear
        cell.imgProfile.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Evaluate Yourself" {
            
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "EvaluateYourselfId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Dashboard" {
            
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Help" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Change Password" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordController")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Edit Profile" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Profile")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Quiz" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "SelectQuizLevelId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
        }
        else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Library" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "LibraryVC")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
        }
        
        else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Goals" {
            let myString = "backOrMenu"
            UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "SetYourGoalsListId")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
        }
        else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Logout" {
            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to logout?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            }
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                UserDefaults.standard.removeObject(forKey:"keyBackOrSlide")
                UserDefaults.standard.removeObject(forKey:"loginStatus")
                UserDefaults.standard.removeObject(forKey: "kAPI_LOGIN_DATA")
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedNowId") as! GetStartedNow
                UserDefaults.standard.removeObject(forKey: "login_status")
                self.setUpRootVC(rootVC: destinationController)
            }
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        } else if arrSidebarMenuUserProfileDeliveryServiceTitle[indexPath.row] == "Delete Account" {
            
            
            
            
            
            let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account ? \n\nAll of your data will be deleted permanently.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            }
            let okAction = UIAlertAction(title: "Yes, Delete", style: .default) { (action:UIAlertAction!) in
                
                self.delete_account_permanently()
                
                
            }
            alertController.addAction(cancel)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    //MARK: - SetUP Navigation Helper func
    func setUpRootVC(rootVC: UIViewController) {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.backgroundColor = UIColor.white
        self.view.window?.rootViewController = navigationController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
