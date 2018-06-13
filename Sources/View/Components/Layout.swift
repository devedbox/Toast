//
//  Layout.swift
//  Toast
//
//  Created by devedbox on 2018/6/13.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - Layout.

extension ToastView.Component {
    /// The layout spec of the toast component.
    public struct Layout {
        
        // MARK: Distribution.
        
        /// The layout distribution of `ToastComponent` used by the toast component to layout.
        public enum Distribution: Equatable {
            
            // MARK: Horizontal.
            
            /// The layout position of `ToastComponent` used by the toast component to layout.
            public enum Horizontal: Equatable {
                /// Indicates the related position at left.
                case left
                /// Indicates the related position at right.
                case right
            }
            
            // MARK: Vertical.
            
            /// The layout position of `ToastComponent` used by the toast component to layout.
            public enum Vertical: Equatable {
                /// Indicates the related position at top.
                case top
                /// Indicates the related position at bottom.
                case bottom
            }
            
            /// Indicates the horizontal direction along with a positon at the horizontal direction.
            case horizontal(at: Horizontal)
            case vertical(at: Vertical)
        }
        
        // MARK: Alignment.
        
        /// The alignment of `ToastComponent` used by the toast component to layout.
        public enum Alignment: Equatable {
            /// Align to leading of the related component.
            case leading
            /// Align to center of the related component.
            case center
            /// Align to trailing of the related component.
            case trailing
            /// Fill to align to the related component.
            case filling
        }
        
        /// The insets of the component's edge.
        public var insets: UIEdgeInsets
        /// The preferred layout distribution of `ToastComponent`.
        public var distribution: Distribution
        /// The alignment of `ToastComponent`.
        public var alignment: Alignment
    }
}
