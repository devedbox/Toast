//
//  ToastContentView.swift
//  Toast
//
//  Created by devedbox on 2018/6/11.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ToastView.ContentView.

extension ToastView {
    /// The content view of `ToastView` to manage the components of `ToastView`.
    public final class ContentView: UIView {
        
        // MARK: Style.
        
        /// The style of the content view.
        public enum Style {
            /// Normal style using normal view with the gray filling opacity.
            case normal(opacity: CGFloat)
            /// Coloured style using gradient color with the given colors.
            case coloured(colors: [UIColor])
            /// Translucent style using effect view with translucent type of `UIBlurEffectStyle`.
            case translucent(style: UIBlurEffectStyle)
        }
        
        /// The effect view for translucent style.
        private var _effectView: UIVisualEffectView?
        /// The gradient layer for the coloured style.
        private lazy var _gradientLayer = CAGradientLayer()
        /// The style of the instance of `ContentView`.
        public var style: Style = .normal(opacity: 0.3) {
            willSet {
                _clearPreviousState()
            }
            didSet {
                setNeedsDisplay()
                _setupStyle(style)
            }
        }
        /// Overrides the background color of the content view to ignore the background color.
        public override var backgroundColor: UIColor? {
            get {
                return super.backgroundColor
            }
            set {
                debugPrint("Fail to set background color `\(String(describing: newValue))` to `ToastView.ContentView`, setting background color of `ToastView.ContentView` won't effect.")
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
            super.backgroundColor = .clear
            
            _setupStyle(style)
        }
        
        // MARK: Overrides.
        
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            switch style {
            case .normal(opacity: let opacity):
                context.setFillColor(gray: 0.0, alpha: opacity)
            default:
                context.setFillColor(UIColor.clear.cgColor)
            }
            
            context.fill(rect)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            switch style {
            case .coloured(colors: _):
                _gradientLayer.frame = bounds
            case .translucent(style: _):
                _effectView?.frame = bounds
            default: break
            }
        }
    }
}

// MARK: - Public.

extension ToastView.ContentView {
    /// Returns the gradient layer of the content view for `.coloured` style.
    public var gradientLayer: CAGradientLayer? {
        guard case .coloured(colors: _) = style else {
            return nil
        }
        return _gradientLayer
    }
}

// MARK: - ToastComponentsContainer.

extension ToastView.ContentView: ToastComponentsContainer {
    /// The content size of `ToastView.ContentView`.
    public var size: CGSize {
        get {
            return bounds.size
        }
        set {
            bounds.size = newValue
        }
    }
    public func update(size: CGSize) {
        self.size = size
    }
}

// MARK: - Private.

extension ToastView.ContentView {
    /// Generates and returns the effect view for the given style.
    private func _effectView(for style: UIBlurEffectStyle) -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return effectView
    }
    
    /// Clear the previous state of the previous style.
    private func _clearPreviousState() {
        switch style {
        case .coloured(colors: _):
            _gradientLayer.removeFromSuperlayer()
        case .translucent(style: _):
            _effectView?.removeFromSuperview()
            _effectView = nil
        default:
            break
        }
    }
    
    /// Setup style of the content view.
    private func _setupStyle(_ style: Style) {
        switch style {
        case .translucent(style: let translucentStyle):
            _effectView = _effectView(for: translucentStyle)
            addSubview(_effectView!)
        case .coloured(colors: let colors):
            layer.addSublayer(_gradientLayer)
            _gradientLayer.colors = colors.map { $0.cgColor }
        default: break
        }
    }
}
