//
//  GEnum.swift
//  NSC_iOS
//
//  Created by vishal parmar on 05/10/23.
//

import Foundation
import UIKit

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

enum DateStatus : String{
    case Valid   = "Valid"
    case Invalid = "Invalid"
    case Same    = "Same"
}

enum DateCompareStatus : String {
    case same = "same"
    case valid = "valid"
    case invalid = "invalid"
    case undefined = "undefined"
}

enum ScreenHeightResolution : CGFloat {

    // Height
    case height568    = 568
    case height667    = 667   // 6, 6s, 7,8
    case height736    = 736   // iPhone plus
    case height812    = 812   // Xr, Xs Max
    case height896    = 896   // Xr, Xs Max
    case height1024   = 1024   // 9.7-inch
    case height1112   = 1112   // 10.5-inch iPad Pro
    case height1194   = 1194   // 11.0-inch iPad Pro
    case height1366   = 1366   // 12.9 inch iPad
}

//-------------------------------------------------------------------
//MARK: - Date-Time Formats
//-------------------------------------------------------------------
enum DateTimeFormaterEnum : String
{
    case yyyymmdd           = "yyyy-MM-dd"
    
    case MMM_d_Y            = "MMMM d, yyyy"
    
    case MMM_dd_YYYY            = "MMM dd, yyyy"
    
    case HHmmss             = "HH:mm:ss"
    
    case hhmma              = "hh:mma"
    
    case MM              = "MM"
    
    case E_MMM_dd  = "E, MMM dd yyyy"
    
    case E_dd_MMM_dd_yyyy  = "E, dd-MMM-yyyy"
    
    case yyyy              = "yyyy"
    
    case HHmm               = "HH:mm"
    
    case dmmyyyy            = "d/MM/yyyy"
    
    case hhmmA              = "hh:mm a"
    
    case UTCFormat          = "yyyy-MM-dd HH:mm:ss"
    
    case ddmm_yyyy          = "dd MMM, yyyy"
    
    case MMdotDDdotYY       = "MM.dd.yy"
    
    case WeekDayhhmma       = "EEE,hh:mma"
    
    case ddMMyyyy           = "dd/MM/yyyy"
    
    case MMyy               = "MM/yy"
    
    case ddMMMyyyy          = "dd - MMM - yyyy"
    
    case ddMMMYYYYhhmma                             = "dd MMM, yyyy hh:mm a"
    
    case yyyyMMddTHHMMSSZ = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
    
    case yyyymmddhhmmA = "yyyy-MM-dd hh:mm a"
    
    case yyyymmddhhmmss = "yyyy-MM-dd hh:mm:ss"
    
    case ddMMMyyyy_hhmma = "dd MMM, yyyy - hh:mm a"
    
    case postDisplayDateTimeFormat = "MM/dd/yy hh:mma" //10/20/20 2:48pm
    
    case joinedDateFormat = "dd.MM.yy" //10/20/20 2:48pm
    
    case birthdateCompareFormat = "ddMM"
    
    case EEEE = "EEEE"
    
    case ddMMyyHHmmAWithDOT = "dd.MM.yy hh:mma"
    
    case dd_MM_yyyy = "dd-MM-yyyy"
}
