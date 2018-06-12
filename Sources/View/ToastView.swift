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
    public var opacity: CGFloat = 0.3
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
    }
}

// MARK: - Public.

extension ToastView {
    /// Content view of `ToastView.ContentView` to manage the components of `ToastView`.
    public var contentView: ContentView {
        return _contentView
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
        _components.forEach { [unowned self] in $0.layout(in: self._contentView) }
    }
}
