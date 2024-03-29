//
//  CampListModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation
import EVReflection

class CampListModel: EVObject {
    var ResponseData: CampListDataModel?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class CampListDataModel: EVObject {
    var BannerImage = ""
    var current = [CampDetailModel]()
    var upcoming = [CampDetailModel]()
}

class MainCampDetailModel: EVObject {
    var title = ""
    var data = [CampDetailModel]()
}


class CampDetailModel: EVObject {
    var CampId = ""
    var CampName = ""
    var CampDetail = ""
    var CampAddress = ""
    var CampImage = ""
    var CampStatus = ""
    var dayshift = ""
    var isWorkingDay = ""
    var CampDates = ""
    var totalPrice = ""
    var dayAvialability = [DayAvialabilityModel]()
}

class DayAvialabilityModel: EVObject {
    var dayPrice = ""
    var coachAvailability = ""
    var day = ""
}


