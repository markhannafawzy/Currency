//
//  HistoryViewController.swift
//  Currency
//
//  Created by Mark Hanna on 05/03/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class HistoryViewController: ViewController, View {
    
    @IBOutlet weak var tableView: AutomaticIntrinsicTableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    var viewModel: HistoryViewModel!
    
    override func setupUI() {
        super.setupUI()
        setupTableView()
    }

    override func bindViewModel() {
        super.bindViewModel()
        let viewDidLoad = Driver.merge(Observable.just(Void()).emptyDriverIfError())
        
        let input = HistoryViewModel.Input(loadTrigger: viewDidLoad, backButtonClicked: self.backButton.rx.tap.emptyDriverIfError())
        
        let output = viewModel.transform(input: input)
        
        output.indicator.drive().disposed(by: bag)
        output.error.drive().disposed(by: bag)
        
        
        output.historyConversionViewModels.drive(tableView.rx.items(cellIdentifier: HistoryConversionTableViewCell.identify, cellType: HistoryConversionTableViewCell.self)) { (_, viewModel, cell) in
            cell.viewModel = viewModel
            }
            .disposed(by: bag)
        output.backButtonTapped.drive().disposed(by: bag)
    }
}

// MARK: - Setup UI
extension HistoryViewController {
    private func setupTableView() {
        self.tableView.delegate = nil
         self.tableView.dataSource = nil
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = App.Theme.current.package.viewBackground
        tableView.register(UINib(nibName: HistoryConversionTableViewCell.identify, bundle: nil), forCellReuseIdentifier: HistoryConversionTableViewCell.identify)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }
}
//MARK: - TableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}
