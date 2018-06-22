//
//  ToastAppearance.swift
//  Toast
//
//  Created by devedbox on 2018/6/22.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

/// The appearance manager of `Toast`. Using this type to set the appearance of `Toast` globlely.
public struct ToastAppearance {
    /// Appearance manager for `ToastView`.
    public struct View {
        /// Appearance manager for `ToastView.ContentView`.
        public struct ContentView {
            /// The style of the instance of `ContentView`.
            public static var style: ToastView.ContentView.Style = .normal(opacity: 0.89)
            /// The max allowed layout width of content view.
            public static var maxAllowedLayoutWidth: CGFloat = 270.0
            /// The corner radius of the layer of the content view.
            public static var cornerRadius: CGFloat = 2.0
        }
        /// Tint color of the toast view.
        public static var tintColor: UIColor? = nil
        /// Opacity of the diming background of the toast view. Default is 0.0.
        public static var opacity: CGFloat = 0.0
        /// True to ignore the hit test view of `ToastView` when the hit point is outside the content view. Default is false.
        public static var isTouchingThroughEnabled: Bool = false
    }
    /// Appearance manager for `ToastController`.
    public struct Controller {
        /// The animator of the toast controller.
        public static var animator: ToastAnimator = .none
        /// The presentation style of the toast controller.
        public static var presentationStyle: ToastController.PresentationStyle = .presented
    }
}
