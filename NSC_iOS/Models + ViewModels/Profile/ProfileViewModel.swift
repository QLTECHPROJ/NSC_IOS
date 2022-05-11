//
//  ProfileViewModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 11/05/22.
//

import Foundation

class ProfileViewModel {
    
    var profileData: LoginDataModel?
    
    func callProfileUpdateAPI(parameters : [String:String], completion: @escaping (Bool) -> Void) {
        APIManager.shared.callAPI(router: APIRouter.profileUpdate(parameters)) { [weak self] (response : LoginModel?) in
            if let responseData = response?.ResponseData {
                self?.profileData = responseData
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

