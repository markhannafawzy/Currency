//
//  Extentions.swift
//
//  Created by Mark Hanna on 8/19/19.
//

import Foundation
import UIKit


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func matches(_ regex: String, input: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension String {
    
    var isArabic: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }
    
    func determineAlignment() -> NSTextAlignment {
        return self.isArabic ? .right : .left
    }
}

extension UINavigationController {
    
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool = true,
                            completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToRootViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
        popToViewController(vc, animated: animated)
      }
    }
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "0"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}

extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
}

public extension String {
    
    var isEmptyStr: Bool {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
extension Encodable {

    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        let data = try? encoder.encode(self)
        let object = try? JSONSerialization.jsonObject(with: data ?? Data())
        guard let json = object as? [String: Any] else {
//            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
//            throw DecodingError.typeMismatch(type(of: object), context)
            return nil
        }
        return json
    }
}
