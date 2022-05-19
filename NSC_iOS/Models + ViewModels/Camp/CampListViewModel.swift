//
//  CampListViewModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation

class CampListViewModel {
    
    var arrayCurrentCampList = [CampDetailModel]()
    var arrayUpcomingCampList = [CampDetailModel]()
    
    func callCampListAPI(completion: @escaping (Bool) -> Void) {
        let parameters = ["coachId":"11"]
        
        APIManager.shared.callAPI(router: APIRouter.camplisting(parameters)) { [weak self] (response : CampListModel?) in
            if response?.ResponseCode == "200", let responseData = response?.ResponseData {
                self?.arrayCurrentCampList = responseData.current
                self?.arrayUpcomingCampList = responseData.upcoming
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}

