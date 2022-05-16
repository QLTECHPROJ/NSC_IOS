//
//  LoginViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 04/05/22.
//

import Foundation

class LoginViewModel {
    
    var userData: LoginDataModel?
    
    func callLoginAPI(parameters : [String:String], completion: @escaping (Bool) -> Void) {
        APIManager.shared.callAPI(router: APIRouter.login(parameters)) { [weak self] (response : LoginModel?) in
            if response?.ResponseCode == "200", let responseData = response?.ResponseData {
                self?.userData = responseData
                
                LoginDataModel.currentUser = responseData
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
