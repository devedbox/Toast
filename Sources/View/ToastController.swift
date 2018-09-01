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
    
    /// The presentation style of `ToastController`.
    public enum PresentationStyle {
        /// As a presentation view controller.
        case presented
        /// As a child view controller.
        case child
    }
    
    /// The type represents the state of the dismissing of the toast controller.
    private struct _DismissState {
        /// A boolean value indicates should wait to dismiss on the appearing of the toast controller.
        internal var isWaitingToDismissOnAppearing: Bool
        /// A boolean value indicates should dismiss the toast controller with animation.
        internal var isAnimatingToDismissOnAppearing: Bool
        /// A closure executed when the dismissing complete.
        internal var waitingCompletionOnAppearing: (() -> Void)?
    }
    
    /// Is showing or dismissing with animation.
    private var _isAnimated: Bool?
    /// Is the toast controller appearred.
    private var _isViewAppeared: Bool = false
    /// The dismiss state of the toast controller.
    private var _dismissState: _DismissState?
    /// The animator of the toast controller.
    public var animator: ToastAnimator = ToastAppearance.Controller.animator
    /// The presentation style of the toast controller.
    public var presentationStyle: PresentationStyle = ToastAppearance.Controller.presentationStyle
    /// Returns the toast view of the toast controller.
    public var toastView: ToastView! {
        return view as? ToastView
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
    public override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._init()
    }
    
    /// Overrides to init with a decoder.
    public required init?(
        coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self._init()
    }
    
    /// Creates an insance of `ToastController` with the given components of `[UIView & ToastComponent]`.
    ///
    /// - Parameter components: The components shows in the content view of the toast view.
    /// - Returns: A toast controller.
    ///
    public convenience init(
        components: [UIView & ToastComponent])
    {
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
    
    public override func viewWillAppear(
        _ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        view.setNeedsLayout()
    }
    
    public override func viewDidAppear(
        _ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        defer {
            _isViewAppeared = true
            // Clear the states.
            _dismissState = nil
        }
        
        if !_isViewAppeared, case let dismissState? = _dismissState, dismissState.isWaitingToDismissOnAppearing {
            _isViewAppeared = true
            
            dismiss(
                animated: dismissState.isAnimatingToDismissOnAppearing,
                completion: dismissState.waitingCompletionOnAppearing
            )
        }
    }
}

// MARK: - Public.

extension ToastController {
    /// Progress value of the toast if any. Get the value of progress will return the first progress indicator's value of
    /// the toast if any, and set the value of progress will set each progress indicator of the toast.
    public var progress: CGFloat? {
        get {
            return toastView.contentView.subviews.compactMap {
                $0 as? ToastView.Component.ProgressIndicator
            }.first?.progress
        }
        set {
            toastView.contentView.subviews.forEach {
                ($0 as? ToastView.Component.ProgressIndicator)?.progress = newValue ?? 0.0
            }
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
    public func show(
        in viewController: UIViewController?,
        animated: Bool,
        duration: TimeInterval? = nil,
        completion: (() -> Void)? = nil)
    {
        guard let viewController = viewController else {
            return
        }
        
        switch presentationStyle {
        case .presented:
            viewController.present(
                self,
                animated: animated,
                completion: completion
            )
        case .child:
            viewController._add(
                child: self,
                animated: animated,
                completion: completion
            )
        }
        
        _isAnimated = animated
        
        if let duration = duration {
            dismiss(
                animated: animated,
                after: duration
            )
        }
    }
    
    /// Dismiss the toast controller after the given delay time interval.
    ///
    /// - Parameter animated: Indicates the toast showing with or without animation.
    /// - Parameter delay: The time inverval the toast will dismiss after.
    /// - Parameter completion: A completion call back closure when the toast has being dismissed.
    ///
    public func dismiss(
        animated: Bool,
        after delay: TimeInterval,
        completion: (() -> Void)? = nil)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(
                animated: animated,
                completion: completion
            )
        }
    }
    
