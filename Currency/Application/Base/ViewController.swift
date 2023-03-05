//
//  ViewController.swift
//  Currency
//
//  Created by Mark Hanna. on 12/16/18.
//  Copyright © 2018 Mark Hanna. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    var bag: DisposeBag!
    var navi: NavigationController? {
        return navigationController as? NavigationController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bag = DisposeBag()
        DispatchQueue.main.async { [weak self] in
            self?.setupUI()
            self?.bindViewModel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    func bindViewModel() {}

    func setupUI() {
        view.backgroundColor = App.Theme.current.package.viewBackground
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        bag = DisposeBag()
//    }
    
    deinit {
        bag = DisposeBag()
    }
}
