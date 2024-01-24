//
//  NotificationListViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 19/07/22.
//

import Foundation

class NotificationListViewModel {
    
    func callNotificationListAPI(isLoader : Bool = false,completionBlock: @escaping (JSON?,String?,String?,Bool) -> Void) {
        
        let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPIWithJSON(router: APIRouter.notification_listing(parameters),isLoader : isLoader,showToast : false) { responseData, data, statusCode, message, completion in
            if completion, statusCode == ApiKeys.ApiStatusCode.success.rawValue, let receivdeData = data {
                
                debugPrint(receivdeData)
        
                completionBlock(receivdeData,statusCode,message,true)
            }
            else{
            
                completionBlock(nil,statusCode,message,false)
            }
        }
    }
}
