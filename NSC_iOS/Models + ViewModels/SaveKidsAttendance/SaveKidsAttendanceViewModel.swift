//
//  SaveKidsAttendanceViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/05/22.
//

import Foundation

class SaveKidsAttendanceViewModel {
    
    func callSaveKidsAttendanceAPI(campId: String, dayId: String, arrayAttendance: [[String:Any]], completion: @escaping (Bool) -> Void) {
        let parameters : [String:Any] = ["campId":campId,
                                         "dayId":dayId,
                                         "attendance":arrayAttendance.toJSON() ?? ""]
        
        APIManager.shared.callAPI(router: APIRouter.kidsattendancesave(parameters)) { (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
