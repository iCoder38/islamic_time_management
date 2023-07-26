//
//  Register.swift
//  ShootWorthy
//
//  Created by Apple on 21/12/20.
//

import UIKit
import QuartzCore

class QuizResultVC: UIViewController {
    var getDictJSONResponse:[String:Any] = [:]
    
    @IBOutlet weak var pieChart : LambdaPieChart!
    @IBOutlet weak var viewww : UIView!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblRemainingTime : UILabel!

    @IBOutlet weak var viewWrong : UIView!
    @IBOutlet weak var lblRight : UILabel!
    @IBOutlet weak var viewRight : UIView!
    @IBOutlet weak var lblWrong : UILabel!
    @IBOutlet weak var lblDesc : UILabel!

    @IBOutlet weak var lblPercentageWrong : UILabel!
    @IBOutlet weak var lblPercentageCorrect : UILabel!

    var totalQuestionInt = Int()
    var correctQuestionInt = Int()
    var worngQuestingInt = Int()
    var strTimerValue = String()

    // ***************************************************************** // nav 198 //
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
                lblNavigationTitle.text = "SUCCESS"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)

        print(getDictJSONResponse)
        
        let str = getDictJSONResponse["result_message"] as? String ?? ""
        self.lblDesc.setHTMLFromString(htmlText: str)

        self.totalQuestionInt = getDictJSONResponse["Total"] as? Int ?? 0
        self.correctQuestionInt =  getDictJSONResponse["correct"] as? Int ?? 0
        self.lblStatus.text =  getDictJSONResponse["status"] as? String ?? ""
        self.lblRemainingTime.text = strTimerValue
    }
    
    @objc func backClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectQuizLevelId")
        self.navigationController?.pushViewController(push, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        CircleViewResult()
    }

    func CircleViewResult() {
        
        let wrongQuestion = self.totalQuestionInt - self.correctQuestionInt
        lblRight.text = "Right Answer - \(self.correctQuestionInt)"
        lblWrong.text = "Wrong Answer - \(wrongQuestion)"
        lblStatus.text = "RESULT"

        viewww.layer.borderWidth = 2
        viewww.layer.borderColor = UIColor.cyan.cgColor
        viewww.layer.shadowOpacity = 1
        viewww.layer.shadowOffset = .zero
        viewww.layer.shadowRadius = 10

        pieChart.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        pieChart.layer.shadowOpacity = 0.5
        pieChart.layer.shadowColor = UIColor.black.cgColor
        pieChart.layer.shadowRadius = 5
        pieChart.layer.cornerRadius = 20
        
        viewWrong.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        viewWrong.layer.shadowOpacity = 0.5
        viewWrong.layer.shadowColor = UIColor.black.cgColor
        viewWrong.layer.shadowRadius = 5
        viewWrong.layer.cornerRadius = 10

        viewRight.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        viewRight.layer.shadowOpacity = 0.5
        viewRight.layer.shadowColor = UIColor.black.cgColor
        viewRight.layer.shadowRadius = 5
        viewRight.layer.cornerRadius = 10
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshAction(nil)
    }
    
    @IBAction func refreshAction(_ sender : UIButton!) {
        pieChart.lineWidth = 0.40
        let wrongQuestion = self.totalQuestionInt - self.correctQuestionInt
        pieChart.addChartData(data: [
            PieChartDataSet(percent: CGFloat(self.correctQuestionInt), colors: [#colorLiteral(red: 0.004859850742, green: 0.1671479149, blue: 0.6592983317, alpha: 0.9830372432),#colorLiteral(red: 0.004859850742, green: 0.1671479149, blue: 0.6592983317, alpha: 0.9830372432)]), // 100 * cq / total =
            PieChartDataSet(percent: CGFloat(wrongQuestion), colors: [#colorLiteral(red: 0.6847333345, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.6847333345, green: 0, blue: 0.2313725501, alpha: 1)]),  // 100 * wq / total =
        ])
        
//        self.lblPercentageCorrect.text = String(self.calculatePercentageOfTotalQuestion(totalQuestionCount: self.totalQuestionInt, percentageCount: self.correctQuestionInt))
//        self.lblPercentageWrong.text = String(self.calculatePercentageOfTotalQuestion(totalQuestionCount: self.totalQuestionInt, percentageCount: wrongQuestion))
    }
    
    func calculatePercentageOfTotalQuestion( totalQuestionCount : Int , percentageCount : Int) -> Float {
        var percentageValue = Float()
        percentageValue = Float((100 * percentageCount) / totalQuestionCount)
        return percentageValue
    }
}

extension UILabel {
    func setHTMLFromString(htmlText: String) {
        
//        let modifiedFont = "<span style=\"font-family: HelveticaNeue-Bold; font-size: 20\">\(htmlText)</span>"
        let modifiedFont = String(format:"<span style=\"font-family: HelveticaNeue-Bold; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
    }
}
