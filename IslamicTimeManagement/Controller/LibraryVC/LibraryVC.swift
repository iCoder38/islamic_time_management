//
//  Register.swift
//  ShootWorthy
//
//  Created by Apple on 21/12/20.
//

import UIKit
import Alamofire
import MBProgressHUD
import AVKit
import YouTubePlayer


class LibraryVC: UIViewController {
    var responseDictionary:[String:Any] = [:]
    var responseArray:[[String:Any]] = [[:]]
    
    // ***************************************************************** // nav
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ONLINE LIBRARY"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var viewFullViewWithImage: UIView!

    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblimgTitle: UILabel!

    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var counterTotalArrayValue = Int()
    
    // ***************************************************************** // nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.sideBarMenuClick()
        counterTotalArrayValue = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LibraryVC.imageTapped(gesture:)))
        img.addGestureRecognizer(tapGesture)
        img.isUserInteractionEnabled = true
        
        self.btnPrevious.isHidden = true
        self.btnNext.isHidden = false
        self.getLibraryData()

    }

    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
        
    func getLibraryData(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["action":"libarary"]as [String : Any]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
                        // do whatever you want here
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
                            }
                        case .success(let responseObject):
                            DispatchQueue.main.async {
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                            print("response \(responseObject)")
                            MBProgressHUD.hide(for:self.view, animated: true)
                            if let dict = responseObject as? [String:Any] {
                                self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
                                print(self.responseArray)
                                if(self.responseArray.count != 0){
                                    let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
                                    self.lblVideoTitle.text = "\(dict["name"]as?String ?? "")"
                                    self.lblimgTitle.text = "\(dict["name"]as?String ?? "")"
                                    if(dict["YouTube"]as?String ?? "" != ""){
                                        self.getVideoIdFromUrlString(videURL: dict["YouTube"]as?String ?? "")
                                        self.img.isHidden = true
                                        self.viewVideo.isHidden = false
                                        self.lblimgTitle.isHidden = true
                                        self.viewFullViewWithImage.backgroundColor = .clear
                                    }else{ // image
                                        let imgUrl = dict["image"]as?String ?? ""
                                        if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                            self.img.dowloadFromServer(link: urlString, contentMode: .scaleToFill)
                                        }
                                        self.viewVideo.isHidden = true
                                        self.img.isHidden = false
                                        self.lblimgTitle.isHidden = false
                                        self.viewFullViewWithImage.backgroundColor = .white
                                        self.roundedShadowBorderOnView(view: self.viewFullViewWithImage)
                                    }
                                }else{
                                }
                            }
                        }
                    }
                }
            }
        }
    
    func roundedShadowBorderOnView(view: UIView){
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 10
    }

    
    @IBAction func btnPreviousClick(_ sender: UIButton) {
        if(counterTotalArrayValue > 1){
            btnPrevious.isHidden = false
            btnNext.isHidden = false
            self.counterTotalArrayValue -= 1
            let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
            self.lblVideoTitle.text = "\(dict["name"]as?String ?? "")"
            self.lblimgTitle.text = "\(dict["name"]as?String ?? "")"

            if(dict["YouTube"]as?String ?? "" != ""){
                self.getVideoIdFromUrlString(videURL: dict["YouTube"]as?String ?? "")
                self.img.isHidden = true
                self.lblimgTitle.isHidden = true
                self.viewVideo.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .clear
            }else{ // image
                let imgUrl = dict["image"]as?String ?? ""
                if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    self.img.dowloadFromServer(link: urlString, contentMode: .scaleToFill)
                }
                self.viewVideo.isHidden = true
                self.img.isHidden = false
                self.lblimgTitle.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .white
                self.roundedShadowBorderOnView(view: self.viewFullViewWithImage)
            }
        }else{
            btnPrevious.isHidden = true
            self.counterTotalArrayValue -= 1
            let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
            self.lblVideoTitle.text = "\(dict["name"]as?String ?? "")"
            self.lblimgTitle.text = "\(dict["name"]as?String ?? "")"
            if(dict["YouTube"]as?String ?? "" != ""){
                self.getVideoIdFromUrlString(videURL: dict["YouTube"]as?String ?? "")
                self.img.isHidden = true
                self.lblimgTitle.isHidden = true
                self.viewVideo.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .clear
            }else{ // image
                let imgUrl = dict["image"]as?String ?? ""
                if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    self.img.dowloadFromServer(link: urlString, contentMode: .scaleToFill)
                }
                self.viewVideo.isHidden = true
                self.img.isHidden = false
                self.lblimgTitle.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .white
                self.roundedShadowBorderOnView(view: self.viewFullViewWithImage)
            }
        }
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        if(counterTotalArrayValue + 2 >= responseArray.count){
            btnNext.isHidden = true
            self.counterTotalArrayValue += 1
            let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
            self.lblVideoTitle.text = "\(dict["name"]as?String ?? "")"
            self.lblimgTitle.text = "\(dict["name"]as?String ?? "")"
            if(dict["YouTube"]as?String ?? "" != ""){
                self.getVideoIdFromUrlString(videURL: dict["YouTube"]as?String ?? "")
                self.img.isHidden = true
                self.lblimgTitle.isHidden = true
                self.viewVideo.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .clear
            }else{ // image
                let imgUrl = dict["image"]as?String ?? ""
                if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    self.img.dowloadFromServer(link: urlString, contentMode: .scaleToFill)
                }
                self.viewVideo.isHidden = true
                self.img.isHidden = false
                self.lblimgTitle.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .white
                self.roundedShadowBorderOnView(view: self.viewFullViewWithImage)
            }
        }else{
            btnNext.isHidden = false
            btnPrevious.isHidden = false
            self.counterTotalArrayValue += 1
            let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
            self.lblVideoTitle.text = "\(dict["name"]as?String ?? "")"
            self.lblimgTitle.text = "\(dict["name"]as?String ?? "")"
            if(dict["YouTube"]as?String ?? "" != ""){
                self.getVideoIdFromUrlString(videURL: dict["YouTube"]as?String ?? "")
                self.img.isHidden = true
                self.lblimgTitle.isHidden = true
                self.viewVideo.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .clear
            }else{ // image
                let imgUrl = dict["image"]as?String ?? ""
                if let urlString = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    self.img.dowloadFromServer(link: urlString, contentMode: .scaleToFill)
                }
                self.viewVideo.isHidden = true
                self.img.isHidden = false
                self.lblimgTitle.isHidden = false
                self.viewFullViewWithImage.backgroundColor = .white
                self.roundedShadowBorderOnView(view: self.viewFullViewWithImage)
            }
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let dict : [String :Any] = self.responseArray[self.counterTotalArrayValue]
            print("Image Tapped \(dict)")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LibraryDetailPageVC") as? LibraryDetailPageVC
            vc?.responseDictionary = dict
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    
    func getVideoIdFromUrlString(videURL : String){
        let url = videURL
        do {
            let regex = try NSRegularExpression(pattern: "(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)", options: NSRegularExpression.Options.caseInsensitive)
            let match = regex.firstMatch(in: url, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, url.lengthOfBytes(using: String.Encoding.utf8)))
            let range = match?.range(at: 0)
            let youTubeID = (url as NSString).substring(with: range!)
            print("youTubeID :: \(youTubeID)")
            self.playerView.playerVars = [
                "playsinline": "1",
                "controls": "0",
                "showinfo": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
            self.playerView.loadVideoID(youTubeID) // playerView.stop()
        } catch {
        }
    }
}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range)
    }
}
