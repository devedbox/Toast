//
//  ToastView.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ToastView.

/// A view represents the container of the components of a toast.
public final class ToastView: UIView {
    
    /// Content view of `ToastView.ContentView` to manage the components of `ToastView`.
    private lazy var _contentView: ContentView = ContentView()
    /// The components the toast view consists of.
    private var _components: [UIView & ToastComponent] = []
    /// Opacity of the diming background of the toast view. Default is 0.3.
    public var opacity: CGFloat = 0.0
    /// True to ignore the hit test view of `ToastView` when the hit point is outside the content view. Default is false.
    public var isTouchingThroughEnabled: Bool = false
    /// Overrides the background color of the toast view to ignore the background color.
    public override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            debugPrint("Fail to set background color `\(String(describing: newValue))` to `ToastView`, setting background color of `ToastView` won't effect.")
        }
    }
    
    // MARK: Initializer.
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // Do common init.
        self._init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Do commin init.
        self._init()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Do common init.
        self._init()
    }
    
    private func _init() {
        super.backgroundColor = .clear
        
        _contentView.layer.cornerRadius = 2.0
        _contentView.layer.masksToBounds = true
        
        addSubview(_contentView)
    }
    
    // MARK: Overrides.
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isTouchingThroughEnabled {
            if _contentView.frame.contains(point) {
                return _contentView
            } else {
                return nil
            }
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    /// Draws the background of the toast view.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        // Draws the dimming background.
        context.setFillColor(UIColor(white: 0.0, alpha: opacity).cgColor)
        context.fill(rect)
    }
    
    /// Layouts the subviews.
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        _layoutContentViews()
        
        _contentView.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
    }
}

// MARK: - Public.

extension ToastView {
    /// Content view of `ToastView.ContentView` to manage the components of `ToastView`.
    public var contentView: ContentView {
        return _contentView
    }
    
    /// Add component to the receiver.
    public func add(component: UIView & ToastComponent, animated: Bool = false) {
        _components.append(component)
        _contentView.addSubview(component)
        
        setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    /// Remove the given component if the component is in the components of the receiver.
    @discardableResult
    public func remove(component: UIView & ToastComponent, animated: Bool = false) -> Bool {
        guard let index = _components.index(where: { $0 === component }) else {
            return false
        }
        
        _components.remove(at: index)
        component.removeFromSuperview()
        
        setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
        
        return true
    }
    
    /// Set components to the receiver and remove the old ones.
    public func set(components: [UIView & ToastComponent], animated: Bool = false) {
        _components.forEach { $0.removeFromSuperview() }
        _components = components
        _components.forEach { [unowned self] in self._contentView.addSubview($0) }
        
        setNeedsLayout()
        
        if animated {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.9, options: [], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

// MARK: - ToastComponentsProvider.

extension ToastView: ToastComponentsProvider {
    /// Components managed by the toast view.
    public var components: [ToastComponent] {
        return _components
    }
}

// MARK: - Private.

extension ToastView {
    
    /// Layouts content views.
    private func _layoutContentViews() {
        // Reset the size of content view.
        _contentView.bounds.size = .zero
        // Layout components.
        _components.forEach { [unowned self] in $0.layout(in: self._contentView, provider: self) }
        
        let point = _components.reduce((0.0, 0.0), { (min($0.0, $1.frame.minX - $1.layout.insets.left),
                                                      min($0.1, $1.frame.minY - $1.layout.insets.top)) })
        // Align the components.
        _components.forEach {
            $0.frame.origin.x -= point.0
            $0.frame.origin.y -= point.1
        }
    }
}

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
        /// The max allowed layout width of content view.
        private var _maxAllowedLayoutWidth: CGFloat = 270.0
        /// The style of the instance of `ContentView`.
        public var style: Style = .normal(opacity: 0.89) {
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
                context.setFillColor(UIColor(white: 0.0, alpha: opacity).cgColor)
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
            insertSubview(_effectView!, at: 0)
        case .coloured(colors: let colors):
            layer.insertSublayer(_gradientLayer, at: 0)
            _gradientLayer.colors = colors.map { $0.cgColor }
        default: break
        }
    }
}

// MARK: - ToastComponentsContainer.

extension ToastView.ContentView: ToastComponentsContainer {
    /// The max allowed layout width of the container.
    public var maxAllowedLayoutWidth: CGFloat {
        get {
            return _maxAllowedLayoutWidth
        }
        set {
            _maxAllowedLayoutWidth = newValue
        }
    }
    
    /// The content size of `ToastView.ContentView`.
    public var size: CGSize {
        return bounds.size
    }
    /// Update the layout bounds of the container with a given size.
    public func extends(size: CGSize) {
        bounds.size = CGSize(width: bounds.width + size.width,
                             height: bounds.height + size.height)
    }
}
