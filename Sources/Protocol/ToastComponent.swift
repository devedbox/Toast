//
//  ToastComponent.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ToastComponentOrder.

/// The layout priority of `ToastComponent` used by the toast view to layout compoents.
public enum ToastComponentOrder {
    /// The priority which the component is leading priority.
    case start
    /// The priority which the comonent is midding priority. Alongwith the components before the current
    /// component called `previous` and a component after the current component called `next`.
    case middle(index: Array<ToastComponent>.Index)
    /// The priority which the component is trailing priority.
    case end
}

// MARK: - ToastComponent.

/// A ptotocol represents the conforming types can perform like the component of a toast view
/// of `ToastView`.
public protocol ToastComponent: class {
    
    /// Returns the frame of the receiver component.
    var frame: CGRect { get set }
    
    /// The layout info of the component.
    var layout: ToastView.Component.Layout { get set }
    
    /// Layout the frame of the receiver in a given container of `ToastComponentsContainer`.
    func layout(in container: ToastComponentsContainer, provider: ToastComponentsProvider)
}

// MARK: - ToastComponentsContainer.

/// A protocol represents the container for instances of `ToastComponent`.
public protocol ToastComponentsContainer {
    
    /// The max allowed layout width of the container.
    var maxAllowedLayoutWidth: CGFloat { get }
    
    /// The content size of the container.
    var size: CGSize { get }
    
    /// Extends the layout bounds of the container with a given size.
    func extends(size: CGSize)
}

// MARK: - ToastComponentsProvider.

/// A protocol represents the provider for instances of `ToastComponent`. Using the conforming types
/// to get the state of the container and components.
public protocol ToastComponentsProvider: class {
    /// Components managed by the container.
    var components: [ToastComponent] { get }
    
    /// Order of the given component in components of container.
    ///
    /// - Parameter component: The component to get order from.
    /// - Returns: The value of `ToastComponentOrder` indicates the order of the given component.
    func order(for component: ToastComponent) throws -> ToastComponentOrder
    
    /// Returns the previous components before the given components.
    ///
    /// - Parameter before: The component which the destined components before.
    /// - Returns: The destined components before the given component.
    func previousComponents(before: ToastComponent) -> [ToastComponent]
    
    /// Returns the next components after the given components.
    ///
    /// - Parameter after: The component which the destined components after.
    /// - Returns: The destined components after the given component.
    func nextComponents(after: ToastComponent) -> [ToastComponent]
}

// MARK: - Default.

extension ToastComponentsProvider {
    
    /// Order of the given component in components of container.
    ///
    /// - Parameter component: The component to get order from.
    /// - Returns: The value of `ToastComponentOrder` indicates the order of the given component.
    public func order(for component: ToastComponent) throws -> ToastComponentOrder {
        guard
            !components.isEmpty,
            let index = components.index(where: { $0 === component })
        else {
            throw ToastError.componentNotInContainer(component: component, container: self)
        }
        
        switch index {
        case components.startIndex:
            return .start
        case components.index(before: components.endIndex):
            return .end
        default:
            return .middle(index: index)
        }
    }
    
    /// Returns the previous components before the given components.
    ///
    /// - Parameter before: The component which the destined components before.
    /// - Returns: The destined components before the given component.
    public func previousComponents(before: ToastComponent) -> [ToastComponent] {
        guard
            !components.isEmpty,
            let index = components.index(where: { $0 === before })
        else {
            return []
        }
        
        return Array(components[0..<index])
    }
    
    /// Returns the next components after the given components.
    ///
    /// - Parameter after: The component which the destined components after.
    /// - Returns: The destined components after the given component.
    public func nextComponents(after: ToastComponent) -> [ToastComponent] {
        guard
            !components.isEmpty,
            let index = components.index(where: { $0 === after }),
            index < components.index(before: components.endIndex)
        else {
            return []
        }
        
        return Array(components[components.index(after: index)..<components.endIndex])
    }
}
