//
//  ReferDataViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 27/05/22.
//

import Foundation

class ReferDataViewModel {

    func callReferDataAPI(completionBlock: @escaping (JSON?,String?,String?,Bool) -> Void) {
        
        let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPIWithJSON(router: APIRouter.referdata(parameters),showToast : false) { responseData, data, statusCode, message, completion in
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
