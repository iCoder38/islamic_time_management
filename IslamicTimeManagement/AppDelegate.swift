//
//  AppDelegate.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit
//@available(iOS 13.0, *)
//import Stripe
import CoreLocation
import IQKeyboardManagerSwift
import UserNotificationsUI
import UserNotifications
import Firebase
import FirebaseMessaging

var deviceTokenId = "67845bv864876358658"

@available(iOS 13.0, *)
@UIApplicationMain
//@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    var  locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        
        // for testing key :->  pk_test_IKI2kAgTcd5D9LL4Nv7uc7ZT
//                STPPaymentConfiguration.shared().publishableKey = "pk_test_IKI2kAgTcd5D9LL4Nv7uc7ZT"
        //        determineMyCurrentLocation()
        
        /*FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        self.registerForRemoteNotification()*/
//        STPPaymentConfiguration.shared().publishableKey = "pk_live_3oBerVycojWx2X3SgDkE3Jop"
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        self.fetchDeviceToken()
        
        
        // determineMyCurrentLocation()
        
        
        return true
    }
    
//    private func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Error = ",error.localizedDescription)
//    }
//
//    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        print(userInfo)
//    }
//
//    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        print(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                // deviceToken
//                defaults.set("\(token)", forKey: "deviceToken")
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                print("\(token)")
                
            }
        }
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // MARK:- WHEN APP IS OPEN -
//    @available(iOS 10.0, *)
     
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        print("User Info dishu = ",notification.request.content.userInfo)
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner,.badge, .sound])
        } else {
            // Fallback on earlier versions
            completionHandler([.sound,.badge])
        }
        
    }
    
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
//    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info ====> ",response.notification.request.content.userInfo)
        
//        let background_notification_item = response.notification.request.content.userInfo
        
//        self.notification_medical_permission_show(dictOfNotification: background_notification_item as NSDictionary)
        
    }
    
    
    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        UserDefaults.standard.set(token, forKey: "deviceToken")
        UserDefaults.standard.synchronize()
        Messaging.messaging().apnsToken = deviceToken as Data
        print("Device Token = ", token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if(userInfo[AnyHashable("data")] != nil){
            let data = userInfo[AnyHashable("data")] as! String
            print(data)
            let dict = convertToDictionary(text: data)! as NSDictionary
            print(dict)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: UNUserNotificationCenter Delegate // >= iOS 10
//    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
//    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
        if(response.notification.request.content.userInfo[AnyHashable("data")] != nil){
            let data = response.notification.request.content.userInfo[AnyHashable("data")] as! String
            print(data)
            let dict = convertToDictionary(text: data)! as NSDictionary
            print(dict)
        }
    }*/
    
    // MARK: Class Methods
    
    func registerForRemoteNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let defaults = UserDefaults.standard
        // deviceToken
//                defaults.set("\(token)", forKey: "deviceToken")
        defaults.set("\(fcmToken!)", forKey: "key_my_device_token")
        
        // print("\(fcmToken!)")
        
        
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    //-------------------------//
    
    /*func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        UserDefaults.standard.setValue(userLocation.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.setValue(userLocation.coordinate.longitude, forKey: "longitude")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }*/
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            URLSession.shared.finishTasksAndInvalidate()
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                
                self.image = image
            }
        }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}

extension String
{
    var trimmed:String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
extension UIViewController
{
    func alertviewCommonFunc(message1: String?)
    {
        let alert = UIAlertController(title: "Alert", message: message1, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

