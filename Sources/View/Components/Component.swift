//
//  Component.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ToastView.Component.

extension ToastView {
    /// Namespace for `Component.`
    public struct Component { }
}

// MARK: - View.

extension ToastView.Component {
    /// The base view of the component view.
    open class View: UIView, ToastComponent {
        /// The layout info of the component.
        open var layout = ToastView.Component.Layout(insets: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                                                     distribution: .vertical(at: .bottom),
                                                     alignment: .center)
    }
}

// MARK: - Layout.

extension ToastView.Component.View {
    /// Layout the frame of the receiver in a given container of `ToastComponentsContainer`.
    open func layout(in container: ToastComponentsContainer, provider: ToastComponentsProvider) {
        Toast.layout(component: self, in: container, provider: provider)
    }
}
