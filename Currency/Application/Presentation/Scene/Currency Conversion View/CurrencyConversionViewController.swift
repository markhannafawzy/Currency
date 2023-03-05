//
//  CurrencyConversionViewController.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class CurrencyConversionViewController: ViewController, View {
    
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    var viewModel: CurrencyConversionViewModel!
    let selectedSymbol: PublishRelay<LookupViewModel> = PublishRelay<LookupViewModel>()
    let buttonTitleUpdated: PublishRelay<SelectedAction> = PublishRelay<SelectedAction>()
    override func setupUI() {
        super.setupUI()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        let viewDidLoad = Driver.merge(Observable.just(Void()).emptyDriverIfError())
        let fromTFEditingChanged: Driver<String> = fromTF.textFieldEditingChangedEventAsDriver()
        let toTFEditingChanged: Driver<String> = toTF.textFieldEditingChangedEventAsDriver()
        
        let detailsButtonTrigger = self.detailsButton.rx.tap.emptyDriverIfError()
              
        let symbolTrigger: Driver<SelectedAction> = Driver.merge(self.fromButton.rx.tap.map{ _ in return .fromSelection }.emptyDriverIfError(), self.toButton.rx.tap.map{ _ in return .toSelection }.emptyDriverIfError())
        
                
        let fromTextFieldEvents: Driver<(amount: String, selectedAction: SelectedAction)> = Driver.merge(self.fromTF.rx.controlEvent(UIControl.Event.editingChanged).debounce(.milliseconds(500), scheduler: MainScheduler.instance).emptyDriverIfError(), fromTF.rx.controlEvent([.editingDidEndOnExit]).emptyDriverIfError()).map { return (amount: self.fromTF.text ?? "", selectedAction: .fromSelection) }
        
        
        let toTextFieldEvents: Driver<(amount: String, selectedAction: SelectedAction)> = Driver.merge(self.toTF.rx.controlEvent(UIControl.Event.editingChanged).debounce(.milliseconds(500), scheduler: MainScheduler.instance).emptyDriverIfError(), toTF.rx.controlEvent([.editingDidEndOnExit]).emptyDriverIfError()).map { return (amount: self.toTF.text ?? "", selectedAction: .toSelection) }
        
        let buttonTitleUpdated: Driver<(amount: String, selectedAction: SelectedAction)> = self.buttonTitleUpdated.map {
            switch $0 {
            case .fromSelection:
                return (amount: self.fromTF.text ?? "", selectedAction: .fromSelection)
            case .toSelection:
                return (amount: self.toTF.text ?? "", selectedAction: .toSelection)
            }
        }.emptyDriverIfError()
        
        let convertTrigger = Driver.merge(fromTextFieldEvents, toTextFieldEvents, buttonTitleUpdated).map { [weak self] (amount: String, selectedAction: SelectedAction) in return ConvertQuery(amount: amount, from: self?.fromButton.title(for: .normal) ?? "", to: self?.toButton.title(for: .normal) ?? "", selectedAction: selectedAction) }
        
        
        let input = CurrencyConversionViewModel.Input(loadTrigger: viewDidLoad, detailsButtonTrigger: detailsButtonTrigger, fromTFEditingChanged: fromTFEditingChanged, toTFEditingChanged: toTFEditingChanged, symbolsTigger: symbolTrigger, selectedSymbolViewModel: selectedSymbol.emptyDriverIfError(), convertTrigger: convertTrigger)
        
        let output = viewModel.transform(input: input)
        output.indicator.drive().disposed(by: bag)
        
        output.error.drive(onNext: { [weak self] errorItem in
            switch errorItem.requestType {
            case .symbols:
                break
            case .convert:
                break
            }
        }).disposed(by: bag)
        
        
        output.symbolsLoaded.drive(onNext: { [weak self] symbol in
            self?.fromButton.setTitle(symbol, for: .normal)
            self?.toButton.setTitle(symbol, for: .normal)
        }).disposed(by: bag)
        
        output.symbol.drive(onNext: { [weak self] symbol in
            switch symbol.selectedAction {
            case .fromSelection:
                self?.fromButton.setTitle(symbol.title, for: .normal)
                self?.buttonTitleUpdated.accept(.fromSelection)
                break
            case .toSelection:
                self?.toButton.setTitle(symbol.title, for: .normal)
                self?.buttonTitleUpdated.accept(.toSelection)
                break
            }
        }).disposed(by: bag)
        output.symbolsDialogShown.drive().disposed(by: bag)
        
        output.conversioResult.drive(onNext: { [weak self] result in
            switch result.selectedAction {
            case .fromSelection:
                self?.toTF.text = result.resultAmount
            case .toSelection:
                self?.fromTF.text = result.resultAmount
            }
        }).disposed(by: bag)
        output.detailsButtonTapped.drive().disposed(by: bag)
    }
    
}

// MARK: - Setup UI
extension CurrencyConversionViewController {
    
}

struct ConvertQuery {
    let amount: String
    let from: String
    let to: String
    let selectedAction: SelectedAction
}
