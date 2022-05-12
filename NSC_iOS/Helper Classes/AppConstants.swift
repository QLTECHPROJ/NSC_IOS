//
//  AppConstants.swift
//  NSC_iOS
//
//  Created by Dhruvit on 14/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

class AppConstants {
    
    static let shared = AppConstants()
    
    var maxDigits : Int {
        if AppVersionDetails.countryCode == "61" {
            return 10
        } else {
            return 10
        }
    }
    
}
