//
//  CountryModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 28/04/22.
//

import Foundation
import EVReflection

class CountrylistModel : EVObject {
    var ResponseData: [Country]?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class Country: EVObject {
    var ID: String?
    var Name: String?
    var ShortName: String?
    var Code: String?
}
