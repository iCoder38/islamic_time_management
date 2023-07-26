//
//  EvaluateSuccess.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import Charts

class EvaluateSuccessMonthlyWiseVC: UIViewController, ChartViewDelegate {
    var responseDictionary:[String:Any] = [:]
    var responseArray:[[String:Any]] = [[:]]
    
    @IBOutlet weak var barChartView: BarChartView!
    weak var axisFormatDelegate: AxisValueFormatter?
    
    var months: [String]!
    var unitsSold = [Double]()
    var unitsBought = [Double]()
    var unitsSold3 = [Double]()
    var unitsBought4 = [Double]()
    var unitsSold5 = [Double]()

//    var arrJSON = [AnyObject]()
    //=====Date Picker====//
    @IBOutlet  var datePicker: UIDatePicker!
    let dateFormatter = DateFormatter()
    var DatePickerTag = 0
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!

    @IBOutlet weak var viewToDate1: UIView!
    @IBOutlet weak var viewToDate2: UIView!

    
    @IBOutlet weak var btnsubmit: UIButton!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MONTHLY REPORT"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
        
    let months_2 = ["Jan", "Feb", "Mar", "Apr", "May","June"]
    let unitsSold_2 = [20.0, 4.0, 6.0, 3.0, 12.0, 12.0]
    let unitsBought_2 = [10.0, 14.0, 60.0, 13.0, 2.0, 2.0]
    let unitsBought_3 = [14.0, 14.0, 60.0, 13.0, 2.0, 2.0]
    let unitsBought_4 = [16.0, 14.0, 60.0, 13.0, 2.0, 2.0]
    
    var show_months:NSMutableArray! = []
    var show_bar_prayer:NSMutableArray! = []
    var show_bar_quran:NSMutableArray! = []
    var show_bar_dua:NSMutableArray! = []
    var show_bar_other:NSMutableArray! = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        barChartView.isHidden = true
        btnsubmit.isHidden = false
        
        
        viewToDate1.layer.cornerRadius = 10
        viewToDate1.layer.borderWidth = 1
        viewToDate1.layer.borderColor = UIColor.gray.cgColor
        
        viewToDate2.layer.cornerRadius = 10
        viewToDate2.layer.borderWidth = 1
        viewToDate2.layer.borderColor = UIColor.gray.cgColor

        //
//        let date = Date()
//        let formate = date.getFormattedDate(format: "yyyy-MM-dd")
        
