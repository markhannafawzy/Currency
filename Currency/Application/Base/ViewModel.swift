//
//  ViewModel.swift
//  Common
//
//  Created by Mark Hanna. on 12/9/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype CoordinatorType: Coordinate

    var coordinator: CoordinatorType? { get set }

    func transform(input: Input) -> Output
}
