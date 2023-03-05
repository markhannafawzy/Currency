//
//  CurrencyRepository.swift
//  Currency
//
//  Created by Mark Hanna on 04/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift

final class CurrencyRepositoryImplementation<RemoteServiceType, LocalServiceType>: CurrencyRepository where RemoteServiceType: NetworkRouter, RemoteServiceType.Target == CurrencyTarget , LocalServiceType: AbstractLocalDataSource, LocalServiceType.T == Conversion {
    
    private let remoteService: RemoteServiceType
    private let localService: LocalServiceType
    
    init(remoteService: RemoteServiceType, localService: LocalServiceType) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func symbols() -> Observable<SymbolsResponse> {
        remoteService.request(.symbols)
    }
    
    func convert(to: String, from: String, amount: String) -> Observable<Conversion> {
        remoteService.request(.convert(to: to, from: from, amount: amount)).flatMapLatest { conversion in
            self.localService.save(entity: conversion).map { _ in return conversion }
        }
//            .filter { conversion in
//            guard let timestamp = conversion.info?.timestamp else { return false }
//            let dateObject = Date(timeIntervalSince1970: Double(timestamp))
//            guard let numberOfDaysInDifference = Date().days(sinceDate: dateObject) else { return false }
//            return numberOfDaysInDifference > 3
//        }
    }
    
    func conversions() -> Observable<[Conversion]> {
        return self.deleteConversionsMoreThanThreeDays().flatMapLatest { [weak self] _ in
            return self?.localService.query(with: nil, sortDescriptors: [Conversion.CoreDataType.createdAtAttr.descending()]) ?? Observable<[Conversion]>.empty()
        }
    }
    
    func deleteConversionsMoreThanThreeDays() -> Observable<Void> {
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 3, to: dateFrom)
        
        let fromPredicate = NSPredicate(format: "%@ >= %K", dateFrom as NSDate, #keyPath(CDConversion.createdAt))
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(CDConversion.createdAt), dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        return localService.batchDelete(with: datePredicate)
    }
}