        // EvaluationHistoryData(start_date: formate, end_date: formate)
         // EvaluationHistoryData(start_date: "2023-04-01", end_date: formate)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sideBarMenuClick()
        
    }
    
    //MARK: - IBActions
    @IBAction func btnFromDateClickMe(_ sender: UIButton)
    {
        DatePickerTag = 1
        self.displayAlertControllerDatePicker(title: "Alert", message: "Choose Start Date")
    }
    @IBAction func btnToDateClickMe(_ sender: UIButton)
    {
        DatePickerTag = 2
        self.displayAlertControllerDatePicker(title: "Alert", message: "Choose End Date")
    }
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        if(txtFromDate.text == "" || txtToDate.text == ""){
            let alert = UIAlertController(title: "Alert", message: "Select start date and end date first!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            barChartView.isHidden = false
            btnsubmit.isHidden = true
            
            
            let date = Date()
            let formate = date.getFormattedDate(format: "yyyy-MM-dd")
            
            var myDate = Date()
            myDate.changeDays(by: -28)
            
            
            let formate1 = myDate.getFormattedDate(format: "yyyy-MM-dd")
            
             self.EvaluationHistoryData(start_date: formate1, end_date: formate)
        }
    }
    


    @objc func sideBarMenuClick() {
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    

    
    func EvaluationHistoryData(start_date:String,end_date:String) {
        
        self.show_months.removeAllObjects()
        self.show_bar_prayer.removeAllObjects()
        self.show_bar_quran.removeAllObjects()
        self.show_bar_dua.removeAllObjects()
        self.show_bar_other.removeAllObjects()
        
        
        
        
        if isInternetAvailable() == false {
            
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!"
            
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
               
                
                
                let values = [
                    "action":"evalutionhistory",
                    "userId":String(dict["userId"]as? Int ?? 0),
                    "pageNo":"",
                    
                    "startDate":String(self.txtFromDate.text!),//formate1,
                    "endDate":String(self.txtToDate.text!),
                    
//                    "startDate":start_date,//formate1,
//                    "endDate":end_date,//formate
                     // "startDate":"2023-04-01",
                     // "endDate":"2023-04-11"
                ] as [String : Any]as [String : Any]
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
                                self.responseArray = dict["data"] as? [[String : Any]] ?? [[:]]
                                print(self.responseArray)
                                if(self.responseArray.count != 0) {
                                    //========000========//
                                    /*var arrJSON = [AnyObject]()
                                    arrJSON = self.responseArray[0]["JsonData"] as! [AnyObject]
                                    var totalEvalulate = Double()
                                    var totalEvalulate_1 = Double()
                                    var totalEvalulate_2 = Double()
                                    var totalEvalulate_3 = Double()
                                    var totalEvalulate_4 = Double()
                                    let localDict = arrJSON[0] as? [String:Any] ?? [:]
                                    let localDict1 = arrJSON[1] as? [String:Any] ?? [:]
                                    let localDict2 = arrJSON[2] as? [String:Any] ?? [:]
                                    let localDict3 = arrJSON[3] as? [String:Any] ?? [:]
                                    totalEvalulate = localDict["totalEvalulate"] as? Double ?? 0.0
                                    totalEvalulate_1 = localDict1["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_2 = localDict2["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_3 = localDict3["totalEvalulate"]as? Double ?? 0.0
                                    let totalValuee = self.responseArray[0]["totalValue"]
                                    totalEvalulate_4 = (totalValuee as? NSString)?.doubleValue ?? 0.0
                                    //==========//
                                    //========111========//
                                    var arrJSON1 = [AnyObject]()
                                    arrJSON1 = self.responseArray[1]["JsonData"] as! [AnyObject]
                                    var totalEvalulate99 = Double()
                                    var totalEvalulate_11 = Double()
                                    var totalEvalulate_22 = Double()
                                    var totalEvalulate_33 = Double()
                                    var totalEvalulate_44 = Double()
                                    
                                    let localDict9 = arrJSON1[0] as? [String:Any] ?? [:]
                                    let localDict11 = arrJSON1[1] as? [String:Any] ?? [:]
                                    let localDict22 = arrJSON1[2] as? [String:Any] ?? [:]
                                    let localDict33 = arrJSON1[3] as? [String:Any] ?? [:]
                                    
                                    totalEvalulate99 = localDict9["totalEvalulate"] as? Double ?? 0.0
                                    totalEvalulate_11 = localDict11["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_22 = localDict22["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_33 = localDict33["totalEvalulate"]as? Double ?? 0.0
                                    
                                    let totalValuee8 = self.responseArray[1]["totalValue"]
                                    totalEvalulate_44 = (totalValuee8 as? NSString)?.doubleValue ?? 0.0
                                    //==========//

                                    //========222========//
                                    var arrJSON2 = [AnyObject]()
                                    arrJSON2 = self.responseArray[2]["JsonData"] as! [AnyObject]
                                    var totalEvalulate99_9 = Double()
                                    var totalEvalulate_11_1 = Double()
                                    var totalEvalulate_22_2 = Double()
                                    var totalEvalulate_33_3 = Double()
                                    var totalEvalulate_44_4 = Double()
                                    
                                    let localDict9_9 = arrJSON2[0] as? [String:Any] ?? [:]
                                    let localDict11_1 = arrJSON2[1] as? [String:Any] ?? [:]
                                    let localDict22_2 = arrJSON2[2] as? [String:Any] ?? [:]
                                    let localDict33_3 = arrJSON2[3] as? [String:Any] ?? [:]
                                    
                                    totalEvalulate99_9 = localDict9_9["totalEvalulate"] as? Double ?? 0.0
                                    totalEvalulate_11_1 = localDict11_1["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_22_2 = localDict22_2["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_33_3 = localDict33_3["totalEvalulate"]as? Double ?? 0.0
                                    
                                    let totalValuee88 = self.responseArray[2]["totalValue"]
                                    totalEvalulate_44_4 = (totalValuee88 as? NSString)?.doubleValue ?? 0.0
                                    //==========//
                                    
                                    //========333========//
                                    var arrJSON3 = [AnyObject]()
                                    
                                    print(self.responseArray as Any)
                                    
                                    print(self.responseArray[0] as Any)
                                    print(self.responseArray[1] as Any)
                                    print(self.responseArray[2] as Any)
                                    print(self.responseArray[3] as Any)
                                    print(self.responseArray[4] as Any)
                                    
                                    print(self.responseArray[0]["JsonData"] as Any)
                                    print(self.responseArray[1]["JsonData"] as Any)
                                    print(self.responseArray[2]["JsonData"] as Any)
                                    print(self.responseArray[3]["JsonData"] as Any)
                                    print(self.responseArray[4]["JsonData"] as Any)
                                    
                                     // print(self.responseArray[5] as Any)
                                    
                                    arrJSON3 = self.responseArray[3]["JsonData"] as! [AnyObject]
                                    var totalEvalulate99_9_9 = Double()
                                    var totalEvalulate_11_1_1 = Double()
                                    var totalEvalulate_22_2_2 = Double()
                                    var totalEvalulate_33_3_3 = Double()
                                    var totalEvalulate_44_4_4 = Double()
                                    
                                    let localDict9_9_9 = arrJSON3[0] as? [String:Any] ?? [:]
                                    let localDict11_1_1 = arrJSON3[1] as? [String:Any] ?? [:]
                                    let localDict22_2_2 = arrJSON3[2] as? [String:Any] ?? [:]
                                    let localDict33_3_3 = arrJSON3[3] as? [String:Any] ?? [:]
                                    
                                    totalEvalulate99_9_9 = localDict9_9_9["totalEvalulate"] as? Double ?? 0.0
                                    totalEvalulate_11_1_1 = localDict11_1_1["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_22_2_2 = localDict22_2_2["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate_33_3_3 = localDict33_3_3["totalEvalulate"]as? Double ?? 0.0
                                    
                                    let totalValuee88_8 = self.responseArray[3]["totalValue"]
                                    totalEvalulate_44_4_4 = (totalValuee88_8 as? NSString)?.doubleValue ?? 0.0
                                    //==========//

                                    //========444========//
                                    var arrJSON4 = [AnyObject]()
                                    arrJSON4 = self.responseArray[4]["JsonData"] as! [AnyObject]
                                    var totalEvalulate90 = Double()
                                    var totalEvalulate10 = Double()
                                    var totalEvalulate20 = Double()
                                    var totalEvalulate30 = Double()
                                    var totalEvalulate40 = Double()
                                    
                                    let localDict90 = arrJSON4[0] as? [String:Any] ?? [:]
                                    let localDict10 = arrJSON4[1] as? [String:Any] ?? [:]
                                    let localDict20 = arrJSON4[2] as? [String:Any] ?? [:]
                                    let localDict30 = arrJSON4[3] as? [String:Any] ?? [:]
                                    
                                    
                                    totalEvalulate90 = localDict90["totalEvalulate"] as? Double ?? 0.0
                                    totalEvalulate10 = localDict10["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate20 = localDict20["totalEvalulate"]as? Double ?? 0.0
                                    totalEvalulate30 = localDict30["totalEvalulate"]as? Double ?? 0.0
                                    
                                    let totalValuee88_8_8 = self.responseArray[4]["totalValue"]
                                    totalEvalulate40 = (totalValuee88_8_8 as? NSString)?.doubleValue ?? 0.0
                                    //==========//

                                    //========444========//
                                     if(self.txtToDate.text ?? "" == self.txtFromDate.text ?? "") {
                                        var arrJSON5 = [AnyObject]()
                                        arrJSON5 = self.responseArray[1]["JsonData"] as! [AnyObject]
                                        
                                        var totalEvalulate910 = Double()
                                        var totalEvalulate110 = Double()
                                        var totalEvalulate220 = Double()
                                        var totalEvalulate330 = Double()
                                        var totalEvalulate440 = Double()
                                        
                                        let localDict910 = arrJSON5[0] as? [String:Any] ?? [:]
                                        let localDict110 = arrJSON5[1] as? [String:Any] ?? [:]
                                        let localDict220 = arrJSON5[2] as? [String:Any] ?? [:]
                                        let localDict330 = arrJSON5[3] as? [String:Any] ?? [:]
                                        
                                        totalEvalulate910 = localDict910["totalEvalulate"] as? Double ?? 0.0
                                        totalEvalulate110 = localDict110["totalEvalulate"]as? Double ?? 0.0
                                        totalEvalulate220 = localDict220["totalEvalulate"]as? Double ?? 0.0
                                        totalEvalulate330 = localDict330["totalEvalulate"]as? Double ?? 0.0
                                        
                                        let totalValuee81 = self.responseArray[4]["totalValue"]
                                        totalEvalulate440 = (totalValuee81 as? NSString)?.doubleValue ?? 0.0
                                        //==========//
                                         self.months = ["Mon","Tue"]
                                        self.unitsSold = [totalEvalulate]
                                        self.unitsBought = [totalEvalulate_1]
                                        self.unitsSold3 = [totalEvalulate_2]
                                        self.unitsBought4 = [totalEvalulate_3]
                                        self.unitsSold5 = [totalEvalulate_4]
                                         
                                         print(self.unitsSold)
                                         print(self.unitsBought)
                                         print(self.unitsSold3)
                                         print(self.unitsBought4)
                                    }
                                    else {
                                        var arrJSON5 = [AnyObject]()
                                        arrJSON5 = self.responseArray[5]["JsonData"] as! [AnyObject]
                                        var totalEvalulate910 = Double()
                                        var totalEvalulate110 = Double()
                                        var totalEvalulate220 = Double()
                                        var totalEvalulate330 = Double()
                                        var totalEvalulate440 = Double()
                                        
                                        let localDict910 = arrJSON5[0] as? [String:Any] ?? [:]
                                        let localDict110 = arrJSON5[1] as? [String:Any] ?? [:]
                                        let localDict220 = arrJSON5[2] as? [String:Any] ?? [:]
                                        let localDict330 = arrJSON5[3] as? [String:Any] ?? [:]
                                        
                                        totalEvalulate910 = localDict910["totalEvalulate"] as? Double ?? 0.0
                                        totalEvalulate110 = localDict110["totalEvalulate"]as? Double ?? 0.0
                                        totalEvalulate220 = localDict220["totalEvalulate"]as? Double ?? 0.0
                                        totalEvalulate330 = localDict330["totalEvalulate"]as? Double ?? 0.0
                                        
                                        let totalValuee81 = self.responseArray[5]["totalValue"]
                                        totalEvalulate440 = (totalValuee81 as? NSString)?.doubleValue ?? 0.0
                                        //==========//

                                        self.months = ["mon","tuw","wed","wew","as"]
                                        self.unitsSold = [totalEvalulate,totalEvalulate99,totalEvalulate99_9,totalEvalulate99_9_9,totalEvalulate90,totalEvalulate910]
                                        self.unitsBought = [totalEvalulate_1,totalEvalulate_11,totalEvalulate_11_1,totalEvalulate_11_1_1,totalEvalulate10,totalEvalulate110]
                                        self.unitsSold3 = [totalEvalulate_2,totalEvalulate_22,totalEvalulate_22_2,totalEvalulate_22_2_2,totalEvalulate20,totalEvalulate220]
                                        self.unitsBought4 = [totalEvalulate_3,totalEvalulate_33,totalEvalulate_33_3,totalEvalulate_33_3_3,totalEvalulate30,totalEvalulate330]
                                        self.unitsSold5 = [totalEvalulate_4,totalEvalulate_44,totalEvalulate_44_4,totalEvalulate_44_4_4,totalEvalulate40,totalEvalulate440]
                                    }
                                    
                                    
                                    
                                    
                                    // self.initializeChart()
                                    
                                    */
                                    self.barChartView.isHidden = false
                                    self.chart_ui_design()
                                    
                                } else {
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    
    
    
    @objc func chart_ui_design() {
        /*
         let show_months = []
         let show_bar_prayer = []
         let show_bar_quran = []
         let show_bar_dua = []
         let show_bar_other = []
         */
        
        // print(self.responseArray as Any)
        // print(self.responseArray.count as Any)
        
        var arr_save_json_data:NSMutableArray! = []
        
        for indexx in 0..<self.responseArray.count {
            let item = self.responseArray[indexx] as? [String:Any]
            print(item as Any)
            
            
            self.show_months.add("\(item!["dayName"]!)")
            
            //
            // print(item!["JsonData"] as Any)
            var ar : NSArray!
            ar = (item!["JsonData"] as! Array<Any>) as NSArray
            print(ar as Any)
            
            for index_2 in 0..<ar.count {
                let item_2 = ar[index_2] as? [String:Any]
                print(item_2 as Any)
                
                if "\(item_2!["id"]!)" == "6" {
                    // self.show_bar_prayer.adding("\(item_2!["totalEvalulate"]!)")
                    self.show_bar_prayer.add("\(item_2!["totalEvalulate"]!)")
                    
                } else if "\(item_2!["id"]!)" == "10" {
                    // self.show_bar_quran.adding("\(item_2!["totalEvalulate"]!)")
                    self.show_bar_quran.add("\(item_2!["totalEvalulate"]!)")
                    
                } else if "\(item_2!["id"]!)" == "7" {
                    // self.show_bar_dua.adding("\(item_2!["totalEvalulate"]!)")
                    self.show_bar_dua.add("\(item_2!["totalEvalulate"]!)")
                    
                } else {
                    // self.show_bar_other.adding("\(item_2!["totalEvalulate"]!)")
                    self.show_bar_other.add("\(item_2!["totalEvalulate"]!)")
                    
                }

            }

            // arr_save_json_data.add(item!["JsonData"][""] as Any)
        }
        
        barChartView.delegate = self
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription.text = "sales vs bought "


        let array_c_prayer: [String] = self.show_months.copy() as! [String]
        print(array_c_prayer)
        
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 2.0
        legend.xOffset = 10.0
        legend.yEntrySpace = 0.0


        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:array_c_prayer)
        xaxis.granularity = 1


        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        barChartView.rightAxis.enabled = false
        
        //
        setChart2()
    }
    
    func setChart2() {
        btnsubmit.isHidden = false
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        var dataEntries3: [BarChartDataEntry] = []

        // print(self.show_bar_prayer as Any)
        // print(self.show_bar_quran as Any)
        // print(self.show_bar_dua as Any)
        // print(self.show_bar_other as Any)
        print(self.show_months as Any)
        
        let array_c_prayer: [String] = self.show_bar_prayer.copy() as! [String]
        print(array_c_prayer)
        
        let array_c_quran: [String] = self.show_bar_quran.copy() as! [String]
        print(array_c_quran)
        
        let array_c_dua: [String] = self.show_bar_dua.copy() as! [String]
        print(array_c_dua)
        
        let array_c_other: [String] = self.show_bar_other.copy() as! [String]
        print(array_c_other)
        
        let arrOfDoubles_prayers = array_c_prayer.map { (value) -> Double in
            print(value)
            // arr_t = value
            return Double(value)!
        }
        
        // quran
        let arrOfDoubles_quran = array_c_quran.map { (value) -> Double in
            print(value)
            // arr_t = value
            return Double(value)!
        }
        
        // dua
        let arrOfDoubles_dua = array_c_dua.map { (value) -> Double in
            print(value)
            // arr_t = value
            return Double(value)!
        }
        
        // other
        let arrOfDoubles_other = array_c_other.map { (value) -> Double in
            print(value)
            // arr_t = value
            return Double(value)!
        }
        
        print(arrOfDoubles_prayers)
        print(arrOfDoubles_quran)
        print(arrOfDoubles_dua)
        print(arrOfDoubles_other)
        
        for i in 0..<self.show_bar_prayer.count {

             let dataEntry = BarChartDataEntry(x: Double(i) , y: arrOfDoubles_prayers[i],data: "ok ok ")
             dataEntries.append(dataEntry)

            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: arrOfDoubles_quran[i])
            dataEntries1.append(dataEntry1)

            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: arrOfDoubles_dua[i])
            dataEntries2.append(dataEntry2)

            let dataEntry3 = BarChartDataEntry(x: Double(i) , y: arrOfDoubles_other[i])
            dataEntries3.append(dataEntry3)

                //stack barchart
//                let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")

        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Prayer")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Quran")
        let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "Dua")
        let chartDataSet3 = BarChartDataSet(entries: dataEntries3, label: "Good deeds")
        // let chartDataSet3 = BarChartDataSet(entries: dataEntries3, label: "Fri")

        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2,chartDataSet3]
        
        chartDataSet.colors = [UIColor.systemPurple]
        chartDataSet1.colors = [UIColor.blue]
        chartDataSet2.colors = [UIColor.yellow]
        chartDataSet3.colors = [UIColor.black]

            //chartDataSet.colors = ChartColorTemplates.colorful()
            //let chartData = BarChartData(dataSet: chartDataSet)

        let chartData = BarChartData(dataSets: dataSets)


        let groupSpace = 0.00
        let barSpace = 0.05
        let barWidth = 0.2
        
    //        let groupSpace = 0.3
    //        let barSpace = 1.0
    //        let barWidth = 0.9
        
        
