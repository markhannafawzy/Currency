//
//  CDConversion+Ext.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

extension CDConversion {
    static var toAttr: Attribute<String> { return Attribute("to")}
    static var fromAttr: Attribute<String> { return Attribute("from")}
    static var amountAttr: Attribute<String> { return Attribute("amount")}
    static var resultAttr: Attribute<Double> { return Attribute("result")}
    static var timestampAttr: Attribute<Int32> { return Attribute("timestamp")}
    static var createdAtAttr: Attribute<Date> { return Attribute("createdAt")}
}

extension CDConversion: DomainConvertibleType {
    func asDomain() -> Conversion {
        return Conversion(to: to ?? "", from: from ?? "", timestamp: Int(timestamp), amount: amount, result: result)
    }
}

extension CDConversion: Persistable {
    static var entityName: String {
        return "CDConversion"
    }
}

extension Conversion: CoreDataRepresentable {
    var uid: Int32 {
        Int32(info?.timestamp ?? 0)
    }
    
    typealias CoreDataType = CDConversion
    
    func update(entity: CDConversion) {
        entity.createdAt = Date(timeIntervalSince1970: Double(info?.timestamp ?? 0))
        entity.timestamp = Int32(info?.timestamp ?? 0)
        entity.amount = query?.amount ?? 0.0
        entity.result = result ?? 0.0
        entity.from = query?.from ?? ""
        entity.to = query?.to ?? ""
    }
}

extension Conversion: Equatable {
    public static func == (lhs: Conversion, rhs: Conversion) -> Bool {
        return lhs.info?.timestamp == rhs.info?.timestamp
    }
}
