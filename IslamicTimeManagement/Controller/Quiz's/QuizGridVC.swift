//
//  QuizGridVC.swift
//  btutee
//
//  Created by apple on 05/10/19.
//  Copyright © 2019 Sumit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


@available(iOS 13.0, *)

class QuizGridVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    let userDefaults = UserDefaults.standard
    var arrQuizGridListJSON  = [AnyObject]()
    @IBOutlet weak var collView: UICollectionView!

    let arrImageBG = ["1","2","3","4","5","6","1","2","3","4","5","6","1","2","3","4","5","6","1","2","3","4","5","6","1","2","3","4","5","6","1","2","3","4","5","6",]

    @IBOutlet weak var lblQuiz: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        callGetDashboardAPI()
    }
    
    func alertviewCommonFunc(message1: String?)
    {
//        let alert : UIAlertView = UIAlertView(title:Localization(aLERT_aPP_nAME), message: message1, delegate: nil, cancelButtonTitle: Localization(oK_txt))
//        alert.show()
    }
    
    func callGetDashboardAPI()
    {
//        let isInternetOn =  [TAUtility.isInternetReachable()]
//        if isInternetOn == [true]
//        {
//            callGetQuizGridInformation()
//        }
//        else
//        {
//            alertviewCommonFunc( message1: Localization(cHECK_iNTERNET_cOnnection))
//        }
    }
    
    func callGetQuizGridInformation()
    {
        TAUtility.showActivityIndicator(message: Localization(pLEASE_wAIT_lBL))
        let url = kBASEURL + kNameGetLevelListing
        do
        {
            let para:NSMutableDictionary = NSMutableDictionary()
            let isCurriculum_id = userDefaults.string(forKey: "curriculum_id")
            para.setValue(isCurriculum_id, forKey: "curriculum_id")
            let isLanguageServer_id = userDefaults.string(forKey: "language_id")
            para.setValue(isLanguageServer_id, forKey: "language_id")
            let isGrade_Class_id = userDefaults.string(forKey: "grade_id")
            para.setValue(isGrade_Class_id, forKey: "grade_id")
            
            APIManager.sharedInstance.postApiHit(url2: URL(string: url)!, parameters2: para as! Parameters, onSuccess:{ json in
                TAUtility.hideActivityIndicator()
                print(json)
                self.arrQuizGridListJSON.removeAll()
                let arrLocal = json["results"].arrayObject! as! [AnyObject]
                if arrLocal.count != 0
                {
                    for index in 0..<arrLocal.count
                    {
                        let element = arrLocal[index]
                        let isStatusActive = element["status"] as? String
                        if isStatusActive! == "active"
                        {
                            let dictLocal = arrLocal[index]
                            self.arrQuizGridListJSON.append(dictLocal)
                        }
                    }
                    // =========Subject JSON List Bind============//
                    if self.arrQuizGridListJSON.count != 0
                    {
                        self.collView.reloadData()
                    }
                    else
                    {
                        TAUtility.showToast(message: json["msg"].string)
                    }
                }
            },
            onFailure:
            {
                error in
                TAUtility.hideActivityIndicator()
                TAUtility.showToast(message: error.localizedDescription)
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func btnBackClickMe(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashBoardVC") as? DashBoardVC
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    //MARK: Table and Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrQuizGridListJSON.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: CollectionCellQuizGridListing = collView.dequeueReusableCell(withReuseIdentifier: "CollectionCellQuizGridListing", for: indexPath) as! CollectionCellQuizGridListing
        TAUtility.roundedCornerBorderView(view: cell.viewCell)

        cell.imgBG.image = UIImage(named: arrImageBG[indexPath.row])

        cell.imgSubject.dowloadFromServer(link: ( self.arrQuizGridListJSON[indexPath.row]["category_image"] as? String ?? "" ), contentMode: .scaleAspectFit)
        cell.lblSubjectName.text = self.arrQuizGridListJSON[indexPath.row]["category_name"] as? String

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.userDefaults.set(self.arrQuizGridListJSON[indexPath.row]["level_id"] as? String , forKey: "level_id")
        self.userDefaults.set(self.arrQuizGridListJSON[indexPath.row]["total_time"] as? String , forKey: "total_time")
        self.userDefaults.set(self.arrQuizGridListJSON[indexPath.row]["total_question"] as? String , forKey: "total_question")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestInstructionVC") as? TestInstructionVC
        userDefaults.set("Quiz Instructions", forKey: "title")
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width  = (collectionView.frame.width)/2
        let height  = CGFloat(110)
        return CGSize(width: width, height: height)
    }
}
/*
 {
   "category_name" : "Level-1",
   "total_time" : "30",
   "curriculum_id" : "1",
   "total_question" : "30",
   "level_id" : "1",
   "language_id" : "1",
   "category_image" : "https:\/\/pnyinfotech.s3.eu-west-3.amazonaws.com\/10th\/bow.png",
   "status" : "active",
   "grade_id " : "1"
 }
 */
class CollectionCellQuizGridListing : UICollectionViewCell
{
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lblSubjectName: UILabel!
    @IBOutlet weak var imgSubject: UIImageView!
    @IBOutlet weak var imgBG: UIImageView!
    
    @IBOutlet weak var lblSemester: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRs: UILabel!
    @IBOutlet weak var lblTitile: UILabel!
    
    @IBOutlet weak var btnMoreView: UIButton!
}
