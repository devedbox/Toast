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
                                                       preferredDirection: .vertical(at: .bottom))
    }
}

// MARK: - Layout.

extension ToastView.Component.View {
    /// Layout the frame of the receiver in a given container of `ToastComponentsContainer`.
    open func layout(in container: ToastComponentsContainer, provider: ToastComponentsProvider) {
        guard let order = try? provider.order(for: self) else {
            return
        }
        
        switch order {
        case .start:
            frame.origin.x = layout.insets.left
            frame.origin.y = layout.insets.top
            
            container.extends(size: CGSize(width: bounds.width + layout.insets.width,
                                           height: bounds.height + layout.insets.height))
        case .end: fallthrough
        case .middle(index: _):
            guard let previousComp = provider.previousComponents(before: self).last else {
                return
            }
            let ppComp = provider.previousComponents(before: previousComp).last
            
            switch layout.preferredDirection {
            case .horizontal(at: let position):

                /// Layout the component related to the previous component on the left.
                func _layoutOnLeft() {
                    frame.origin.x = previousComp.frame.origin.x - layout.insets.width - bounds.width
                    frame.origin.y = previousComp.frame.origin.y
                }
                
                /// Layout the component related to the previous component on the right.
                func _layoutOnRight() {
                    frame.origin.x = previousComp.frame.maxX + previousComp.layout.insets.right + layout.insets.left
                    frame.origin.y = previousComp.frame.origin.y
                }
                
                switch position {
                case .left:
                    if previousComp.layout.preferredDirection == .horizontal(at: .right), ppComp != nil {
                        _layoutOnRight()
                    }
                    _layoutOnLeft()
                case .right:
                    if previousComp.layout.preferredDirection == .horizontal(at: .left), ppComp != nil {
                        _layoutOnLeft()
                    }
                    _layoutOnRight()
                }
                
                container.extends(size: CGSize(width: bounds.width + layout.insets.width,
                                               height: max(bounds.height - previousComp.frame.height, 0.0)))
            case .vertical(at: let position):
                
                /// Layout the component related to the previous component on the top.
                func _layoutOnTop() {
                    frame.origin.x = previousComp.frame.origin.x
                    frame.origin.y = previousComp.frame.origin.y - layout.insets.height - bounds.height
                }
                
                /// Layout the component related to the previous component on the bottom.
                func _layoutOnBottom() {
                    frame.origin.x = previousComp.frame.origin.x
                    frame.origin.y = previousComp.frame.maxY + previousComp.layout.insets.bottom + layout.insets.top
                }
                
                switch position {
                case .top:
                    if previousComp.layout.preferredDirection == .vertical(at: .bottom), ppComp != nil {
                        _layoutOnBottom()
                    }
                    _layoutOnTop()
                case .bottom:
                    if previousComp.layout.preferredDirection == .vertical(at: .top), ppComp != nil {
                        _layoutOnTop()
                    }
                    _layoutOnBottom()
                }
                
                container.extends(size: CGSize(width: max(bounds.width + layout.insets.width - container.size.width, 0.0),
                                               height: bounds.height + layout.insets.height))
            }
        }
    }
}
