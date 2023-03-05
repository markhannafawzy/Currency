//
//  GeneralUtils.swift
//  MedicalAppPrep
//
//  Created by Mark Hanna on 8/19/19.
//

import Foundation
import UIKit

class GeneralUtils {
    
    class func getFormattedPrice(price: Int) -> String {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: UserDefaultsUtil.getLang() ?? "ar")
        
        if let priceStr = formatter.string(from: NSNumber(integerLiteral: price)) {
            let price = "\(priceStr) " + "sr".localized
            return price
        }
        
        return "\(price)"
    }
    
    class func getFormattedPrice(price: Double) -> String {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: UserDefaultsUtil.getLang() ?? "ar")
        
        if let priceStr = formatter.string(from: NSNumber(value: price)) {
            let price = "\(priceStr) " + "sr".localized
            return price
        }
        
        return "\(price)"
    }
    
    class func getFormattedPriceRange(min: Int, max: Int) -> String {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: UserDefaultsUtil.getLang() ?? "ar")
        
        if let minStr = formatter.string(from: NSNumber(integerLiteral: min)),
            let maxStr = formatter.string(from: NSNumber(integerLiteral: max)) {
            let price =  "\(minStr) " + "sr".localized + " - \(maxStr) " + "sr".localized
            return price
        }
        
        return "\(min) - \(max)"
    }
    
    class func getLocalizedNumber(num: Int) -> String {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: UserDefaultsUtil.getLang() ?? "ar")
        
        if let numStr = formatter.string(from: NSNumber(integerLiteral: num)) {
            return numStr
        }
        
        return "\(num)"
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                print(try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:])
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    class func checkWebSitePrefix(webSiteUrl: String) -> String {
        
        if webSiteUrl.isEmpty {
            return ""
        } else {
            if (webSiteUrl.hasPrefix("http")) || (webSiteUrl.hasPrefix("https")) {
                return webSiteUrl
            } else {
                return "http://\(webSiteUrl)"
            }
        }
    }
    
    class func readPropertyList(urlType: String) -> String {

        var format = PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: String] = [:]

        let plistPath: String? = Bundle.main.path(forResource: "urlsList", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)! //the data in XML format
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                   options: .mutableContainersAndLeaves,
                                                                   format: &format) as! [String: String]

            if let plistURLType = plistData[urlType] {
                if urlType == "baseUrl" || urlType == "contentURL" || urlType == "payfortDevelopmentCred" {
                    return plistURLType

                } else if urlType == "privacyPolicy" || urlType == "contactUs" || urlType == "aboutUs" ||
                    urlType == "advertiseWithUs" ||  urlType == "agreement" || urlType ==  "refundsAndExchanges" ||
                    urlType ==  "deliveryPolicy" {

                    var  completePath: String = "\(plistData["baseUrl"]!)/\(plistURLType)"

                    return completePath

                } else {
                    let completePath = "\(plistData["baseAPIUrl"]!)/\(plistURLType)"
                    print(completePath)
                    return completePath
                }
            }

            print("Error formatting url")
            return ""

        } catch { // error condition
            print("Error reading plist")
            return ""
        }
    }
    
    class func convertArrayToString(idsArray: [String]) -> String {
        let stringRepresentation = idsArray.joined(separator: ", ")
        return stringRepresentation
    }
    
    class func getFileName(from: String) -> String {
        if let url = URL(string: from) {
            return url.lastPathComponent
        }
        return ""
    }
    
    class func getStreamingUrl(base: String, file: String, fileExtension: String) -> String {
        return "\(base)\(file)\(fileExtension)"
    }
    
    class func getPathParamUrl(urlType: String, pathParam: Any) -> String {
        let urlPath = readPropertyList(urlType: urlType)
        return "\(urlPath)/\(pathParam)"
    }
    
    class func editURLWithParam( url :inout String, parameters: [String: String]) {
        if parameters.count > 0 {
            url += "?"
            for param in parameters {
                url += param.key
                url += "="
                url += param.value
                url += "&"
            }
            url.removeLast()
        }
    }
}
