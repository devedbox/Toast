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
            
            switch layout.distribution {
            case .horizontal(at: let position):
                /// Align the component vertically.
                func _alignVertically() {
                    let layoutHeight = bounds.height + layout.insets.height
                    let widthToExtends = bounds.width + layout.insets.width
                    let heightToExtends = max(layoutHeight - container.size.height, 0.0)
                    
                    switch layout.alignment {
                    case .leading:
                        frame.origin.y = previousComp.frame.origin.y
                    case .trailing:
                        frame.origin.y = previousComp.frame.maxY - bounds.height
                    case .center:
                        frame.origin.y = previousComp.frame.minY + previousComp.frame.height * 0.5 - bounds.height * 0.5
                    case .filling:
                        frame.origin.y = container.size.height * 0.5 - layoutHeight * 0.5 + layout.insets.top
                    }
                    
                    container.extends(size: CGSize(width: widthToExtends, height: heightToExtends))
                }
                
                /// Layout the component related to the previous component on the left.
                func _layoutOnLeft() {
                    frame.origin.x = previousComp.frame.origin.x - layout.insets.width - bounds.width
                    _alignVertically()
                }
                
                /// Layout the component related to the previous component on the right.
                func _layoutOnRight() {
                    frame.origin.x = previousComp.frame.maxX + previousComp.layout.insets.right + layout.insets.left
                    _alignVertically()
                }
                
                switch position {
                case .left:
                    if previousComp.layout.distribution == .horizontal(at: .right), ppComp != nil {
                        _layoutOnRight()
                    } else {
                        _layoutOnLeft()
                    }
                case .right:
                    if previousComp.layout.distribution == .horizontal(at: .left), ppComp != nil {
                        _layoutOnLeft()
                    } else {
                        _layoutOnRight()
                    }
                }
            case .vertical(at: let position):
                /// Align the component horzontally.
                func _alignHorizontally() {
                    let layoutWidth = bounds.width + layout.insets.width
                    let heightToExtends = bounds.height + layout.insets.height
                    let widthToExtends = max(layoutWidth - container.size.width, 0.0)
                    
                    switch layout.alignment {
                    case .leading:
                        frame.origin.x = previousComp.frame.origin.x
                    case .trailing:
                        frame.origin.x = previousComp.frame.maxX - bounds.width
                    case .center:
                        frame.origin.x = previousComp.frame.minX + previousComp.frame.width * 0.5 - bounds.width * 0.5
                    case .filling:
                        frame.origin.x = container.size.width * 0.5 - layoutWidth * 0.5 + layout.insets.left
                    }
                    
                    container.extends(size: CGSize(width: widthToExtends, height: heightToExtends))
                }
                
                /// Layout the component related to the previous component on the top.
                func _layoutOnTop() {
                    _alignHorizontally()
                    frame.origin.y = previousComp.frame.origin.y - layout.insets.height - bounds.height
                }
                
                /// Layout the component related to the previous component on the bottom.
                func _layoutOnBottom() {
                    _alignHorizontally()
                    frame.origin.y = previousComp.frame.maxY + previousComp.layout.insets.bottom + layout.insets.top
                }
                
                switch position {
                case .top:
                    if previousComp.layout.distribution == .vertical(at: .bottom), ppComp != nil {
                        _layoutOnBottom()
                    } else {
                        _layoutOnTop()
                    }
                case .bottom:
                    if previousComp.layout.distribution == .vertical(at: .top), ppComp != nil {
                        _layoutOnTop()
                    } else {
                        _layoutOnBottom()
                    }
                }
            }
        }
    }
}
