//
//  ToastComponentProtocol.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

public protocol ToastComponentProtocol {
    associatedtype Container: UICoordinateSpace = UIView
    var frame: CGRect { get }
    func layout(_ nextTo: Self, in container: Container)
}
