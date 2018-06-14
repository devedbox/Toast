//
//  ToastController.swift
//  Toast
//
//  Created by devedbox on 2018/6/13.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit
import Foundation

public final class ToastController: UIViewController {
    
    public struct Content {
        
    }
    
    /// Returns the toast view of the toast controller.
    public var toastView: ToastView! {
        return view as! ToastView
    }
    // Overrides modal transition style.
    public override var modalTransitionStyle: UIModalTransitionStyle {
        get {
            return super.modalTransitionStyle
        }
        set { }
    }
    // Overrides modal presentation style.
    public override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return super.modalPresentationStyle
        }
        set { }
    }
    
    // MARK: Init.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()
    }
    
    public convenience init(components: [UIView & ToastComponent]) {
        self.init(nibName: nil, bundle: nil)
        toastView.set(components: components)
    }
    
    private func _init() {
        super.modalTransitionStyle = .crossDissolve
        super.modalPresentationStyle = .overCurrentContext
    }
    
    // MARK: Overrides.
    
    public override func loadView() {
        super.loadView()
        
        view = ToastView(frame: .zero)
    }
}

// MARK: - Public.

extension ToastController {
    /// Show the toast controller in a given view controller by presenting the toast as a modal view controller.
    ///
    /// - Parameter viewController: The view controller to show in.
    /// - Parameter animated: Indicates showing the view controller with animation or not.
    /// - Parameter completion: The completion call back closure when showing processing finished.
    ///
    public func show(in viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
    }
    
    /// Dismiss the toast controller itself if the toast controller is showing.
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
}
