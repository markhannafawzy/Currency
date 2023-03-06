//
//  CDConversion+CoreDataProperties.swift
//  
//
//  Created by Mark Hanna on 04/03/2023.
//
//

import Foundation
import CoreData


extension CDConversion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDConversion> {
        return NSFetchRequest<CDConversion>(entityName: "CDConversion")
    }

    @NSManaged public var amount: Double
    @NSManaged public var timestamp: Int32
    @NSManaged public var result: Double
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var createdAt: Date?

}
