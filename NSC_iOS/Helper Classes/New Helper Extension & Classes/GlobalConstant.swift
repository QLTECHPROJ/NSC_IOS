//
//  GlobalConstant.swift
//  NSC_iOS
//
//  Created by vishal parmar on 21/10/23.
//

import Foundation

//let API_BASE_URL = "https://shop.nationalsportscamps.in/wp-json/COACH/STAGING/API/v1/"

class APIURL : NSObject{
    
    static let shared : APIURL = APIURL()
    
    var baseUrlType : APIEnvironment = .staging
    
    override init() {
        
    }
    
    func getBaseUrl() -> String{
        
        if self.baseUrlType == .live{
            
            return "https://shop.nationalsportscamps.in/wp-json/COACH/STAGING/API/v1/"
        }
        else {
            return "https://shop.nationalsportscamps.in/wp-json/COACH/STAGING/API/v1/"
        }
    }
    
    func getAppUrls()->(termCondition : String,privacyPolicy : String, aboutUs : String,faq : String){
        
        let termConditionURL = "https://shop.nationalsportscamps.in/terms-conditions/"
        let privacyPolicyURL = "https://shop.nationalsportscamps.in/nsc-privacy-policy/"
        let aboutUsURL = ""
        let faqURL = ""
        
        return (termCondition : termConditionURL,privacyPolicy : privacyPolicyURL, aboutUs : aboutUsURL,faq : faqURL)
    }
}

enum APIEnvironment {
    
    case live
    case staging
}

