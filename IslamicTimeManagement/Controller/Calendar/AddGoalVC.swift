//
//  AppointmentViewController.swift
//  AutoMedic
//
//  Created by Shyam on 24/11/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import MBProgressHUD

class AddGoalVC: UIViewController , UITextViewDelegate , UITextFieldDelegate {
    var responseDictionary:[String:Any] = [:]
    var responseArray:[[String:Any]] = [[:]]

    var arr:NSArray?
    var arrDates = NSArray()

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
                lblNavigationTitle.text = "SET YOUR GOAL"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
    // ***************************************************************** // nav
    
    @IBOutlet  var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()
    var DatePickerTag = 0

//    var pickerViewTag = 0
//    @IBOutlet var pickerView: UIPickerView!

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!

    @IBOutlet weak var txtGoalName: UITextField!
    
    var strTag = String()
    var strDate = String()
    var strTime = String()
    let currentDateTime = Date()
//    let arrTime = ["08:00 am",
//                   "08:30 am",
//                   "09:00 am",
//                   "09:30 am",
//                   "10:00 am",
//                   "10:30 am",
//                   "11:00 am",
//                   "11:30 am",
//                   "12:00 pm",
//                   "12:30 pm",
//                   "01:00 pm",
//                   "01:30 pm",
//                   "02:00 pm",
//                   "02:30 pm",
//                   "03:00 pm",
//                   "03:30 pm",
//                   "04:00 pm",
//                   "04:30 pm",
//                   "05:00 pm",
//                   "05:30 pm",
//                   "06:00 pm",
//                   "06:30 pm",
//                   "07:00 pm",
//                   "07:30 pm",
//                   "08:00 pm",
//                   "08:30 pm",
//                   "09:00 pm",
//                   "09:30 pm",
//                   "10:00 pm",
//                   "11:00 pm",
//                   "11:30 pm",
//    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        placeholderLabel.text = "enter your description"
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtView.text.isEmpty
        txtView.selectedTextRange = txtView.textRange(from: txtView.beginningOfDocument, to: txtView.beginningOfDocument)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtTime.text = "08:00 am"
        self.getSelectedDate(selectDate: currentDateTime)
    }

    @objc func backClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SetYourGoalsListId")
        self.navigationController?.pushViewController(push, animated: true)
    }


    //MARK: - IBActions
    @IBAction func btnTimeAction(_ sender: UIButton) {
        self.displayAlertControllerDatePicker(title: "Alert!", message: "Choose Time")
    }
    @IBAction func tapContinueBtn(_ sender : UIButton) {
        if(txtGoalName.text == "") {
            self.alertviewCommonFunc(message1: "Please enter your goal name")
            return
        }
        if(txtView.text == "") {
            self.alertviewCommonFunc(message1: "Please enter description first")
            return
        }
        else {
            self.getGoalResponseData(dateTime : "\(strTime) \(txtTime.text ?? "")", description : txtView.text ?? "")
        }
    }
    
    func getGoalResponseData(dateTime: String, description: String ){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
                    
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let values = [
                    
                    "action"    : "addgoal",
                    "name"      : txtGoalName.text ?? "",
                    "dateTime"  : dateTime,
                    "description": description,
                    "userId"    : String(dict["userId"] as? Int ?? 0)
                    
                ]
                    
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
                                print("dict :: \(dict)")
                                let alertController = UIAlertController(title: "Alert", message: dict["msg"]as? String ?? "", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SetYourGoalsListId")
                                    self.navigationController?.pushViewController(push, animated: true)
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                        }
                    }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        if txtView == textView{
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if txtView == textView{
            txtView.text = ""
            txtView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return textView.text.count + (text.count - range.length) <= 140
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder();
        return true;
    }
}

