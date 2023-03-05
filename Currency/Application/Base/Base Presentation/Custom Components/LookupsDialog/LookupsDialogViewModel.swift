//
//  LookupsDialogViewModel.swift
//  Currency
//
//  Created by Mark Hanna on 11/01/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LookupsDialogViewModel<CellViewModel: BaseDialogViewModel<Item>, Item>: ViewModel {

    var lookupItems: [Item]
    
    var coordinator: LookupsCoordinator?
    var title: String!
    init(title: String, lookupItems: [Item]) {
        self.lookupItems = lookupItems
        self.title = title
    }

    func transform(input: Input) -> Output {
        let dialogTitle:Driver<String> = input.loadTrigger.compactMap { [weak self] _ in self?.title ?? "" }
        let lookupViewModels: Driver<[CellViewModel]> = input.loadTrigger
            .flatMapLatest { [weak self] _ -> Driver<[Item]> in Observable.just(self?.lookupItems ?? []).emptyDriverIfError() }
            .map { lookupItems -> [CellViewModel] in return lookupItems.map { CellViewModel(lookupItem: $0) } }

        let numberOfItems = lookupViewModels.map { $0.count }
        let output = Output(dialogTitle: dialogTitle, lookupViewModels: lookupViewModels, numberOfItems: numberOfItems)
        return output
    }
}

// MARK: - Define
extension LookupsDialogViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let dialogTitle:Driver<String>
        let lookupViewModels: Driver<[CellViewModel]>
        let numberOfItems: Driver<Int>
    }
}

class BaseDialogViewModel<Item> {

    var lookupItem: Item!

    required init(lookupItem: Item) {
        self.lookupItem = lookupItem
    }
}


