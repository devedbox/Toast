//
//  ToastController.swift
//  Toast
//
//  Created by devedbox on 2018/6/13.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit
import Foundation
import Dispatch

public final class ToastController: UIViewController {
    
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
    public func show(in viewController: UIViewController, animated: Bool, duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
        
        if let duration = duration {
            dismiss(animated: animated, after: duration)
        }
    }
    
    /// Dismiss the toast controller after the given delay time interval.
    ///
    /// - Parameter animated: Indicates the toast showing with or without animation.
    /// - Parameter delay: The time inverval the toast will dismiss after.
    /// - Parameter completion: A completion call back closure when the toast has being dismissed.
    ///
    public func dismiss(animated: Bool, after delay: TimeInterval, completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(animated: animated, completion: completion)
        }
    }
    
    /// Dismiss the toast controller itself if the toast controller is showing.
    ///
    /// - Parameter animated: Indicates the toast showing with or without animation.
    /// - Parameter completion: A completion call back closure when the toast has being dismissed.
    ///
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
}

// MARK: - Components.

extension ToastController {
    /// Return a message toast contains title and detail messages.
    ///
    /// - Parameter activityIndicator: The activity indicator of `ToastView.Component.ActivityIndicator`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: An activity toast.
    public class func message(_ message: String, detail: String? = nil) -> ToastController {
        let components: [(UIView & ToastComponent)?] =
            [message.isEmpty ? nil : ToastView.Component.Label.title(message),
             (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)].map { $0?.layout.insets.top = 0.0; return $0 }
        
        return ToastController(components: components.compactMap { $0 })
    }
    
    /// Return a activity toast contains an activity indicator, title and detail messages.
    ///
    /// - Parameter activityIndicator: The activity indicator of `ToastView.Component.ActivityIndicator`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: An activity toast.
    public class func activity(_ activityIndicator: ToastView.Component.ActivityIndicator = .normal, message: String, detail: String? = nil) -> ToastController {
        activityIndicator.isAnimating = true
        
        let components: [(UIView & ToastComponent)?] =
            [message.isEmpty ? nil : ToastView.Component.Label.title(message),
             (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)].map { $0?.layout.insets.top = 0.0; return $0 }
        
        return ToastController(components: [activityIndicator] + components.compactMap { $0 })
    }
    
    /// Returns a progress toast contains a progress indicator, title and detail message.
    ///
    /// - Parameter progressIndicator: The progress indicator of `ToastView.Component.ProgressIndicator`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A progress toast.
    public class func progress(_ progressIndicator: ToastView.Component.ProgressIndicator = .pie, message: String, detail: String? = nil) -> ToastController {
        let components: [(UIView & ToastComponent)?] =
            [message.isEmpty ? nil : ToastView.Component.Label.title(message),
             (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)].map { $0?.layout.insets.top = 0.0; return $0 }
        
        return ToastController(components: [progressIndicator] + components.compactMap { $0 })
    }
    
    /// Returns a result toast contains a result indicator, title and detail message.
    ///
    /// - Parameter resultIndicator: The progress indicator of `ToastView.Component.ProgressIndicator`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A result toast.
    public class func result(_ resultIndicator: ToastView.Component.ResultIndicator = .success, message: String, detail: String? = nil) -> ToastController {
        let components: [(UIView & ToastComponent)?] =
            [message.isEmpty ? nil : ToastView.Component.Label.title(message),
             (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)].map { $0?.layout.insets.top = 0.0; return $0 }
        
        return ToastController(components: [resultIndicator] + components.compactMap { $0 })
    }
}
