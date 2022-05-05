//
//  SignUpViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 05/05/22.
//

import Foundation

class SignUpViewModel {
    
    var userData: LoginDataModel?
    
    func callCoachRegisterAPI(parameters : [String:String], completion: @escaping (Bool) -> Void) {
        APIManager.shared.callAPI(router: APIRouter.coachregister(parameters)) { [weak self] (response : LoginModel?) in
            if let responseData = response?.ResponseData {
                self?.userData = responseData
                
                LoginDataModel.currentUser = responseData
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}