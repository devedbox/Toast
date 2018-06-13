//
//  misc.swift
//  Toast
//
//  Created by devedbox on 2018/6/13.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - UIEdgeInsets.

extension UIEdgeInsets {
    
    /// Returns the horizontal length of the edge insets.
    public var width: CGFloat {
        return left + right
    }
    
    /// Returns the vertical length of the edge insets.
    public var height: CGFloat {
        return top + bottom
    }
}

// MARK: - Layout.

/// Layout the frame of the receiver in a given container of `ToastComponentsContainer`.
public func layout(component: ToastComponent, in container: ToastComponentsContainer, provider: ToastComponentsProvider) {
    guard let order = try? provider.order(for: component) else {
        return
    }
    
    let bounds = CGRect(origin: .zero, size: component.frame.size)
    
    switch order {
    case .start:
        component.frame.origin.x = component.layout.insets.left
        component.frame.origin.y = component.layout.insets.top
        
        container.extends(size: CGSize(width: bounds.width + component.layout.insets.width,
                                       height: bounds.height + component.layout.insets.height))
    case .end: fallthrough
    case .middle(index: _):
        guard let previousComp = provider.previousComponents(before: component).last else {
            return
        }
        let ppComp = provider.previousComponents(before: previousComp).last

        switch component.layout.distribution {
        case .horizontal(at: let position):
            /// Align the component vertically.
            func _alignVertically() {
                let layoutHeight = bounds.height + component.layout.insets.height
                let widthToExtends = bounds.width + component.layout.insets.width
                let heightToExtends = max(layoutHeight - container.size.height, 0.0)
                
                switch component.layout.alignment {
                case .leading:
                    component.frame.origin.y = previousComp.frame.origin.y
                case .trailing:
                    component.frame.origin.y = previousComp.frame.maxY - bounds.height
                case .center:
                    component.frame.origin.y = previousComp.frame.minY + previousComp.frame.height * 0.5 - bounds.height * 0.5
                case .filling:
                    component.frame.origin.y = container.size.height * 0.5 - layoutHeight * 0.5 + component.layout.insets.top
                }
                
                container.extends(size: CGSize(width: widthToExtends, height: heightToExtends))
            }
            
            /// Layout the component related to the previous component on the left.
            func _layoutOnLeft() {
                component.frame.origin.x = previousComp.frame.origin.x - component.layout.insets.width - bounds.width
                _alignVertically()
            }
            
            /// Layout the component related to the previous component on the right.
            func _layoutOnRight() {
                component.frame.origin.x = previousComp.frame.maxX + previousComp.layout.insets.right + component.layout.insets.left
                _alignVertically()
            }
            
            switch position {
            case .left:
                var reversedIterator = provider.components.reversed().makeIterator()
                var shouldLayoutOnRight = false
                while let next = reversedIterator.next() {
                    shouldLayoutOnRight = (next.layout.distribution == .horizontal(at: .right) && reversedIterator.next() != nil)
                }
                
                if shouldLayoutOnRight {
                    _layoutOnRight()
                } else {
                    _layoutOnLeft()
                }
            case .right:
                var reversedIterator = provider.components.reversed().makeIterator()
                var shouldLayoutOnLeft = false
                while let next = reversedIterator.next() {
                    shouldLayoutOnLeft = (next.layout.distribution == .horizontal(at: .left) && reversedIterator.next() != nil)
                }
                
                if shouldLayoutOnLeft {
                    _layoutOnLeft()
                } else {
                    _layoutOnRight()
                }
            }
        case .vertical(at: let position):
            /// Align the component horzontally.
            func _alignHorizontally() {
                let layoutWidth = bounds.width + component.layout.insets.width
                let heightToExtends = bounds.height + component.layout.insets.height
                let widthToExtends = max(layoutWidth - container.size.width, 0.0)
                
                switch component.layout.alignment {
                case .leading:
                    component.frame.origin.x = previousComp.frame.origin.x
                case .trailing:
                    component.frame.origin.x = previousComp.frame.maxX - bounds.width
                case .center:
                    component.frame.origin.x = previousComp.frame.minX + previousComp.frame.width * 0.5 - bounds.width * 0.5
                case .filling:
                    component.frame.origin.x = container.size.width * 0.5 - layoutWidth * 0.5 + component.layout.insets.left
                }
                
                container.extends(size: CGSize(width: widthToExtends, height: heightToExtends))
            }
            
            /// Layout the component related to the previous component on the top.
            func _layoutOnTop() {
                _alignHorizontally()
                component.frame.origin.y = previousComp.frame.origin.y - component.layout.insets.height - bounds.height
            }
            
            /// Layout the component related to the previous component on the bottom.
            func _layoutOnBottom() {
                _alignHorizontally()
                component.frame.origin.y = previousComp.frame.maxY + previousComp.layout.insets.bottom + component.layout.insets.top
            }
            
            switch position {
            case .top:
                var reversedIterator = provider.components.reversed().makeIterator()
                var shouldLayoutOnBottom = false
                while let next = reversedIterator.next() {
                    shouldLayoutOnBottom = (next.layout.distribution == .vertical(at: .bottom) && reversedIterator.next() != nil)
                }
                
                if shouldLayoutOnBottom {
                    _layoutOnBottom()
                } else {
                    _layoutOnTop()
                }
            case .bottom:
                var reversedIterator = provider.components.reversed().makeIterator()
                var shouldLayoutOnTop = false
                while let next = reversedIterator.next() {
                    shouldLayoutOnTop = (next.layout.distribution == .vertical(at: .top) && reversedIterator.next() != nil)
                }
                
                if shouldLayoutOnTop {
                    _layoutOnTop()
                } else {
                    _layoutOnBottom()
                }
            }
        }
    }
}
