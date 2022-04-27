//
//  Config.swift
//  BWS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import UIKit

// Application Constants
let APP_VERSION = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1"
let APP_TYPE = "0" // 0 = IOS , 1 = Android
let APP_NAME = "Lobster App"
let DEVICE_UUID = UIDevice.current.identifierForVendor!.uuidString

let APP_APPSTORE_URL = "https://apps.apple.com/us/app/lobster-pursuit-of-meaning/id1606322555"
let TERMS_AND_CONDITION_URL = "https://lobsterapp.com.au/term_condition.php"
let PRIVACY_POLICY_URL = "https://lobsterapp.com.au/privacy.php"
let HOW_REFER_WORKS_URL = "https://lobsterapp.com.au/how-refer-works/"

// In App Purchase
let MANAGE_SUBSCRIPTIONS_URL = "https://apps.apple.com/account/subscriptions"

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let SCREEN_SIZE = UIScreen.main.bounds.size

// Screen Height / Width
let SCREEN_MAX_LENGTH = max(SCREEN_SIZE.width, SCREEN_SIZE.height)
let SCREEN_MIN_LENGTH = min(SCREEN_SIZE.width, SCREEN_SIZE.height)

// Check iPhone or iPad
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let IS_IPHONE = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
let IS_RETINA = UIScreen.main.scale >= 2.0

// Check iPhone Model
let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH < 568.0
let IS_IPHONE_5 = IS_IPHONE && SCREEN_MAX_LENGTH == 568.0
let IS_IPHONE_8 = IS_IPHONE && SCREEN_MAX_LENGTH == 667.0
let IS_IPHONE_8_Plus = IS_IPHONE && SCREEN_MAX_LENGTH == 736.0
let IS_IPHONE_11_Pro = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0
let IS_IPHONE_11_Pro_MAX = IS_IPHONE && SCREEN_MAX_LENGTH == 896.0

// iPhone Model Height
let IPHONE_4_OR_LESS = 480.0
let IPHONE_5 = 568.0
let IPHONE_8 = 667.0
let IPHONE_8_Plus = 736.0
let IS_IPHONE_13_Mini = IS_IPHONE && SCREEN_MAX_LENGTH == 812.0
let IS_IPHONE_13_Pro = IS_IPHONE && SCREEN_MAX_LENGTH == 844.0
let IS_IPHONE_13_Pro_MAX = IS_IPHONE && SCREEN_MAX_LENGTH == 926.0

// Logged In User
var LOGIN_TOKEN = ""
var DEVICE_TOKEN = "1234567890"
var FCM_TOKEN = "1234567890"

// Complition blocks
typealias AlertComplitionBlock = (Int) -> ()
typealias ActionSheetComplitionBlock = (String) -> ()
typealias APIComplitionBlock = (Bool,Any) -> ()
typealias StatusComplitionBlock = (Bool) -> ()

// ThirdParty API IDs
enum ClientIds : String {
    case key = ""
}

// URLSchemes Redirects
enum URLSchemes : String {
    case google = ""
}

//var apiFlag : String {
//    #if DEBUG
//    if (LoginDataModel.currentUser?.UserID ?? "") == "297" {
//        return "1"
//    }
//    return "0"
//    #else
//    return "1"
//    #endif
//}

// For Pagination
let perPage = 20

// Zoho Chat Keys
var strAppKey = "9dlneXPtg5BBj%2Bfxlkcl8emTA1Bh1xBItbOv1x%2BD0%2B%2FnQ6gZ9RETehcmrEE9Ei223wQdIKrc5d4%3D_in"
var strAccessKey = "b7ssd%2FOv4qtfLg7PIUwMPLlfJuPwHtDd%2B9aEcjyingPcm56t6Axkdhj1sR%2FA8g5A5nUv9tus73Jqv538rCr9SlJYSeYqcIfA9CFk1cgAXtmlWmd%2FB3Ar23JMxLQS0RuNRgm7M0XvlFGXn00jXmyp1Q%3D%3D"

// MARK: - App StoryBoards

enum AppStoryBoard : String {
    case main = "Main"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func intialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    
    
}
