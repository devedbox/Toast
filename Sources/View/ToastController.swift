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
    /// Is showing or dismissing with animation.
    private var _isAnimated: Bool?
    /// The animator of the toast controller.
    public var animator: ToastAnimator = .none
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
    
    /// Overrides init with the given parameters.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._init()
    }
    
    /// Overrides to init with a decoder.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._init()
    }
    
    /// Creates an insance of `ToastController` with the given components of `[UIView & ToastComponent]`.
    ///
    /// - Parameter components: The components shows in the content view of the toast view.
    /// - Returns: A toast controller.
    ///
    public convenience init(components: [UIView & ToastComponent]) {
        self.init(nibName: nil, bundle: nil)
        toastView.set(components: components)
    }
    
    /// Do common initialize.
    private func _init() {
        super.modalTransitionStyle = .crossDissolve
        super.modalPresentationStyle = .overCurrentContext
    }
    
    // MARK: Overrides.
    
    /// Load view with the instance of `ToastView`.
    public override func loadView() {
        super.loadView()
        
        view = ToastView(frame: .zero)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if case let isAnimated? = _isAnimated, isAnimated {
            animator.animation(toastView, true, isAnimated)
            _isAnimated = nil
        }
    }
}

// MARK: - Public.

extension ToastController {
    /// Progress value of the toast if any. Get the value of progress will return the first progress indicator's value of
    /// the toast if any, and set the value of progress will set each progress indicator of the toast.
    public var progress: CGFloat? {
        get {
            return toastView.contentView.subviews.compactMap { $0 as? ToastView.Component.ProgressIndicator }.first?.progress
        }
        set {
            toastView.contentView.subviews.forEach { ($0 as? ToastView.Component.ProgressIndicator)?.progress = newValue ?? 0.0 }
        }
    }
}

extension ToastController {
    /// Show the toast controller in a given view controller by presenting the toast as a modal view controller.
    ///
    /// - Parameter viewController: The view controller to show in.
    /// - Parameter animated: Indicates showing the view controller with animation or not.
    /// - Parameter completion: The completion call back closure when showing processing finished.
    ///
    public func show(in viewController: UIViewController, animated: Bool, duration: TimeInterval? = nil, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
        _isAnimated = animated
        
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
        animator.animation(toastView, false, flag)
        
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
        let components: [(UIView & ToastComponent)] = [
            message.isEmpty ? nil : ToastView.Component.Label.title(message),
            (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)
        ].compactMap { $0 }
        
        if components.count == 2 {
            components.first?.layout.insets.bottom = 0.0
            components.last?.layout.insets.top = 8.0
        }
        
        return ToastController(components: components)
    }
    
    /// Return a activity toast contains an activity indicator, title and detail messages.
    ///
    /// - Parameter activityIndicatorStyle: The activity indicator style of `ToastView.Component.ActivityIndicatorStyle`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: An activity toast.
    public class func activity(_ activityIndicatorStyle: ToastView.Component.ActivityIndicator.Style = .normal,
                               message: String,
                               detail: String? = nil) -> ToastController {
        
        var activityIndicator: ToastView.Component.ActivityIndicator
        
        switch activityIndicatorStyle {
        case .normal:
            activityIndicator = .normal
        case .breachedRing:
            activityIndicator = .breachedRing
        }
        
        activityIndicator.isAnimating = true
        activityIndicator.layout.insets.bottom = 0.0
        
        let components: [(UIView & ToastComponent)?] = [activityIndicator] + _labels(with: message, detail: detail)
        
        return ToastController(components: components.compactMap { $0 })
    }
    
    /// Returns a progress toast contains a progress indicator, title and detail message.
    ///
    /// - Parameter progressIndicatorStyle: The progress indicator style of `ToastView.Component.ProgressIndicator.Style`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A progress toast.
    public class func progress(_ progressIndicatorStyle: ToastView.Component.ProgressIndicator.Style = .pie,
                               message: String,
                               detail: String? = nil) -> ToastController {
        
        var progressIndicator: ToastView.Component.ProgressIndicator
        
        switch progressIndicatorStyle {
        case .horizontalBar:
            progressIndicator = .horizontalBar
        case .pie:
            progressIndicator = .pie
        case .ring:
            progressIndicator = .ring
        case .colouredBar:
            progressIndicator = .colouredBar
        }
        
        progressIndicator.layout.insets.bottom = 0.0
        
        let components: [(UIView & ToastComponent)?] = [progressIndicator] + _labels(with: message, detail: detail)
        
        return ToastController(components: components.compactMap { $0 })
    }
    
    /// Returns a result toast contains a result indicator, title and detail message.
    ///
    /// - Parameter resultIndicatorStyle: The result indicator style of `ToastView.Component.ProgressIndicator.Style`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A result toast.
    public class func result(_ resultIndicatorStyle: ToastView.Component.ResultIndicator.Style = .success,
                             message: String,
                             detail: String? = nil) -> ToastController {
        
        var resultIndicator: ToastView.Component.ResultIndicator
        
        switch resultIndicatorStyle {
        case .success:
            resultIndicator = .success
        case .error:
            resultIndicator = .error
        }
        
        resultIndicator.layout.insets.bottom = 0.0
        
        let components: [(UIView & ToastComponent)?] = [resultIndicator] + _labels(with: message, detail: detail)
        
        return ToastController(components: components.compactMap { $0 })
    }
}

// MARK: - Private.

extension ToastController {
    /// Returns the message label and detail message label with a closing margin insets.
    private class func _labels(with message: String, detail: String?) -> [ToastView.Component.Label?] {
        let titleLabel = message.isEmpty ? nil : ToastView.Component.Label.title(message)
        titleLabel?.layout.insets.top = 8.0
        
        let detailLabel = (detail?.isEmpty ?? true) ? nil : ToastView.Component.Label.detail(detail!)
        detailLabel?.layout.insets.top = 8.0
        
        if detailLabel != nil {
            titleLabel?.layout.insets.bottom = 0.0
        }
        
        return [titleLabel, detailLabel]
    }
}
