//
//  UIExtentions.swift
//
//  Created by Mark Hanna on 8/20/19.
//  Copyright © 2019 saragn. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import PureLayout

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable var viewBorderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var viewBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

}

//MARK: - Retry View
extension UIView {

    func showLookupsDialog<Cell: BaseDialogCell<CellViewModel>, CellViewModel: BaseDialogViewModel<Item>, Item>(title: String? = nil, lookupItems: [Item]) -> LookupsDialog<Cell, CellViewModel, Item> {
        
//        let lookupsDialog = LookupsDialog<Cell, CellViewModel, Item>.instanceFromNib() as! LookupsDialog<Cell, CellViewModel, Item>
        let lookupsDialog = LookupsDialog<Cell, CellViewModel, Item>()
        
        lookupsDialog.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lookupsDialog.translatesAutoresizingMaskIntoConstraints = true
        let optionsDialogViewModel = LookupsDialogViewModel<CellViewModel, Item>(title: title ?? "", lookupItems: lookupItems)
        lookupsDialog.viewModel = optionsDialogViewModel
        lookupsDialog.frame = self.frame
        self.addSubview(lookupsDialog)
        self.bringSubviewToFront(lookupsDialog)
        lookupsDialog.autoPinEdgesToSuperviewEdges()
        lookupsDialog.autoMatch(.width, to: .width, of: self)
        lookupsDialog.autoMatch(.height, to: .height, of: self)
        lookupsDialog.layoutIfNeeded()
        return lookupsDialog
    }
    
    @discardableResult
    func hideLookupsDialog<Cell: BaseDialogCell<CellViewModel>, CellViewModel: BaseDialogViewModel<Item>, Item>() -> LookupsDialog<Cell, CellViewModel, Item>? {
        if let lookupsDialog = self.subviews.first(where: { $0 is LookupsDialog<Cell, CellViewModel, Item> }) {
            lookupsDialog.removeFromSuperview()
            return lookupsDialog as? LookupsDialog<Cell, CellViewModel, Item>
        }
        return nil
    }
}

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
        completion?()
    }
    
}

extension UIButton {
    
    @IBInspectable
    var underLineText: Bool {
        get {
            return true
            
        } set {
            let localized = (self.titleLabel?.text ?? "").localized
            let attributedString = NSAttributedString(string: localized,
                                                      attributes: [.underlineStyle: 1.0])
            setAttributedTitle(attributedString, for: .normal)
        }
    }
}


extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

public extension UIViewController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let viewcontroller = UIViewController()
        viewcontroller.view.backgroundColor = .clear
        win.rootViewController = viewcontroller
        win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        viewcontroller.present(self, animated: true, completion: nil)
    }
}

extension UITextView {
    
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {

        if let bgColor = self.backgroundColor, bgColor != UIColor.clear {
            self.layer.backgroundColor = bgColor.cgColor
        } else {
            self.layer.backgroundColor = UIColor.white.cgColor
        }
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: height)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func addBorderWithColor(color: UIColor) {
        viewBorderWidth = 0.5
        viewBorderColor = color
    }
    
}

extension UITableViewCell {
	func wiggle() {
		let wiggleAnimation = CABasicAnimation(keyPath: "position")
		wiggleAnimation.duration = 0.04
		wiggleAnimation.repeatCount = 5
		wiggleAnimation.autoreverses = true
		wiggleAnimation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
		wiggleAnimation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
		layer.add(wiggleAnimation, forKey: "position")
		print("wiggle() called")
	}
}

extension UIView {
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

@objc extension UITextView {
    
    open var rightView: UIView? {
        get {
            return UIImageView()
            
        } set {
            if let rightView = self.rightView {
                rightView.removeFromSuperview()
            }
            if let newValue = newValue {
                newValue.frame = CGRect(x: frame.maxX - 85, y: 15, width: 25, height: 25)
                addSubview(newValue)
            }
        }
    }
}

extension UITextField {
    
    func textFieldEditingChangedEventAsDriver() -> Driver<String> {
        self.rx.controlEvent(UIControl.Event.editingChanged).map{ _ in
            return self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }.emptyDriverIfError()
    }
}


extension UIImageView {
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return .zero
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
