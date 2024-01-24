//
//  DeleteCoachViewModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation

class DeleteCoachViewModel {
    
    func callDeleteCoachAPI(completion: @escaping (Bool) -> Void) {
        let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.deletecoach(parameters)) { (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                completion(true)
                
                GFunctions.shared.showSnackBar(message: JSON(response?.ResponseMessage as Any).stringValue)
                
            } else {
                completion(false)
            }
        }
    }
    
}
