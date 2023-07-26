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


class EvaluateSuccess: UIViewController, ChartViewDelegate {
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
    
    
    var arrJSON = [AnyObject]()
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "EVALUATE"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .white
        }
    }
    
    @IBOutlet weak var lblTotal:UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let getCount = UserDefaults.standard.string(forKey: "totalValue")
        
        self.lblTotal.text = getCount
        self.sideBarMenuClick()
        EvaluationHistoryData()
        
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
    
    func EvaluationHistoryData(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!"
            
            let dict : [String : Any] = UserDefaults.standard.dictionary(forKey: "kAPI_LOGIN_DATA") ?? [:]
            if let apiString = URL(string:BaseUrl) {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let date = Date()
                let formate = date.getFormattedDate(format: "yyyy-MM-dd")
                var myDate = Date()
                myDate.changeDays(by: -7)
//                let formate1 = myDate.getFormattedDate(format: "yyyy-MM-dd")
                let values = ["action":"evalutionhistory",
                              "userId":String(dict["userId"]as? Int ?? 0),
                              "pageNo":"",
                              "startDate":formate,
                              "endDate":formate]
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
                                
                                if(self.responseArray.count != 0) {
                                    
                                    self.arrJSON = self.responseArray[0]["JsonData"] as! [AnyObject]
                                    
                                    
                                    // print(self.responseArray as Any)
                                    // print(self.arrJSON as Any)
                                    
                                    
                                    if (self.arrJSON.isEmpty) {
                                        
                                    } else {
                                        
                                        /*
                                         cateroryName = Prayers;
                                         id = 6;
                                         totalEvalulate = 0;
                                     }, {
                                         cateroryName = Quran;
                                         id = 10;
                                         totalEvalulate = 40;
                                     }, {
                                         cateroryName = Dua;
                                         id = 7;
                                         totalEvalulate = 2;
                                     }, {
                                         cateroryName = "Good deeds ";
                                         id = 8;
                                         totalEvalulate = 15;
                                         */
                                        
                                        /*var totalEvalulate = Double()
                                        var totalEvalulate_1 = Double()
                                        var totalEvalulate_2 = Double()
                                        var totalEvalulate_3 = Double()
                                        var totalEvalulate_4 = Double()*/
                                        
                                        
                                        var totalEvalulate = String()
                                        var totalEvalulate_1 = String()
                                        var totalEvalulate_2 = String()
                                        var totalEvalulate_3 = String()
                                        var totalEvalulate_4 = String()
                                        
                                        var get_total_value = String()
                                        
                                        
                                        let localDict = self.arrJSON[0] as? [String:Any] ?? [:]
                                        let localDict1 = self.arrJSON[1] as? [String:Any] ?? [:]
                                        let localDict2 = self.arrJSON[2] as? [String:Any] ?? [:]
                                        let localDict3 = self.arrJSON[3] as? [String:Any] ?? [:]
                                        
                                        let localDict_total = self.responseArray
                                        
                                        // let totalValue = self.responseArray[0]["totalValue"] as? [String:Any] ?? [:]
                                        
                                        /*print(localDict)
                                        print(localDict1)
                                        print(localDict2)
                                        print(localDict3)
                                        print("\(localDict_total[0]["totalValue"]!)")*/
                                        
                                        
                                        totalEvalulate = "\(localDict["totalEvalulate"]!)"
                                        totalEvalulate_1 = "\(localDict1["totalEvalulate"]!)"
                                        totalEvalulate_2 = "\(localDict2["totalEvalulate"]!)"
                                        totalEvalulate_3 = "\(localDict3["totalEvalulate"]!)"
                                        get_total_value = "\(localDict_total[0]["totalValue"]!)"
                                        
                                        // total_value = "\(totalValue["totalEvalulate"]!)"
                                        
                                        
                                        /*print(totalEvalulate)
                                        print(totalEvalulate_1)
                                        print(totalEvalulate_2)
                                        print(totalEvalulate_3)
                                        
                                        print(get_total_value)
                                        
                                        
                                        print(type(of: totalEvalulate))
                                        print(type(of: totalEvalulate_1))
                                        print(type(of: totalEvalulate_2))
                                        print(type(of: totalEvalulate_3))
                                        
                                        print(type(of: get_total_value))*/
                                        
                                        
                                        // first prayer
                                        let convert_to_double_prayer = totalEvalulate.toDouble()
                                        // print(convert_to_double_prayer)
                                        
                                        // second
                                        let convert_to_double_quran = totalEvalulate_1.toDouble()
                                        // print(convert_to_double_quran)
                                        
                                        // third
                                        let convert_to_double_dua = totalEvalulate_2.toDouble()
                                        // print(convert_to_double_dua)
                                        
                                        // fourth
                                        let convert_to_double_other = totalEvalulate_3.toDouble()
                                        // print(convert_to_double_other)
                                        
                                        // total
                                         var convert_to_double_total = get_total_value.toDouble()
                                         // print(convert_to_double_total)
                                        
                                        // print(type(of: convert_to_double_prayer))
                                        // print(type(of: convert_to_double_quran))
                                        // print(type(of: convert_to_double_dua))
                                        // print(type(of: convert_to_double_other))
                                        // print(type(of: convert_to_double_total))
                                        
                                        // Cannot convert value of type 'Double?' to expected element type 'Array<Double>.ArrayLiteralElement' (aka 'Double')
                                        
                                        
                                         /*let totalValuee = self.responseArray[0]["totalValue"]
                                         totalEvalulate_4 = (totalValuee as? NSString)?.doubleValue ?? 0.0
                                         print(totalEvalulate_4)*/
                                        
                                        self.months = [""]
                                        self.unitsSold.append(convert_to_double_prayer!)
                                        self.unitsBought.append(convert_to_double_quran!)
                                        self.unitsSold3.append(convert_to_double_dua!)
                                        self.unitsBought4.append(convert_to_double_other!)
                                        self.unitsSold5.append(convert_to_double_total!)
                                        
                                        /*print(self.months)
                                        print(self.unitsSold)
                                        print(self.unitsBought)
                                        print(self.unitsSold3)
                                        print(self.unitsBought4)
                                        print(self.unitsSold5)*/
                                        
                                        self.initializeChart()
                                        
                                        
                                        
                                        // = [convert_to_double_prayer]
                                        
                                        /*// put values in chart data
                                        self.months = [""]
                                        self.unitsSold = [convert_to_double_prayer]
                                        self.unitsBought = [convert_to_double_quran]
                                        self.unitsSold3 = [convert_to_double_dua]
                                        self.unitsBought4 = [convert_to_double_other]
                                        // self.unitsSold5 = [totalEvalulate_4]
                                        
                                        
                                        
                                        
                                        
                                        print(self.months)
                                        print(self.unitsSold)
                                        print(self.unitsBought)
                                        print(self.unitsSold3)
                                        print(self.unitsBought4)*/
                                        // print(self.unitsSold5)
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
//                                        print(totalEvalulate_1)
//                                        print(totalEvalulate_2)
//                                        print(totalEvalulate_3)
                                        
//                                        totalEvalulate = (localDict["totalEvalulate"] as! Double) ?? 0.0
//                                        totalEvalulate_1 = localDict1["totalEvalulate"] as! Double ?? 0.0
//                                        totalEvalulate_2 = localDict2["totalEvalulate"] as! Double ?? 0.0
//                                        totalEvalulate_3 = localDict3["totalEvalulate"] as! Double ?? 0.0
                                        
                                        
                                        // totalEvalulate = Double(localDict["totalEvalulate"]!)
                                        /*let totalValuee = self.responseArray[0]["totalValue"]
                                        totalEvalulate_4 = (totalValuee as? NSString)?.doubleValue ?? 0.0
                                        
                                        
                                        self.months = [""]
                                        self.unitsSold = [totalEvalulate]
                                        self.unitsBought = [totalEvalulate_1]
                                        self.unitsSold3 = [totalEvalulate_2]
                                        self.unitsBought4 = [totalEvalulate_3]
                                        self.unitsSold5 = [totalEvalulate_4]
                                        
                                        
                                        self.initializeChart()*/
                                        
                                    }

                                } else {
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func initializeChart() {
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
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        var dataEntries3: [BarChartDataEntry] = []
        var dataEntries4: [BarChartDataEntry] = []
        
        for i in 0..<self.months.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i])
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.unitsBought[i])
            dataEntries1.append(dataEntry1)
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: self.unitsSold3[i])
            dataEntries2.append(dataEntry2)
            let dataEntry3 = BarChartDataEntry(x: Double(i) , y: self.unitsBought4[i])
            dataEntries3.append(dataEntry3)
            let dataEntry4 = BarChartDataEntry(x: Double(i) , y: self.unitsSold5[i])
            dataEntries4.append(dataEntry4)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "")
        let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "")
        let chartDataSet3 = BarChartDataSet(entries: dataEntries3, label: "Treating Others")
        let chartDataSet4 = BarChartDataSet(entries: dataEntries4, label: "Total Bricks")
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2,chartDataSet3,chartDataSet4]
        
        chartDataSet.colors = [UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1)]
        chartDataSet1.colors = [UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)]
        chartDataSet2.colors = [UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)]
        chartDataSet3.colors = [UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)]
        chartDataSet4.colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
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
        barChartView.data = chartData
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EvaluateSuccessMonthlyWiseVCid")
        self.navigationController?.pushViewController(push, animated: true)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
extension Date {
    mutating func changeDays(by days: Int) {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}


extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
