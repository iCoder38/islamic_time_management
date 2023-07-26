//
//  QuizQuestionAnswerVerticallyVC.swift
//  btutee
//
//  Created by apple on 17/10/19.
//  Copyright © 2019 Sumit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

@available(iOS 13.0, *)
class QuizQuestionAnswerVerticallyVC: UIViewController , UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var viewCollection: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var lblBottomCountBar: UILabel!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var lblShowTime: UILabel!
    @IBOutlet var viewQuestion: UIView!

    var questionIndexCounter = Int()
    var questionTotalCount = Int()
    var selectedIndexOfTbl = Int()
    var selectedQuestionID = String()
    var selectedQuestionDict:[String:Any] = [:]
    var arrQuestionAnswerShow : NSMutableArray = NSMutableArray()
    var arrQuestionAnswerListing:[[String:Any]] = [[:]]
    var arrJSON:[[String:Any]] = [[:]]
    
    var strTitile = String()
    var strType = String()
    var arrQuizDataMakeJsonResponse:NSMutableArray = []
    
    //======Start Timer======//
    var minuts = Int()
    var totalSecondsCountDown:Int = Int()
    var timer = Timer()

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = strTitile
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        selectedIndexOfTbl = -1
        callGetAllQuizQuestionList()
        
        viewQuestion.layer.borderWidth = 2
        viewQuestion.layer.borderColor = UIColor.black.cgColor
        viewQuestion.layer.cornerRadius = 10
        lblQuestion.layer.cornerRadius = 20
        
        self.minuts = Int(2.5 * 60)  // mm:ss  = 9*60 = mm*ss
        self.totalSecondsCountDown = self.minuts
        self.startCountDownTimer()
        
        btnNext.isHidden = true
        btnNext.isUserInteractionEnabled = false
    }
    

    func startCountDownTimer() {
        if self.totalSecondsCountDown > 0 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimerFire), userInfo: nil, repeats: true)
        }
    }
    
    @objc func handleTimerFire() {
        if self.totalSecondsCountDown > 0 {
            self.totalSecondsCountDown = self.totalSecondsCountDown - 1
            self.lblShowTime.text = timeString(from: TimeInterval(self.totalSecondsCountDown))
           // print("timer countdown : \(self.totalSecondsCountDown)")
        } else{
            self.stopCountDownTimer()
            self.submitQuestionAnswer()
          //  print("timer stops ...")
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    func stopCountDownTimer() {
        self.timer.invalidate()
    }
    
    func callGetAllQuizQuestionList() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]

            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["action":"quizlist","type":"2","level":strType,"userId":String(dict["userId"]as? Int ?? 0)]as [String : Any]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
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
                                self.arrQuestionAnswerListing = dict["data"] as? [[String : Any]] ?? [[:]]
                                if(self.arrQuestionAnswerListing.count != 0){
                                    self.questionIndexCounter = 0
                                    self.questionTotalCount = self.arrQuestionAnswerListing.count
                                    let dictCollection:[String:Any] = self.arrQuestionAnswerListing[self.questionIndexCounter]
                                    self.lblQuestion.text = "\(dictCollection["question"] as? String ?? "")"
                                    self.selectedQuestionID = "\(dictCollection["questionId"] as? Int ?? 0)"
                                    self.lblBottomCountBar.text = "\("1")/\(self.questionTotalCount)"
                                    self.arrJSON = dictCollection["option"] as? [[String:Any]] ?? [[:]]
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                    
                                    for index in 0..<self.arrQuestionAnswerListing.count {
                                        let element = self.arrQuestionAnswerListing[index]
                                        let paraInfo:NSMutableDictionary = NSMutableDictionary()
                                        paraInfo.setValue( element["questionId"]as? Int ?? 0, forKey: "questionId")
                                        paraInfo.setValue( "", forKey: "answer")
                                        paraInfo.setValue( "01", forKey: "totalTime")
                                        self.arrQuestionAnswerShow.insert(paraInfo, at: index)
                                    }
                                    print("arr Question Answer Show :: \(self.arrQuestionAnswerShow)")
                                }else{
                                    self.tblView.isHidden = true
                                }
                            }
                        }
                    }
                }
            }
        }
    
    //MARK: - Call Api
    func submitQuestionAnswer() {
        if isInternetAvailable() == false {
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]

                let dictRequestSendOnServer:NSMutableDictionary = NSMutableDictionary()
                dictRequestSendOnServer.setValue( "addanswer", forKey: "action")
                dictRequestSendOnServer.setValue( String(dict["userId"]as? Int ?? 0), forKey: "userId")
                dictRequestSendOnServer.setValue( "2", forKey: "type") // static sam //
                dictRequestSendOnServer.setValue( "1", forKey: "totalTime") // static sam //
                
                let paramsArray = self.arrQuestionAnswerShow
                let paramsJSON = JSON(paramsArray)
                let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
                dictRequestSendOnServer.setValue( paramsString, forKey: "anshwerlist")

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
                            let alertController = UIAlertController(title: "Alert", message: dict["msg"]as? String ?? "", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "QuizResultVC") as? QuizResultVC
                                menuVC?.getDictJSONResponse = dict
                                menuVC?.strTimerValue = self.lblShowTime.text ?? ""
                                self.navigationController?.pushViewController(menuVC!, animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)

//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
//                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "QuizResultVC") as? QuizResultVC
//                                menuVC?.getDictJSONResponse = dict
//                                menuVC?.strTimerValue = self.lblShowTime.text ?? ""
//                                self.navigationController?.pushViewController(menuVC!, animated: true)
//                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnNextQuestionClickMe(_ sender: Any) {
        btnNext.isHidden = true
        btnNext.isUserInteractionEnabled = false
        
        selectedIndexOfTbl = -1
        self.questionIndexCounter += 1
        
        if(questionTotalCount == self.questionIndexCounter) {
            let paraInfo:NSMutableDictionary = NSMutableDictionary() // totalTime //
            paraInfo.setValue( self.selectedQuestionID, forKey: "questionId")
            paraInfo.setValue( "05", forKey: "totalTime")
            if(selectedQuestionDict["value"]as? String != "") {
                self.arrQuestionAnswerShow.removeObject(at: self.questionIndexCounter - 1)
                paraInfo.setValue(selectedQuestionDict["value"]as? String , forKey: "answer")
            }else{
            }
            self.arrQuestionAnswerShow.insert(paraInfo, at: self.questionIndexCounter - 1)

            self.stopCountDownTimer()
            self.submitQuestionAnswer()
        }else{
            //=====Make Json Request=====//
            let paraInfo:NSMutableDictionary = NSMutableDictionary() // totalTime //
            paraInfo.setValue( self.selectedQuestionID, forKey: "questionId")
            paraInfo.setValue( "05", forKey: "totalTime")
            if(selectedQuestionDict["value"]as? String != "") {
                self.arrQuestionAnswerShow.removeObject(at: self.questionIndexCounter - 1)
                paraInfo.setValue(selectedQuestionDict["value"]as? String , forKey: "answer")
            }else{
            }
            self.arrQuestionAnswerShow.insert(paraInfo, at: self.questionIndexCounter - 1)
            self.selectedQuestionDict.removeAll()
            //=====End Json Request====//
            
            if(questionTotalCount - 2 < self.questionIndexCounter) {
                btnNext.setTitle("SUBMIT", for: .normal)
            }
            
            let dictCollection:[String:Any] = self.arrQuestionAnswerListing[self.questionIndexCounter]
            self.lblQuestion.text = "\(dictCollection["question"] as? String ?? "")"
            self.selectedQuestionID = "\(dictCollection["questionId"] as? Int ?? 0)"
            self.lblBottomCountBar.text = "\(String(self.questionIndexCounter + 1))/\(questionTotalCount)"
            self.arrJSON = dictCollection["option"] as? [[String:Any]] ?? [[:]]
            self.tblView.isHidden = false
            self.tblView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJSON.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:tblAnswerCell = (tableView.dequeueReusableCell(withIdentifier: "tblAnswerCell") as? tblAnswerCell)!
        
        let dictTbl:[String:Any] = self.arrJSON[indexPath.row]
        cell.lblAnswer.text = dictTbl["value"] as? String
        
        cell.selectionCell.layer.cornerRadius = 20
        cell.selectionCell.layer.masksToBounds = true
        
        if(selectedIndexOfTbl == indexPath.row){
            cell.selectionCell.backgroundColor = .blue
        }else{
            cell.selectionCell.backgroundColor = .systemPink
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedQuestionDict = self.arrJSON[indexPath.row]
        selectedIndexOfTbl = indexPath.row
        btnNext.isHidden = false
        btnNext.isUserInteractionEnabled = true
        tblView.reloadData()
    }
}

class tblAnswerCell: UITableViewCell {
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var imgAnswerBG: UIImageView!
    @IBOutlet weak var selectionCell: UIView!
}
