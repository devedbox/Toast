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
        
        _contentView.frame.origin.x = bounds.width * 0.5 - _contentView.bounds.width * 0.5
        _contentView.frame.origin.y = bounds.height * 0.5 - _contentView.bounds.height * 0.5
    }
}

// MARK: - Public.

extension ToastView {
    /// Content view of `ToastView.ContentView` to manage the components of `ToastView`.
    public var contentView: ContentView {
        return _contentView
    }
    
    /// Add component to the receiver.
    public func add(component: UIView & ToastComponent) {
        _components.append(component)
        _contentView.addSubview(component)
        
        setNeedsLayout()
    }
    
    /// Remove the given component if the component is in the components of the receiver.
    @discardableResult
    public func remove(component: UIView & ToastComponent) -> Bool {
        guard let index = _components.index(where: { $0 === component }) else {
            return false
        }
        
        _components.remove(at: index)
        component.removeFromSuperview()
        
        setNeedsLayout()
        
        return true
    }
    
    /// Set components to the receiver and remove the old ones.
    public func set(components: [UIView & ToastComponent]) {
        _components.forEach { $0.removeFromSuperview() }
        _components = components
        _components.forEach { [unowned self] in self._contentView.addSubview($0) }
        
        setNeedsLayout()
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
