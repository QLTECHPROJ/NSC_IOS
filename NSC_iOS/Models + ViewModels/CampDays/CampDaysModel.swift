//
//  CampDaysModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 17/05/22.
//

import Foundation
import EVReflection

class CampDaysModel: EVObject {
    var ResponseData: CampDaysDataModel?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class CampDaysDataModel: EVObject {
    var totalDays = ""
    var days = [CampDaysDetailModel]()
}

class CampDaysDetailModel: EVObject {
    var dayId = ""
    var currentDay = ""
}
