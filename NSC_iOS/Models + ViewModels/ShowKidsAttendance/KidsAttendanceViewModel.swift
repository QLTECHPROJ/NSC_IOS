//
//  KidsAttendanceViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 19/05/22.
//

import Foundation

class KidsAttendanceViewModel {
    
    var arrayKids = [KidsAttendanceDataModel]()
    
    func callShowKidsAttendanceAPI(campId: String, dayId: String, completion: @escaping (Bool) -> Void) {
        let parameters = ["campId":campId,
                          "dayId":dayId]
        
        APIManager.shared.callAPI(router: APIRouter.kidsattendanceshow(parameters)) { [weak self] (response : KidsAttendanceModel?) in
            if response?.ResponseCode == "200", let responseData = response?.ResponseData {
                self?.arrayKids = responseData
                
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
