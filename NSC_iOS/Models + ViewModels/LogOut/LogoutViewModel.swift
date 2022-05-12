//
//  LogoutViewModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation

class LogoutViewModel {
    
     func callLogoutAPI(completion: @escaping (Bool) -> Void) {
        let parameters = ["deviceType":APP_TYPE,
                          "deviceToken":FCM_TOKEN,
                          "coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.logout(parameters)) { (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                showAlertToast(message: response?.ResponseMessage ?? "")
              
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}

