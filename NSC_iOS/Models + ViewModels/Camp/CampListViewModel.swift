//
//  CampListViewModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation

class CampListViewModel {
    
    var campListData = [CampListDataModel]()
    
    func callCampListAPI(completion: @escaping (Bool) -> Void) {
        let parameters = ["coachId":"11"]
        
        APIManager.shared.callAPI(router: APIRouter.camplisting(parameters)) { [weak self] (response : CampListModel?) in
            if let responseData = response?.ResponseData {
                self?.campListData = responseData
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}

