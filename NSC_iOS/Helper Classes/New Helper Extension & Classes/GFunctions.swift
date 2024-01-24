//
//  GFunctions.swift
//  NSC_iOS
//
//  Created by vishal parmar on 05/10/23.
//

import Foundation
import AVKit

enum ConvertType {
    case LOCAL, UTC, NOCONVERSION
}

enum DisplayRelatedTimeFormat : String{
    case Universal
    case LikeListTime
    case UserStatus
}

class GFunctions: NSObject {
    static let shared   : GFunctions        = GFunctions()
    
    let snackbar: TTGSnackbar = TTGSnackbar()
    var dateFormatter = DateFormatter()
}


extension GFunctions {
    
    func getTimeDifferentFromDates(firstDate : String ,endDate : String? = nil, dateFormat : String)->(year : Int, months : Int, days : Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        var currentdate : Date = Date()
        
        if let _ = endDate{
            currentdate = dateFormatter.date(from: endDate!)!
        }
        
        if let date = dateFormatter.date(from: firstDate) {
            let time = Calendar.current.dateComponents([.day], from: date, to: currentdate)
            
            print("Year = \(time.year), Months =\(time.month), Days =\(time.day)")
            return (time.year ?? 0,time.month ?? 0,time.day ?? 0)
        }
        else{
            return (0,0,0)
        }
    }
    
    
    func convertDateFormat(dt: String, inputFormat: String, outputFormat: String, status: ConvertType) -> (str : String, date : Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        if status == .LOCAL || status == .NOCONVERSION {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        dateFormatter.dateFormat = inputFormat
        
        var date : NSDate!
        if let dt = dateFormatter.date(from: dt) {
            
            if status == .LOCAL {
                date = self.convertToLocal(sourceDate: dt as NSDate)
            } else if status == .UTC {
                date = self.convertToUTC(sourceDate: dt as NSDate)
            } else {
                date = dt as NSDate
            }
            
            dateFormatter.dateFormat = outputFormat
            
            let strDate = dateFormatter.string(from: date as Date)
            return (str : strDate, date : dateFormatter.date(from: strDate) ?? Date())
        } else {
            return (str : "", date : Date())
        }
    }
    func convertToLocal(sourceDate : NSDate) -> NSDate {
        
        let sourceTimeZone                                      = NSTimeZone(abbreviation: "UTC")
        let destinationTimeZone                                 = NSTimeZone.system
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone?.secondsFromGMT(for: sourceDate as Date))!
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone.secondsFromGMT(for:sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    //--------------------------------------------------------------------------------------
    //MARK: - convert date to utc -
    
    func convertToUTC(sourceDate : NSDate) -> NSDate {
        
        let sourceTimeZone                                      = NSTimeZone.system
        let destinationTimeZone                                 = NSTimeZone(abbreviation: "UTC")
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone.secondsFromGMT(for:sourceDate as Date))
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone!.secondsFromGMT(for: sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: NSDate                                        = NSDate(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    func convertRelativeTimeString(_ dateString : String,inputFormat : String = "",compareFormatType : DisplayRelatedTimeFormat = .Universal) -> String{
        var calendar = Calendar.current
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat.isEmpty ? "yyyy-MM-dd HH:mm:ss" : inputFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let dt = dateFormatter.date(from: dateString) else {
            return ""
        }
//        dateFormatter.timeZone = TimeZone.current
        let calcualtedDate = dateFormatter.string(from: dt)
        
        let hour = calendar.component(.hour, from: dateFormatter.date(from:calcualtedDate)!)
        let year = calendar.component(.year, from: dateFormatter.date(from:calcualtedDate)!)
        let month = calendar.component(.month, from: dateFormatter.date(from:calcualtedDate)!)
        let day = calendar.component(.day, from: dateFormatter.date(from:calcualtedDate)!)
        let minute = calendar.component(.minute, from: dateFormatter.date(from:calcualtedDate)!)
        
        guard let date1 = DateComponents(calendar: calendar, year: year, month:  month, day: day, hour: hour, minute: minute).date else{return ""}
        
        var returnTimeOffSet = ""
        
        if compareFormatType == .LikeListTime{
            returnTimeOffSet = date1.relativeLikeTime
        }
        else if compareFormatType == .UserStatus{
            returnTimeOffSet = date1.relativeUserActiveTime
        }
        else{
            returnTimeOffSet = date1.relativeTime
        }
        return returnTimeOffSet
    }
    
    func relativeDateForChat(dateString: String,inputFormat : String,returnDateFormat : String) -> (display: String, isToday : Bool, isYesterday : Bool,returnDate : String) {
        
        if dateString.isEmpty {
            return (display: "", isToday : false, isYesterday : false,returnDate : "")
        }
        
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = inputFormat
        //            DateTimeFormaterEnum.yyyyMMddHHmmss.rawValue
        
        guard let convertDate = formatter.date(from: dateString) as NSDate? else {
            return (display: "", isToday : false, isYesterday : false, returnDate : "")
        }
        
        var returnValue = ""
        var returnFormattedDate =  GFunctions.shared.convertDateFormat(dt: dateString, inputFormat: inputFormat, outputFormat: returnDateFormat, status: .LOCAL).str
        
        let date = self.convertToLocal(sourceDate: convertDate)
        
        let date1 = Date()
        
        var components: DateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .month, .year, .second], from: date as Date, to: date1)
        
        if components.day! > 0 || components.month! > 0 || components.year! > 0{
            
            if components.day! == 1 && components.month! == 0 && components.year! == 0{
                returnValue = "Yesterday"
                return (display: returnValue, isToday : false,isYesterday : true, returnDate : returnFormattedDate)
            }else{
                returnValue = GFunctions.shared.convertDateFormat(dt: dateString, inputFormat: inputFormat, outputFormat: DateTimeFormaterEnum.ddMMyyyy.rawValue, status: .LOCAL).str
            }
        }else {
            returnValue = "Today"
                //GFunctions.shared.convertDateFormat(dt: dateString, inputFormat: inputFormat, outputFormat: DateTimeFormaterEnum.hhmma.rawValue, status: .LOCAL).str
            return (display: returnValue, isToday : true,isYesterday : false, returnDate : returnFormattedDate)
        }
        
        return (display: returnValue, isToday : false,isYesterday : false, returnDate : returnFormattedDate)
    }
    

    func compareOnlyTime(timeString : String,inputFormat: String,outputFormats : String)-> (timeString : String, timeDate : Date?){
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = DateTimeFormaterEnum.yyyymmdd.rawValue
        let currentDate = dateformattor.string(from: Date())
        
        let rowTimeDate = "\(currentDate) \(timeString)"
        
        dateformattor.dateFormat = "\(DateTimeFormaterEnum.yyyymmdd.rawValue) \(inputFormat)"
        
        if let returnTime = dateformattor.date(from: rowTimeDate){
            dateformattor.dateFormat = outputFormats
            return (dateformattor.string(from: returnTime),returnTime)
        }
        return ("",nil)
    }
    
    func compareDates(selectedDate : Date, format : String = DateTimeFormaterEnum.ddmm_yyyy.rawValue)-> String{
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = format
        let date1 = dateformattor.string(from: Date())
        let date2 = dateformattor.string(from: selectedDate)
        
        dateformattor.dateFormat = format
        let firstDate = dateformattor.date(from: date1)
        let selectDate = GFunctions.shared.convertToLocal(sourceDate: dateformattor.date(from: date2) as! NSDate)
        
        print("\(selectDate) \(String(describing: firstDate))")
        
        if firstDate!.compare(selectDate as Date) == .orderedAscending {
            
            print("First date is smaller then second date")
            
            return DateStatus.Valid.rawValue
            
        }else if firstDate!.compare(selectDate as Date) == .orderedDescending{
            
            print("First date is greater then second date")
            
            return DateStatus.Invalid.rawValue
        }
        else{
            return DateStatus.Same.rawValue
        }
    }
    
    
    func setThemeDateView(insertDate : Date,dateInputFormat : String, dateOutputFormat : String,rideTime: String = "",timeInputFormat : String = "", timeOutputFormat : String = "", status: ConvertType = ConvertType.LOCAL) -> (date: String, time : String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateInputFormat
        let date = dateFormatter.string(from: insertDate)
        
        let partyDate1 = GFunctions.shared.convertDateFormat(dt: date, inputFormat: dateInputFormat, outputFormat: dateOutputFormat, status: status).str
        
        //-----------------------------------------------------------
        let calendar = Calendar.current
        
        dateFormatter.dateFormat = dateInputFormat
        let rideDate = dateFormatter.date(from: partyDate1)
        
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: rideDate!)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM, yyyy"
        let mothAndYear = dateFormatter.string(from: rideDate!)
        
        var day  = "\(anchorComponents.day!)"
        
        switch (day) {
            
        case "1" , "01" , "21" , "31":
            day.append("st")
        case "2" , "02" , "22":
            day.append("nd")
        case "3" , "03" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        
        //-----------------------------------------------------------
        //        dateFormatter.timeZone = TimeZone.current
                
        if rideTime != ""{
            
            dateFormatter.dateFormat = timeInputFormat
            
            if var temptime = dateFormatter.date(from: rideTime){
                
                dateFormatter.dateFormat = timeOutputFormat
                
                if status == .LOCAL {
                    temptime = self.convertToLocal(sourceDate: temptime as NSDate) as Date
                }
                
                let finalTime = dateFormatter.string(from: temptime)
                
                return (date : "\(day) \(mothAndYear)",time : finalTime)
            }else{
                return (date : "\(day) \(mothAndYear)",time : "")
            }
        }else{
            return (date : "\(day) \(mothAndYear)",time : "")
        }
    }
    
}

extension GFunctions {
    
    func showSnackBar(textAlignment : NSTextAlignment = .left,message : String, backGroundColor : UIColor = UIColor.colorAppThemeOrange, duration : TTGSnackbarDuration = .middle , animation : TTGSnackbarAnimationType = .slideFromTopBackToTop, textColor : UIColor = UIColor.white) {
        //        let snackbar: TTGSnackbar = TTGSnackbar.init(message: message, duration: duration)
        snackbar.message = message
        snackbar.duration = duration
        // Change the content padding inset
        snackbar.contentInset = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
        
        // Change margin
        snackbar.leftMargin = animation == .slideFromBottomBackToBottom ? 20 : 0
        snackbar.rightMargin = animation == .slideFromBottomBackToBottom ? 20 : 0
        snackbar.topMargin = 0
        snackbar.bottomMargin = animation == .slideFromBottomBackToBottom ? 75 : 0
        
        // Change message text font and color
        snackbar.messageTextColor = textColor
        snackbar.messageTextAlign = textAlignment
        snackbar.messageTextFont = UIFont.applyCustomFont(fontName: .SFProDisplayMedium, fontSize: 12.0 * kFontAspectRatio)
        
        // Change snackbar background color
        snackbar.backgroundColor = backGroundColor
        
        snackbar.onTapBlock = { snackbar in
            snackbar.dismiss()
        }
        
        snackbar.onSwipeBlock = { (snackbar, direction) in
            
            // Change the animation type to simulate being dismissed in that direction
            if direction == .right {
                snackbar.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snackbar.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snackbar.animationType = .slideFromTopBackToTop
            } else if direction == .down {
                snackbar.animationType = .slideFromTopBackToTop
            }
            
            snackbar.dismiss()
        }
        
//        snackbar.cornerRadius = 10.0
        // Change animation duration
        snackbar.animationDuration = 0.5
        
        // Animation type
        snackbar.animationType = animation
        snackbar.show()
    }
    
    func setDefaultTextInProfile(text : String)-> UIImage{
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = CGSize(width: 100.0, height: 100.0)
        lblNameInitialize.textColor = UIColor.white
        lblNameInitialize.font = UIFont.applyCustomFont(fontName: .SFProDisplayBold, fontSize: 30)
        let nameArr = text.components(separatedBy: " ")
        
        var str : String = ""
        
        
        let firstWord = nameArr.first
        let lastWord = nameArr.last
        
        if let _ = firstWord, let ch = firstWord!.first{
            str.append(ch)
        }
        if nameArr.count > 1, let _ = lastWord,let ch = lastWord!.first{
            str.append(ch)
        }
        
        lblNameInitialize.text = str
        lblNameInitialize.textAlignment = NSTextAlignment.center
        lblNameInitialize.backgroundColor = UIColor.colorAppThemeOrange
        lblNameInitialize.layer.cornerRadius = 50.0
        
        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func compareDates(startDate : String, endDate : String, dateFormatter : String)-> (status :String,days : Int){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        let firstDate = formatter.date(from: startDate)
        let secondDate = formatter.date(from: endDate)
        
        if firstDate?.compare(secondDate!) == .orderedDescending {
            print("First Date is greater then second date")
            return (DateCompareStatus.invalid.rawValue,0)
        }
        else if firstDate?.compare(secondDate!) == .orderedAscending {
            print("First Date is smaller then second date")
            return (DateCompareStatus.valid.rawValue,(self.getTimeDifferentFromDates(firstDate: startDate, endDate: endDate,dateFormat: dateFormatter).days+1))
        }
        else if firstDate?.compare(secondDate!) == .orderedSame {
            print("Both dates are same")
            return (DateCompareStatus.same.rawValue,1)
        }
        else{
            return (DateCompareStatus.undefined.rawValue,0)
        }
    }
    
    func compareDateOrderWithCurrentDate(startDate : String, dateFormatter : String)-> (status :String,days : Int){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        let firstDate = formatter.date(from: startDate)
        let secondDate = formatter.date(from: formatter.string(from: Date()))
        
        if firstDate?.compare(secondDate!) == .orderedDescending {
            print("First Date is greater then second date")
            return (DateCompareStatus.invalid.rawValue,0)
        }
        else if firstDate?.compare(secondDate!) == .orderedAscending {
            print("First Date is smaller then second date")
            return (DateCompareStatus.valid.rawValue,(self.getTimeDifferentFromDates(firstDate: startDate,dateFormat: dateFormatter).days+1))
        }
        else if firstDate?.compare(secondDate!) == .orderedSame {
            print("Both dates are same")
            return (DateCompareStatus.same.rawValue,1)
        }
        else{
            return (DateCompareStatus.undefined.rawValue,0)
        }
    }
}
