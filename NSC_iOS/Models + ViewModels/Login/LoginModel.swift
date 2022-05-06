//
//  LoginModel.swift
//  NSC_iOS
//
//  Created by Dhruvit on 04/05/22.
//

import Foundation
import EVReflection

class LoginModel: EVObject {
    var ResponseData: LoginDataModel?
    var ResponseCode: String?
    var ResponseMessage: String?
    var ResponseStatus: String?
}

class LoginDataModel: EVObject {
    var ID = ""
    var ZOHOID = ""
    var Name = ""
    var Fname = ""
    var Mname = ""
    var Lname = ""
    var DOB = ""
    var Email = ""
    var CountryCode = ""
    var Mobile = ""
    var Country = ""
    var State = ""
    var City = ""
    var Address = ""
    var PostCode = ""
    var Role = ""
    var Vaccinated = ""
    var Bank_Name = ""
    var Account_Name = ""
    var IFSC_Code = ""
    var Account_Number = ""
    var Status = ""
    var BankDetailFilled = ""
    var PersonalDetailFilled = ""
    var Profile_Image = ""
}
