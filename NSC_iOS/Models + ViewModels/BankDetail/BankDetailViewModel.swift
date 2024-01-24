//
//  BankDetailViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 10/05/22.
//

import Foundation

class BankDetailViewModel {
    
    func callUpdateBankDetailsAPI(parameters: [String:String], completion: @escaping (Bool) -> Void) {
        APIManager.shared.callAPI(router: APIRouter.coachupdatebankdetails(parameters)) { (response : PersonalDetailModel?) in

            if response?.ResponseCode == "200" {
                
                GFunctions.shared.showSnackBar(message: JSON(response?.ResponseMessage as Any).stringValue)
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
