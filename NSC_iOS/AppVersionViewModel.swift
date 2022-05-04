//
//  AppVersionViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 28/04/22.
//

import Foundation

class AppVersionViewModel {
    
    var appVersionData: AppVersionDetailModel?
    
    func callAppVersionAPI(completion: @escaping (Bool) -> Void) {
        let parameters = ["version":APP_VERSION,
                          "deviceType":APP_TYPE,
                          "deviceToken":FCM_TOKEN,
                          "coachId":"1"]
        
        APIManager.shared.callAPI(router: APIRouter.appversion(parameters)) { [weak self] (response : AppVersionModel?) in
            if let countryResponse = response {
                self?.appVersionData = countryResponse.ResponseData
                
                countryID = countryResponse.ResponseData?.countryID ?? ""
                countryCode = countryResponse.ResponseData?.countryCode ?? ""
                countryShortName = countryResponse.ResponseData?.countryShortName ?? ""
                supportTitle = countryResponse.ResponseData?.supportTitle ?? ""
                supportText = countryResponse.ResponseData?.supportText ?? ""
                supportEmail = countryResponse.ResponseData?.supportEmail ?? ""
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