//        let n = Double(self.show_months.count)
//        let groupSpace = 0.0031 * n
//        let barSpace = 0.002 * n
//        let barWidth = (1 - (n * barSpace) - groupSpace) / n
        
        
        // print(self.show_months as Any)
        let groupCount = self.show_months.count
        let startYear = 0


        chartData.barWidth = barWidth
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            print("Groupspace: \(gg)")
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
            //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()

        barChartView.chartDescription.text = ""
        
        barChartView.data = chartData

//        barChartView.description?.text = ""
        
//        barChartView.description.is

            //background color
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

            //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)


    }
    
    func initializeChart() {
        print(self.months as Any)
        
        barChartView.delegate = self
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        barChartView.rightAxis.enabled = false
        setChart()
    }
    
    func setChart() {
        /*var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        var dataEntries3: [BarChartDataEntry] = []
        var dataEntries4: [BarChartDataEntry] = []
        // var dataEntries5: [BarChartDataEntry] = []
        
        print(self.months as Any)
        
        
         
        print(self.unitsSold)
        for i in 0..<self.months.count {
            
            print(self.unitsSold)
            // print(self.unitsSold[i] as Any)
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: 10.0,data: "asas")
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: 15.0,data: "asas")
            dataEntries1.append(dataEntry1)
            
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: 15.0,data: "asas")
            dataEntries2.append(dataEntry2)
            
            let dataEntry3 = BarChartDataEntry(x: Double(i) , y: 15.0,data: "asas")
            dataEntries3.append(dataEntry3)
            
            /*let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i],data: "121212")
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.unitsBought[i],data: "121212")
            dataEntries1.append(dataEntry1)
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: self.unitsSold3[i],data: "121212")
            dataEntries2.append(dataEntry2)
            let dataEntry3 = BarChartDataEntry(x: Double(i) , y: self.unitsBought4[i],data: "121212")
            dataEntries3.append(dataEntry3)
            let dataEntry4 = BarChartDataEntry(x: Double(i) , y: self.unitsSold5[i],data: "121212")
            dataEntries4.append(dataEntry4)*/
            //
            // let dataEntry5 = BarChartDataEntry(x: Double(i) , y: self.unitsSold5[i])
            // dataEntries5.append(dataEntry5)
        }
        
        print(dataEntries)
        print(dataEntries1)
        print(dataEntries2)
        print(dataEntries3)
        print(dataEntries4)
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "a")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "b")
        let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "c")
        let chartDataSet3 = BarChartDataSet(entries: dataEntries3, label: "Treating Others")
        let chartDataSet4 = BarChartDataSet(entries: dataEntries4, label: "Total Bricks")
        // let chartDataSet5 = BarChartDataSet(entries: dataEntries5, label: "Total Bricks")
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2,chartDataSet3,chartDataSet4]
        
        chartDataSet.colors = [UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1)]
        chartDataSet1.colors = [UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)]
        chartDataSet2.colors = [UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)]
        chartDataSet3.colors = [UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        chartDataSet4.colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 1.0
        let barSpace = 0.05
        let barWidth = 0.3

        let groupCount = self.months.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
         barChartView.xAxis.axisMinimum = Double(startYear)
         let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
         barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
         chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
         barChartView.notifyDataSetChanged()
         barChartView.data = chartData*/
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May"]
            let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
            let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0]
        
        
    }
}



