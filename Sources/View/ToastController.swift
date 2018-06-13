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
    
    /// Returns the toast view of the toast controller.
    public var toastView: ToastView! {
        return view as! ToastView
    }
    
    public override var modalTransitionStyle: UIModalTransitionStyle {
        get {
            return super.modalTransitionStyle
        }
        set { }
    }
    
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
