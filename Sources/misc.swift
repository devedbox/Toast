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
