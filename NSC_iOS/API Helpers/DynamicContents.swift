//
//  DynamicContents.swift
//  NSC_iOS
//
//  Created by Dhruvit on 03/05/22.
//

import Foundation

// MARK: - Dynamic Contents

var countryID : String {
    get {
        return UserDefaults.standard.string(forKey: "countryID") ?? "101"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "countryID")
        UserDefaults.standard.synchronize()
    }
}

var countryCode : String {
    get {
        return UserDefaults.standard.string(forKey: "countryCode") ?? "91"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "countryCode")
        UserDefaults.standard.synchronize()
    }
}

var countryShortName : String {
    get {
        return UserDefaults.standard.string(forKey: "countryShortName") ?? "IN"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "countryShortName")
        UserDefaults.standard.synchronize()
    }
}

var supportTitle : String {
    get {
        return UserDefaults.standard.string(forKey: "supportTitle") ?? "Support"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "supportTitle")
        UserDefaults.standard.synchronize()
    }
}

var supportText : String {
    get {
        return UserDefaults.standard.string(forKey: "supportText") ?? "Please contact support at "
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "supportText")
        UserDefaults.standard.synchronize()
    }
}

var supportEmail : String {
    get {
        return UserDefaults.standard.string(forKey: "supportEmail") ?? "serotonin@lobsterapp.com.au"
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "supportEmail")
        UserDefaults.standard.synchronize()
    }
}

var authVerificationID : String {
    get {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        return verificationID
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "authVerificationID")
    }
}
