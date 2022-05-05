//
//  AppVersionModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 28/04/22.
//

import Foundation
import EVReflection

class AppVersionModel: EVObject {
    var ResponseData: AppVersionDetailModel?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class AppVersionDetailModel: EVObject {
    var IsForce = ""
    var supportTitle = ""
    var supportText = ""
    var supportEmail = ""
    var countryID = ""
    var countryCode = ""
    var countryShortName = ""
}
