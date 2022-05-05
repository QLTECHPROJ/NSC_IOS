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
                          "coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.appversion(parameters)) { [weak self] (response : AppVersionModel?) in
            if let responseData = response?.ResponseData {
                self?.appVersionData = responseData
                
                AppVersionDetails.current = responseData
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