extension EvaluateSuccessMonthlyWiseVC {
    func displayAlertControllerDatePicker(title:String, message:String) {
        if(DatePickerTag == 1 || DatePickerTag == 2) {
            datePicker  = UIDatePicker(frame: CGRect(x: 10, y: 65, width: self.view.frame.width - 10, height: 150))
            datePicker.addTarget(self, action: #selector(EvaluateSuccessMonthlyWiseVC.dueDateChanged(_:)), for: UIControl.Event.valueChanged)
            datePicker.datePickerMode = UIDatePicker.Mode.date

            let editRadiusAlert = UIAlertController(title:title , message: message, preferredStyle: UIAlertController.Style.actionSheet)
            let height:NSLayoutConstraint = NSLayoutConstraint(item: editRadiusAlert.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 330)
            editRadiusAlert.view.addConstraint(height);
            editRadiusAlert.view.addSubview(datePicker)

            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelClickEvent))
            self.present(editRadiusAlert, animated: true)

            datePicker.datePickerMode = UIDatePicker.Mode.date
            datePicker.maximumDate = Date()
            
            if(DatePickerTag == 1) {
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let date = Date()
                let strDate = dateFormatter.string(from: date)
                self.txtFromDate.text = strDate
            }
            if(DatePickerTag == 2) {
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let date = Date()
                let strDate = dateFormatter.string(from: date)
                self.txtToDate.text = strDate
            }
        }
    }

    
    @IBAction func dueDateChanged(_ sender: Any) {
        if (DatePickerTag == 1) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let strDate = dateFormatter.string(from: (sender as AnyObject).date)
            print(strDate as Any)
            self.txtFromDate.text = strDate
        }
        if (DatePickerTag == 2) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let strDate = dateFormatter.string(from: (sender as AnyObject).date)
            print(strDate as Any)
            self.txtToDate.text = strDate
        }
    }
    func cancelClickEvent(action: UIAlertAction) {
    }
}
extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: Date())
    }
}


