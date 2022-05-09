//
//  CampListModel.swift
//  NSC_iOS
//
//  Created by Mac Mini on 09/05/22.
//

import Foundation
import EVReflection

class CampListModel: EVObject {
    var ResponseData = [CampListDataModel]()
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class CampListDataModel: EVObject {
    var CampId: String?
    var CampName: String?
    var CampDetail: String?
    var CampAddress: String?
    var CampImage: String?
    var CampStatus: String?
}
