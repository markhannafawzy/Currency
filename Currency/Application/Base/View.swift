//
//  View.swift
//  Currency
//
//  Created by Mark Hanna. on 1/16/19.
//  Copyright © 2019 Mark Hanna. All rights reserved.
//

import UIKit

protocol View {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}
