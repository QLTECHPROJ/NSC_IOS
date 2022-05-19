//
//  KidsAttendanceModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 19/05/22.
//

import Foundation
import EVReflection

class KidsAttendanceModel: EVObject {
    var ResponseData: [KidsAttendanceDataModel]?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class KidsAttendanceDataModel: EVObject {
    var ID = ""
    var Name = ""
    var Group_Name = ""
    var Morning_Attendance = ""
    var Lunch_Attendance = ""
    var CheckIn = ""
}