    /// Dismiss the toast controller itself if the toast controller is showing.
    ///
    /// - Parameter animated: Indicates the toast showing with or without animation.
    /// - Parameter completion: A completion call back closure when the toast has being dismissed.
    ///
    public override func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil)
    {
        guard _isViewAppeared else {
            // Save the states.
            _dismissState = _DismissState(
                isWaitingToDismissOnAppearing: true,
                isAnimatingToDismissOnAppearing: flag,
                waitingCompletionOnAppearing: completion
            )
            return
        }
        
        animator.animation(
            toastView,
            false,
            flag
        )
        
        switch presentationStyle {
        case .presented:
            if view.window == nil {
                completion?()
            } else {
                super.dismiss(
                    animated: flag,
                    completion: completion
                )
            }
        case .child:
            parent?._remove(
                child: self,
                animated: flag,
                completion: completion
            )
        }
    }
}

// MARK: - Components.

extension ToastController {
    /// Return a message toast contains title and detail messages.
    ///
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: An activity toast.
    public class func message(
        _ message: String,
        detail: String? = nil) -> ToastController
    {
        return ToastController(
            components: Toast.message(
                message,
                detail: detail
            )
        )
    }
    
    /// Return a activity toast contains an activity indicator, title and detail messages.
    ///
    /// - Parameter activityIndicatorStyle: The activity indicator style of `ToastView.Component.ActivityIndicatorStyle`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: An activity toast.
    public class func activity(
        _ activityIndicatorStyle: ToastView.Component.ActivityIndicator.Style = .normal,
        message: String,
        detail: String? = nil) -> ToastController
    {
        return ToastController(
            components: Toast.activity(
                activityIndicatorStyle,
                message: message,
                detail: detail
            )
        )
    }
    
    /// Returns a progress toast contains a progress indicator, title and detail message.
    ///
    /// - Parameter progressIndicatorStyle: The progress indicator style of `ToastView.Component.ProgressIndicator.Style`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A progress toast.
    public class func progress(
        _ progressIndicatorStyle: ToastView.Component.ProgressIndicator.Style = .pie,
        message: String,
        detail: String? = nil) -> ToastController
    {
        return ToastController(
            components: Toast.progress(
                progressIndicatorStyle,
                message: message,
                detail: detail
            )
        )
    }
    
    /// Returns a result toast contains a result indicator, title and detail message.
    ///
    /// - Parameter resultIndicatorStyle: The result indicator style of `ToastView.Component.ProgressIndicator.Style`.
    /// - Parameter message: The title message content.
    /// - Parameter detail: The detail message content.
    ///
    /// - Returns: A result toast.
    public class func result(
        _ resultIndicatorStyle: ToastView.Component.ResultIndicator.Style = .success,
        message: String,
        detail: String? = nil) -> ToastController
    {
        return ToastController(
            components: Toast.result(
                resultIndicatorStyle,
                message: message,
                detail: detail
            )
        )
    }
}

// MARK: - Private.

extension UIViewController {
    /// Add the given view controller as the reveiver's child view controller.
    fileprivate func _add(
        child viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?)
    {
        viewController.willMove(toParentViewController: self)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [
            .flexibleBottomMargin,
            .flexibleRightMargin,
            .flexibleHeight,
            .flexibleWidth
        ]
        
        view.setNeedsLayout()
        
        addChildViewController(viewController)
        
        if animated {
            viewController.view.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                viewController.view.alpha = 1.0
            }, completion: { _ in
                completion?()
            })
        } else {
            completion?()
        }
    }
    /// Remove the given view controller from the receiver.
    fileprivate func _remove(
        child viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?)
    {
        guard childViewControllers.contains(viewController) else {
            return
        }
        
        // Remove the older drawer view controller.
        func _removeChildViewController() {
            viewController.willMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
            viewController.didMove(toParentViewController: nil)
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                viewController.view.alpha = 0.0
            }, completion: { _ in
                _removeChildViewController()
                viewController.view.alpha = 1.0
                completion?()
            })
        } else {
            _removeChildViewController()
            completion?()
        }
    }
}