extension AddGoalVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        internal func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.getSelectedDate(selectDate: date)
    }
    
    func getSelectedDate(selectDate: Date = Date()) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        lblSelectDate.text = dateFormatter.string(from: selectDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        strTime = dateFormatter.string(from: selectDate)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.view.layoutIfNeeded()
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            return false
        } else {
            return true
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date .compare(Date()) == .orderedAscending {
            return UIColor.lightGray
        } else {
            return UIColor.black
        }
    }
    
    
    //MARK: - IBActions
    func displayAlertControllerDatePicker(title:String, message:String) {
            datePicker  = UIDatePicker(frame: CGRect(x:-10 , y: 65, width: self.view.frame.size.width + 5, height: 150))
            datePicker.addTarget(self, action: #selector(AddGoalVC.dueDateChanged(_:)), for: UIControl.Event.valueChanged)
            datePicker.datePickerMode = UIDatePicker.Mode.time
            datePicker.locale = Locale(identifier: "en_GB")
            
            let editRadiusAlert = UIAlertController(title:title , message: message, preferredStyle: UIAlertController.Style.actionSheet)
            let height:NSLayoutConstraint = NSLayoutConstraint(item: editRadiusAlert.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 330)
            editRadiusAlert.view.addConstraint(height);
            editRadiusAlert.view.addSubview(datePicker)
            
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelClickEvent))
            self.present(editRadiusAlert, animated: true)
    }
    
    func cancelClickEvent(action: UIAlertAction) {
    }
    
    
    @IBAction func dueDateChanged(_ sender: Any) {
            let timeFormatterHour = DateFormatter()
            let timeFormatterMinutes = DateFormatter()
            timeFormatterHour.dateFormat = "hh"
            timeFormatterMinutes.dateFormat = "mm"
            let InputTimeHourString = timeFormatterHour.string(from: (sender as AnyObject).date)
            let InputTimeMinutesString = timeFormatterMinutes.string(from: (sender as AnyObject).date)
            let InputTimeHourInt = Int(InputTimeHourString)!
            let InputTimeMinutesInt = Int(InputTimeMinutesString)!
            _ = (InputTimeHourInt * 60) + InputTimeMinutesInt // selected time //
            
            let TodayTime = NSDate()
            let TodayTimetimeFormatterHour = DateFormatter()
            let TodayTimetimeFormatterMinutes = DateFormatter()
            TodayTimetimeFormatterHour.dateFormat = "hh"
            TodayTimetimeFormatterMinutes.dateFormat = "mm"
            let TodayTimeInputTimeHourString = TodayTimetimeFormatterHour.string(from: TodayTime as Date)
            let TodayTimeInputTimeMinutesString = TodayTimetimeFormatterMinutes.string(from: TodayTime as Date)
            let TodayTimeInputTimeHourInt = Int(TodayTimeInputTimeHourString)!
            let TodayTimeInputTimeMinutesInt = Int(TodayTimeInputTimeMinutesString)!
            _ = (TodayTimeInputTimeHourInt * 60) + TodayTimeInputTimeMinutesInt // current time //
            
            let shownDateFormatter = DateFormatter()
            shownDateFormatter.dateFormat = "hh:mm a"
        self.txtTime.text = shownDateFormatter.string(from: (sender as AnyObject).date) . lowercased()
    }
}



///** --------------------------------------------------------
// *        Picker View defined by Targets.
// *  --------------------------------------------------------
// */
//
//extension AddGoalVC: UIPickerViewDataSource, UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return arrTime.count
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        self.txtTime.text = arrTime[row]
//        return arrTime[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            self.txtTime.text = arrTime[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 50
//    }
//}
//
//extension AddGoalVC {
//    func displayAlertControllerPickerView(title:String, message:String) {
//        pickerView  = UIPickerView(frame: CGRect(x:-10 , y: 65, width: self.view.frame.size.width + 5, height: 150))
//        pickerView.delegate = (self as UIPickerViewDelegate)
//        let editRadiusAlert = UIAlertController(title:title , message: message, preferredStyle: UIAlertController.Style.actionSheet)
//        let height:NSLayoutConstraint = NSLayoutConstraint(item: editRadiusAlert.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 2, constant: 330)
//        editRadiusAlert.view.addConstraint(height);
//        editRadiusAlert.view.addSubview(pickerView)
//
//        editRadiusAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: dooneClickEvent))
//        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelClickEven))
//        self.present(editRadiusAlert, animated: true)
//    }
//
//    func dooneClickEvent(action: UIAlertAction) {
//    }
//
//    func cancelClickEven(action: UIAlertAction) {
//    }
//}
