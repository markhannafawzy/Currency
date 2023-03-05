//
//  DateUtils.swift
//
//  Created by Mark Hanna on 8/18/19.
//

import Foundation

enum DateFormat: String {
    case serverFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case fullServerFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    case fullServerFormatSingleZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case fullServerFormatMilliSec = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case serverFormatMinutesOnly = "yyyy-MM-dd'T'HH:mm:ss"
    case serverFormatNoLocal = "yyyy-MM-dd'T'00:00:00'Z'"
    case clientFormat = "yyyy-MM-dd HH:mm:ss"
    case clintFormat12hr = "yyyy-MM-dd hh:mm a"
    case eventsFormat = "dd/MM/yyyy HH:mm"
    case time12hr = "hh:mm a"
    case dayMonth = "MMM dd"
    case dayMonthShort = "MM-dd"
    case datePart = "dd-MM-yyyy"
    case datePartReversed = "yyyy-MM-dd"
    case dayPart = "dd"
    case monthPart = "MMMM"
    case datePartSlash = "dd/MM/yyyy"
    case timePart = "HH:mm:ss"
    case fullDateTime = "dd-MM-yyyy HH:mm:ss"
    case arabicDatePartsSlash = "yyyy/MM/dd"
}

class DateUtils {
    
    static private let dateFormatter = DateFormatter()
    
    // Converts date string to date object
    // currentFormat: format of the sent date string
    // currentZone: format of the sent date string zone
    class func convertStrToDate(dateString: String, currentFormat: String,
                                 currentZone: String? = nil) -> Date? {
        
        //Convert string to date object
        dateFormatter.dateFormat = currentFormat
        dateFormatter.locale = getCurrentLocale()
        
        if let timeZone = currentZone {
            dateFormatter.timeZone = TimeZone(identifier: timeZone)
        } else {
            dateFormatter.timeZone = .current
        }
        
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    class func convertStrToZeroTimeUTCDate(dateString: String) -> Date? {
        
        guard let dateStr = DateUtils.convertDateStrFormat(dateStr: dateString,
                                                           currentFormat: DateFormat.serverFormat.rawValue,
                                                           targetFormate: DateFormat.serverFormatNoLocal.rawValue) else { return nil }
        let date = DateUtils.convertStrToDate(dateString: dateStr,
                                              currentFormat: DateFormat.serverFormatNoLocal.rawValue)
        
        return date
    }
    
    class func showLocalizedStringDate(date: Date, targetFormat: String, targetZone: String? = nil) -> String {
        print(date)
        dateFormatter.dateFormat = targetFormat
        dateFormatter.locale = Locale(identifier: UserDefaultsUtil.getLang() ?? "en")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
   class func getDateAMonthBefore() -> String {
    
        let monthsToAdd = -30
        
        let newDate = Calendar.current.date(byAdding: .day,
                                            value: monthsToAdd, to: Date())
        let serverFormateString = DateUtils.convertDateToStrWithoutLocal(date: newDate!,
                                         targetFormat: DateFormat.serverFormatNoLocal.rawValue)
        
        return serverFormateString
    }
    //Converts date object to date string
    // targetFormat: format of the date string to be returned
    // targetZone: date string zone to be returned
    class func convertDateToStr(date: Date, targetFormat: String,
                                targetZone: String? = nil, locale: Locale? = nil) -> String {
        
        dateFormatter.dateFormat = targetFormat
        dateFormatter.locale = .current
        
        if let timeZone = targetZone {
            dateFormatter.timeZone = TimeZone(identifier: timeZone)
            if timeZone == "UTC" {
                dateFormatter.locale = Locale(identifier: "en")
            }
            
        } else {
            dateFormatter.timeZone = .current
            dateFormatter.locale = (locale != nil) ? locale : getCurrentLocale()
        }
        
        return dateFormatter.string(from: date)
    }
    class func convertDateToStrWithoutLocal(date: Date, targetFormat: String) -> String {
        
        dateFormatter.dateFormat = targetFormat
//        dateFormatter.locale = .current
//
//        if let timeZone = targetZone {
//            dateFormatter.timeZone = TimeZone(identifier: timeZone)
//            if timeZone == "UTC" {
//                dateFormatter.locale = Locale(identifier: "en")
//            }
//
//        } else {
//            dateFormatter.timeZone = .current
//            dateFormatter.locale = getCurrentLocale()
//        }
        
        return dateFormatter.string(from: date)
    }
    
    // Concatinates date and time parts
    class func concatenateDateAndTime(datePart: Date, timePart: Date) -> Date {
        
        let datePartStr = DateUtils.convertDateToStr(date: datePart,
                                                     targetFormat: DateFormat.datePartSlash.rawValue)
        let timePartStr = DateUtils.convertDateToStr(date: timePart,
                                                     targetFormat: DateFormat.timePart.rawValue)
        let fulDateStr = datePartStr + " " + timePartStr
        
        return DateUtils.convertStrToDate(dateString: fulDateStr,
                                          currentFormat: DateFormat.fullDateTime.rawValue)!
    }
    
    // Converts date string from format to another format
    // targetFormat: format of the date string to be returned
    // targetZone: the date zone to be returned
    class func convertDateStrFormat(dateStr: String, currentFormat: String,
                                    targetFormate: String, locale: Locale? = nil) -> String? {
        
        guard let date = DateUtils.convertStrToDate(dateString: dateStr, currentFormat: currentFormat) else { return nil }
        return DateUtils.convertDateToStr(date: date, targetFormat: targetFormate, locale: locale)
    }
    
    // Returns the current locale
    class private func getCurrentLocale() -> Locale {
        return Locale(identifier: UserDefaultsUtil.getLang() ?? "en")
//        return Locale(identifier: "en")

    }
}
