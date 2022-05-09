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
        
        APIManager.shared.callAPI(router: APIRouter.deletecoach(parameters)) { [weak self] (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                showAlertToast(message: response?.ResponseMessage ?? "")
              
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
