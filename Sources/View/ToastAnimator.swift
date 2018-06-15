//
//  ToastAnimator.swift
//  Toast
//
//  Created by devedbox on 2018/6/15.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit
import CoreGraphics

// MARK: - ToastAnimator.

/// The toast animator used to do the appearance transition of the toast controller.
public struct ToastAnimator {
    /// The animation type of the toast controller to show or dismiss with.
    ///
    /// - Parameter toastView: The toast view to be animated.
    /// - Parameter isShowing: A boolean value indicates the toast controller is showing or dismissing.
    /// - Parameter isAnimated: A boolean value indicates the toast controller is transition with or without animation.
    public typealias Animation = (_ toastView: ToastView, _ isShowing: Bool, _ isAnimated: Bool) -> Void
    
    /// The animation closure of the animator.
    public let animation: Animation
}

// MARK: - Animators.

extension ToastAnimator {
    /// The animator doing nothing to do animate.
    public static let none = ToastAnimator { _, _, _ in }
    
    /// The animator to show toast with zoom in to show and zoom out to dismiss.
    public static let zoom = ToastAnimator { toastView, isShowing, isAnimated in
        if isAnimated {
            if isShowing {
                toastView.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = .identity
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }, completion: { isFinished in
                    if isFinished {
                        toastView.contentView.transform = .identity
                    }
                })
            }
        }
    }
    
    /// The animator to show toast with flip up to show and flip down to dismiss.
    public static let flip = ToastAnimator { toastView, isShowing, isAnimated in
        if isAnimated {
            if isShowing {
                toastView.contentView.transform = CGAffineTransform(translationX: 0.0, y: toastView.bounds.height)
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = .identity
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = CGAffineTransform(translationX: 0.0, y: toastView.bounds.height)
                }, completion: { isFinished in
                    if isFinished {
                        toastView.contentView.transform = .identity
                    }
                })
            }
        }
    }
    
    /// The animator to show toast with drop down.
    public static let drop = ToastAnimator { toastView, isShowing, isAnimated in
        if isAnimated {
            if isShowing {
                toastView.contentView.transform = CGAffineTransform(translationX: 0.0, y: -toastView.contentView.frame.maxY).rotated(by: CGFloat.pi / 12.0)
                UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = .identity
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                    toastView.contentView.transform = CGAffineTransform(translationX: 0.0, y: toastView.bounds.height - toastView.contentView.frame.minY).rotated(by: -CGFloat.pi / 12.0)
                }, completion: { isFinished in
                    if isFinished {
                        toastView.contentView.transform = .identity
                    }
                })
            }
        }
    }
}
