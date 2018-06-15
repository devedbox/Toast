//
//  Component.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit
import Foundation

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
        open var layout = ToastView.Component.Layout(insets: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
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

// MARK: - Label.

extension ToastView.Component {
    /// The label component of `Toast`.
    public final class Label: UILabel, ToastComponent {
        
        /// Should treat tint color as text color.
        public var shouldTreatTintColorAsTextColor: Bool = true
        /// The layout info of the component.
        open var layout = ToastView.Component.Layout(insets: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
                                                     distribution: .vertical(at: .bottom),
                                                     alignment: .center)
        
        public override var textColor: UIColor! {
            get {
                return super.textColor
            }
            set {
                if shouldTreatTintColorAsTextColor {
                    return
                }
                
                super.textColor = newValue
            }
        }
        
        public override var tintColor: UIColor! {
            didSet {
                if shouldTreatTintColorAsTextColor {
                    super.textColor = tintColor
                }
            }
        }
        
        // MARK: Init.
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self._init()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self._init()
        }
        
        private func _init() {
            super.textColor = self.tintColor
        }
        
        // MARK: Overrides.
        
        public override func tintColorDidChange() {
            super.tintColorDidChange()
            
            if shouldTreatTintColorAsTextColor {
                super.textColor = tintColor
            }
        }
    }
}

extension ToastView.Component.Label {
    /// Returns the title label for toast.
    public class func title(_ string: String) -> ToastView.Component.Label {
        let label = ToastView.Component.Label()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.text = string
        return label
    }
    /// Returns the detail label for toast.
    public class func detail(_ string: String) -> ToastView.Component.Label {
        let label = ToastView.Component.Label()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = string
        return label
    }
}

// MARK: - Layout.

extension ToastView.Component.Label {
    /// Layout the frame of the receiver in a given container of `ToastComponentsContainer`.
    open func layout(in container: ToastComponentsContainer, provider: ToastComponentsProvider) {
        guard let text = self.text, !text.isEmpty else {
            return
        }
        
        let size = (text as NSString).boundingRect(with: CGSize(width: container.maxAllowedLayoutWidth - layout.insets.width, height: CGFloat.greatestFiniteMagnitude),
                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                   attributes: [.font: font],
                                                   context: nil).size
        bounds.size = CGSize(width: ceil(size.width), height: ceil(size.height))
        
        Toast.layout(component: self, in: container, provider: provider)
    }
}
