//
//  InviteViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 18/05/22.
//

import Foundation

class InviteViewModel {
    
    func callInviteUserAPI(contact : ContactModel, completion: @escaping (Bool) -> Void) {
        let parameters = ["coachId":"12",
                          "name":contact.contactName,
                          "mobile":contact.contactNumber]
        
        APIManager.shared.callAPI(router: APIRouter.inviteuser(parameters)) { (response : LogoutModel?) in
            if response?.ResponseCode == "200" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
