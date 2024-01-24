//
//  ApplyForACampViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 18/05/22.
//

import Foundation

class ApplyForACampViewModel {
    
    var maxCount : Int = 0
    var arrayCamps: [ApplyCampModel]?
    
    func callItemListAPI(isLoader : Bool = false,completion: @escaping (Bool) -> Void) {
        
        let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.applyForACampListing(parameters),displayHud: isLoader) { (response : ApplyForACampModel) in
        
            if response.ResponseCode == "200", let responseData = response.ResponseData {
                
                self.maxCount = Int(responseData.maxCount ?? "") ?? 3
                self.arrayCamps = responseData.campList
                
                completion(true)
                
            } else {
            
                completion(false)
            }
        }
    }
}
