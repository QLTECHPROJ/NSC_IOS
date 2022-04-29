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
    var IsForce: String?
    var supportTitle: String?
    var supportText: String?
    var supportEmail: String?
    var countryCode: String?
    var countryShortName: String?
}
