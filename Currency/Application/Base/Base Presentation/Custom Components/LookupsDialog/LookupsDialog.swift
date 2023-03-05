//
//  LookupsDialog.swift
//  Currency
//
//  Created by Mark Hanna on 11/01/2023.
//  Copyright © 2023 Mark Hanna. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PureLayout

class LookupsDialog<Cell: BaseDialogCell<CellViewModel>, CellViewModel: BaseDialogViewModel<Item>, Item>: UIView, View, UITableViewDelegate {

    var containerView: UIView = UIView()
    var titleLabel: UILabel = UILabel()
    var noDataFoundLabel: UILabel = UILabel()
    var tableView: AutomaticIntrinsicTableView = AutomaticIntrinsicTableView(frame: .zero, style: .plain)
    var disposeBag: DisposeBag? = DisposeBag()
    
    var noDataView: UIView = UIView()
    var closeBtn: UIButton = UIButton()
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        self.initializeView()
        self.setupUI()
    }
    
    func initializeView() {
        let screenSize = UIScreen.main.bounds
        
        //Container View
        containerView.frame = CGRect(x: 0, y: 0, width: screenSize.width * 0.9, height: 358)
        containerView.backgroundColor = .white
        containerView.cornerRadius = 10
        addSubview(self.containerView)
        containerView.autoMatch(.width, to: .width, of: self, withMultiplier: 0.9)
//        containerView.autoSetDimension(.height, toSize: 358)
        containerView.autoCenterInSuperview()
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = App.Theme.current.package.lookupsHeaderLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
        titleLabel.autoPinEdge(.top, to: .top, of: containerView, withOffset: 16)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(999), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .vertical)
        
//        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        
        //Close Button
        closeBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        closeBtn.setImage(UIImage(named:"ios_close_icon"), for: .normal)
        
        containerView.addSubview(closeBtn)
        closeBtn.autoSetDimension(.width, toSize: 25)
        closeBtn.autoSetDimension(.height, toSize: 25)
        closeBtn.autoPinEdge(.top, to: .top, of: containerView, withOffset: 12)
        closeBtn.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: -16)
        
        //No Data View
        containerView.addSubview(noDataView)
        noDataView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 16)
        noDataView.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: 12)
        noDataView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: -12)
        noDataView.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -12)
        containerView.sendSubviewToBack(noDataView)
        
        //No Data Found Label
        noDataFoundLabel.text = "retryDescriptionNoDataFound".localized
        noDataFoundLabel.textColor = App.Theme.current.package.noDataFoundLabel
        noDataView.addSubview(noDataFoundLabel)
        noDataFoundLabel.autoCenterInSuperview()
        
        //TableView
        containerView.addSubview(tableView)
        tableView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 12)
        tableView.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: 12)
        tableView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: -12)
        tableView.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: -12)
        
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        containerView.bringSubviewToFront(closeBtn)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: LookupsDialogViewModel<CellViewModel, Item>! {
        didSet {
            guard viewModel != nil else { return }
            self.bind()
        }
    }

    func setupUI() {
        setupTableView()
        closeBtn.addTarget(self, action: #selector(didClose), for: .touchUpInside)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LookupsDialog",
                     bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    fileprivate func adjustViewHeightBasedOnContent() {
        var height: CGFloat!
        if self.tableView.contentSize.height < (UIScreen.main.bounds.size.height * 0.8) {
            height = self.tableView.contentSize.height + 70
        } else {
            height = UIScreen.main.bounds.size.height * 0.8
        }
        containerView.autoSetDimension(.height, toSize: height)
    }
    
    func bind() {
        let cellLoaded = Observable.just(Void()).emptyDriverIfError()
        let input = LookupsDialogViewModel<CellViewModel, Item>.Input(loadTrigger: cellLoaded)
        let output = viewModel.transform(input: input)
        output.dialogTitle.drive(self.titleLabel.rx.text).disposed(by: disposeBag ?? DisposeBag())
        output.lookupViewModels.drive(tableView.rx.items(cellIdentifier: Cell.identify, cellType: Cell.self)) { (_, viewModel, cell) in
            cell.viewModel = viewModel
        }
        .disposed(by: disposeBag ?? DisposeBag())
        
        output.numberOfItems.drive(onNext: { [weak self] numOfItems in
            if numOfItems == 0 {
                self?.noDataView.isHidden = false
                self?.containerView.bringSubviewToFront((self?.noDataView)!)
            }
            self?.tableView.reloadData()
            self?.tableView.invalidateIntrinsicContentSize()
            self?.tableView.layoutIfNeeded()
            self?.adjustViewHeightBasedOnContent()
        }).disposed(by: disposeBag ?? DisposeBag())
//        self.viewHeightConstraint.constant = height
    }
    
    @objc func didClose(sender: UIButton!) {
        self.disposeBag = nil
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag ?? DisposeBag())
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = App.Theme.current.package.viewBackground
        tableView.register(UINib(nibName: Cell.identify, bundle: nil), forCellReuseIdentifier: Cell.identify)
        //        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

class BaseDialogCell<CellViewModel>: TableViewCell {

    var viewModel: CellViewModel! {
        didSet {
            guard viewModel != nil else { return }
            self.bind(self.viewModel)
        }
    }

    override func setupUI() {
        super.setupUI()
    }

    func bind(_ viewModel: CellViewModel) {
    }
}
