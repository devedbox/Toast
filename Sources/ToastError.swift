//
//  ToastError.swift
//  Toast
//
//  Created by devedbox on 2018/6/12.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

/// A type represents the error of `Toast`.
public enum ToastError: Error {
    /// Indicates the given component is not in the container.
    case componentNotInContainer(component: ToastComponent, container: ToastComponentsProvider)
}
