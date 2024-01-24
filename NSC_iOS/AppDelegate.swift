//
//  AppDelegate.swift
//  NSC_iOS
//
//  Created by Dhruvit on 26/04/22.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
@_exported import SDWebImage
@_exported import SwiftyJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set App Notification Count to "0" on App Launch
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        UITextField.appearance().tintColor = .colorAppThemeOrange
        APIURL.shared.baseUrlType = .staging
        
        // IQKeyboardManager Setup
        IQKeyboardManager.shared.enable = true
        
        // Ask for Push Notification Permission
        self.openPushNotificationPermissionAlert()
        
        // Firebase Configuration
        FirebaseApp.configure()
        Messaging.messaging().delegate = self // Firebase Cloud Messaging
        
        // UIFont setup font
        
        window?.makeKeyAndVisible()
        window?.rootViewController = AppStoryBoard.main.intialViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable:Any] {
                
                //                GFunctions.shared.showSnackBar(message: "didFinishLaunchingWithOptions Payload :- \(userInfo)")
                
                self.handlePushNotification(userInfo: userInfo as NSDictionary )
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let appVersionVM = AppVersionViewModel()
        appVersionVM.callAppVersionAPI(completion: { success in
            if success {
               
            }
        })
    }
    
    func logout() {
        LoginDataModel.currentUser = nil
        
        let loginNav = AUTHENTICATION.instantiateViewController(withIdentifier: "navLogin") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = loginNav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func openPushNotificationPermissionAlert() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NSC_iOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


// MARK: - UIApplication Life Cycle Events
extension AppDelegate {
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Set App Notification Count to "0" on App Launch
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if AppVersionDetails.IsForce == "1" {
            window?.rootViewController = AppStoryBoard.main.intialViewController()
        }
    }
    
}


// MARK: - Push Notification SetUp
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        DEVICE_TOKEN = deviceToken.hexString
        print("DEVICE_TOKEN :- ",DEVICE_TOKEN)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError :- ",error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(
        [UNNotificationPresentationOptions.alert,
         UNNotificationPresentationOptions.sound,
         UNNotificationPresentationOptions.badge])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Notification Payload :- ",userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
        UIApplication.shared.applicationIconBadgeNumber = 1
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let userInfo = response.notification.request.content.userInfo
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.handlePushNotification(userInfo: userInfo as NSDictionary)
        }
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        FCM_TOKEN = fcmToken ?? ""
        print("FCM_TOKEN :- ",FCM_TOKEN)
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
}


extension AppDelegate {
    
    // Extract User Info from Push Notification
    func extractUserInfo(userInfo: [AnyHashable : Any]) -> (title: String, body: String) {
        var info = (title: "", body: "")
        guard let aps = userInfo["aps"] as? [String: Any] else { return info }
        guard let alert = aps["alert"] as? [String: Any] else { return info }
        let title = alert["title"] as? String ?? ""
        let body = alert["body"] as? String ?? ""
        info = (title: title, body: body)
        return info
    }
    
}

//------------------------------------------------------------------------------------------------
//MARK: - Custome Push Handling Funs
//------------------------------------------------------------------------------------------------
extension AppDelegate{
    
    //*** All Push Handling Methods ***//
    
    @objc func handlePushNotification(userInfo: NSDictionary) {
        
        guard let topVC = UIApplication.topViewController() else{
            
            return
        }
    
        guard  let flag = userInfo["flag"] as? String else {return}
        
        if flag == NotificationTags.earning.rawValue{
            
            if let vc = topVC as? EarningVC{
                
                vc.apiCallMyEarning()
            }
            else{
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:EarningVC.self)
                UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            }
        }
        else if flag == NotificationTags.swapGroup.rawValue{
            if let vc = topVC as? KidsAttendanceVC{
                vc.apiCallShowKidsAttendanceAPI()
            }
            else{
                
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:KidsAttendanceVC.self)
                aVC.campID = (userInfo["id"] as? String) ?? ""
                UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            }
        }
        else if flag == NotificationTags.kidCheckIn.rawValue{
            
            if let vc = topVC as? KidsAttendanceVC{
                vc.apiCallShowKidsAttendanceAPI()
            }
            else{
                let aVC = AppStoryBoard.main.viewController(viewControllerClass:KidsAttendanceVC.self)
                aVC.campID = (userInfo["id"] as? String) ?? ""
                UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            }
        }
    }
}

