//
//  Profile.swift
//  Hamd App
//
//  Created by APPLE on 14/08/20.
//  Copyright © 2020 APPLE. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class Profile: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
            lblNavigationTitle.text = "EDIT PROFILE"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    // ***************************************************************** // nav
    
    @IBOutlet var userName : UIView!
    @IBOutlet var email : UIView!
    //    @IBOutlet var phone : UIView!
    @IBOutlet var addresss : UIView!
    
    @IBOutlet var emailTxt : UITextField!
    @IBOutlet var userNameTxt : UITextField!
    //    @IBOutlet var phoneTxt : UITextField!
    @IBOutlet var addressTxt : UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var dict : [String : Any] = [:]
    
    
    var imagePicker :UIImagePickerController?
    var photo1:UIImage?
    var imageData:Data?
    
    @IBOutlet var submitB : UIButton!
    var userid:String?
    var responseDictionary:[String:Any] = [:]
    var check : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        check = "pfl"
        userName.layer.cornerRadius = 10
        userName.layer.masksToBounds = true
        userName.layer.borderWidth = 1
        userName.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        email.layer.cornerRadius = 10
        email.layer.masksToBounds = true
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.lightGray.cgColor
        
        emailTxt.isEnabled = false
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dict = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
        self.getProdileData()
    }
    
    func getProdileData()
    {
        if(UserDefaults.standard.string(forKey: "profileUpdate") == "1") {
            emailTxt.text = self.dict["email"]as? String ?? ""
            userNameTxt.text = self.dict["fullName"]as? String ?? ""
        }else{
            emailTxt.text = UserDefaults.standard.string(forKey: "email")
            userNameTxt.text = UserDefaults.standard.string(forKey: "fullName")
        }
        
        if let apiString = URL(string:BaseUrl) {
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            self.view.isUserInteractionEnabled = false;
            
            var request = URLRequest(url:apiString)
            request.httpMethod = "POST"
            request.setValue("application/json",forHTTPHeaderField: "Content-Type")
            let values = ["action":"profile","userId": String(dict["userId"]as? Int ?? 0)]
            request.httpBody = try! JSONSerialization.data(withJSONObject: values)
            AF.request(request)
                .responseJSON { response in
                    switch response.result {
                    case .failure(let error):
                        print(error)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.view.isUserInteractionEnabled = true;
                        
                        if let data = response.data,
                           let responseString = String(data: data, encoding: .utf8) {
                            print(responseString)
                            print("response \(responseString)")
                        }
                    case .success(let responseObject):
                        print("response \(responseObject)")
                        MBProgressHUD.hide(for:self.view, animated: true)
                        let dict = responseObject as? [String : Any]
                        
                        if let dict = dict?["data"] as? [String:Any] {
                            self.responseDictionary = dict
                            DispatchQueue.main.async {
                                self.profileImageView.dowloadFromServer(link:dict["image"]as?String ?? "", contentMode: .scaleToFill)
                                UserDefaults.standard.setValue(self.responseDictionary["image"]as? String ?? "", forKey: "image")
                                MBProgressHUD.hide(for: self.view, animated: true)
                                self.view.isUserInteractionEnabled = true;
                            }
                        }
                    }
                }
        }
    }
    
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self.profileImageView
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 8.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        photo1 = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage //2
        let img = self.resizeImage(image: self.photo1!, targetSize:CGSize(width:100.0 , height:100.0))
        profileImageView.contentMode = .scaleAspectFill //3
        profileImageView.image = img //4
        if let image  = profileImageView.image,let imageData = image.jpegData(compressionQuality: 8.0) {
            self.imageData = imageData
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func submit (_ sender : UIButton) {
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        self.view.isUserInteractionEnabled = false
        let parameters = ["action":"editProfile","userId":String(dict["userId"]as? Int ?? 0),"address":"","FullName":self.userNameTxt.text ?? "","email":self.emailTxt.text ?? ""] as  [String : Any]
        
        var header = HTTPHeaders()
        header = ["Content-type": "multipart/form-data",
                  "Content-Disposition" : "form-data"]
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            if let img = self.imageData {
                multipartFormData.append(img, withName:"image", fileName: "File.jpg", mimeType: "image/jpg")
            }
        },
        to:BaseUrl, method: .post , headers: header)
        .responseJSON(completionHandler: { (response) in
            print(response)
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.isUserInteractionEnabled = true;
            if let err = response.error {
                print(err)
                return
            }
            print("Succesfully uploaded")
            let json = response.data
            print("Succesfully uploaded")
            self.dismiss(animated:true, completion: nil)
            if (json != nil) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.view.isUserInteractionEnabled = true;
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.view.isUserInteractionEnabled = true;
                }
                
                let alertController = UIAlertController(title: "Alert", message:"Profile successfully updated!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                    print("you have pressed the Ok button")
                    
                    UserDefaults.standard.setValue(self.userNameTxt.text ?? "", forKey: "fullName")
                    UserDefaults.standard.setValue(self.emailTxt.text ?? "", forKey: "email")
                    UserDefaults.standard.setValue("2", forKey: "profileUpdate")
                    self.getProdileData()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        })
    }
}
