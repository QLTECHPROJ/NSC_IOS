//
//  CountryViewModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 28/04/22.
//

import Foundation

class CountryViewModel {
    
    var countryData: [Country]?
    
    func callCountryListAPI(completion: @escaping (Bool) -> Void) {
        APIManager.shared.callAPI(router: APIRouter.countrylist) { (response : CountrylistModel) in
            if response.ResponseCode == "200" {
                self.countryData = response.ResponseData
            }
        }
    }
    
}
