//
//  EarningViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 18/05/22.
//

import Foundation

class EarningViewModel {
    
    func callMyEarningAPI(completionBlock: @escaping (JSON?,String?,String?,Bool) -> Void) {
        
        let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPIWithJSON(router: APIRouter.myearning(parameters),showToast : false) { responseData, data, statusCode, message, completion in
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
