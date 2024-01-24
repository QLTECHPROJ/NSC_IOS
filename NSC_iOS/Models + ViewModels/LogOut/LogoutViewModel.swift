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
                          "deviceId":DEVICE_UUID,
                          "deviceToken":FCM_TOKEN,
                          "coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.logout(parameters)) { (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                
                GFunctions.shared.showSnackBar(message: JSON(response?.ResponseMessage as Any).stringValue)
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
}

