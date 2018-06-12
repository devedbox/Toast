//
//  ActivityIndicator.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ActivityIndicator.

extension ToastView.Component {
    /// The indicator for activity like `UIActivityIndicator` do.
    public final class ActivityIndicator: UIView {
        
        // MARK: Style.
        
        /// Style of the activity indicator.
        public enum Style {
            /// Normal style like UIKit do. This is default style.
            case normal
            /// Style which content as a breached ring.
            case breachedRing
        }
        
        /// Indicates the animating state of the indicator view.
        private var _animating: Bool = false
        /// The drawing components count of style `.normal`.
        private var _drawingComponents: UInt = 12
        /// Indicates should gradient color index of style `.normal`.
        private var _shouldGradientColorIndex: Bool = true
        /// The drawing angle offset of style `.normal`.
        private var _angleOffset: CGFloat = 0.0
        /// The animation duration of the activity indicator view. Default is 1.6.
        fileprivate var _duration: TimeInterval = 1.6
        /// The style of the activity indicator view.
        public let style: Style
        /// The drawing line width of the activity indicator view. Default is 2.0.
        fileprivate var _lineWidth: CGFloat = 2.0 {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The breach angle of the `.breachedRing`. Default is `pi/4`.
        fileprivate var _breachedAngle: CGFloat = .pi * 0.25 {
            didSet {
                setNeedsDisplay()
            }
        }
        /// Tint color of `ActivityIndicator`.
        public override var tintColor: UIColor! {
            didSet {
                setNeedsDisplay()
            }
        }
        
        // MARK: Initializer.
        
        public init(style: Style) {
            self.style = style
            super.init(frame: .zero)
            self._init()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            style = .normal
            super.init(coder: aDecoder)
            self._init()
        }
        
        private func _init() {
            _angleOffset = -(CGFloat.pi * 2.0 / CGFloat(_drawingComponents)) * 2.0
            backgroundColor = .clear
            NotificationCenter.default.addObserver(self, selector: #selector(_didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: Overrides.
        
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            context.setLineWidth(_lineWidth)
            context.setLineCap(.round)
            
            switch style {
            case .breachedRing:
                _drawBreachedRing(using: context, in: rect)
            case .normal:
                _drawNormal(using: context, in: rect)
            }
        }
        
        public override func tintColorDidChange() {
            super.tintColorDidChange()
            
            setNeedsDisplay()
        }
    }
}

// MARK: - Public.

extension ToastView.Component.ActivityIndicator {
    /// Is the activity indicator view animating.
    public var isAnimating: Bool {
        get {
            return _animating
        }
        set {
            _animating = newValue
            _doAnimate(newValue)
        }
    }
    
    /// Returns an instance of `ActivityIndicator` with style of `.normal` and size of `{ 37.0, 37.0 }`.
    public class var normal: ToastView.Component.ActivityIndicator {
        let indicator = ToastView.Component.ActivityIndicator(style: .normal)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 37.0, height: 37.0))
        indicator._lineWidth = 3.0
        indicator._duration = 1.0
        return indicator
    }
    
    /// Returns an instance of `ActivityIndicator` with style of `.breachedRing` and size of `{ 37.0, 37.0 }`.
    public class var breachedRing: ToastView.Component.ActivityIndicator {
        let indicator = ToastView.Component.ActivityIndicator(style: .breachedRing)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 37.0, height: 37.0))
        return indicator
    }
}

// MARK: - Private.

extension ToastView.Component.ActivityIndicator {
    /// Perform/Stop the animation.
    private func _doAnimate(_ animated: Bool) {
        switch style {
        case .breachedRing:
            if animated {
                let rotation = CABasicAnimation(keyPath: "transform.rotation")
                rotation.toValue = CGFloat.pi * 2.0
                rotation.duration = _duration
                rotation.repeatCount = Float.greatestFiniteMagnitude
                rotation.isRemovedOnCompletion = false
                layer.add(rotation, forKey: "rotate")
            } else {
                layer.removeAnimation(forKey: "rotate")
            }
        case .normal:
            if animated {
                let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
                let values = [UInt](0..<_drawingComponents).map { (CGFloat($0) * CGFloat.pi / 6.0 - CGFloat.pi * 0.5 + _angleOffset) }
                rotation.values = values
                rotation.duration = _duration
                rotation.repeatCount = Float.greatestFiniteMagnitude
                rotation.calculationMode = kCAAnimationDiscrete
                rotation.isRemovedOnCompletion = false
                layer.add(rotation, forKey: "rotate")
            } else {
                layer.removeAnimation(forKey: "rotate")
            }
        }
    }
    
    @objc
    private func _didBecomeActive(notification: Notification) {
        if _animating {
            isAnimating = _animating
        }
    }
    
    /// Draws normal style of the activity indicator.
    private func _drawNormal(using context: CGContext, in rect: CGRect) {
        let tintColor = self.tintColor ?? .black
        let separatorAngle = CGFloat.pi * 2.0 / CGFloat(_drawingComponents)
        for i in 0..<_drawingComponents {
            let angle = separatorAngle * CGFloat(i) - CGFloat.pi * 0.5 + _angleOffset
            let color = _shouldGradientColorIndex ? tintColor.withAlphaComponent(max(0.3, CGFloat(i) / CGFloat(_drawingComponents))) : tintColor
            
            context.setStrokeColor(color.cgColor)
            
            var drawingBox = bounds.insetBy(dx: _lineWidth * 0.5, dy: _lineWidth * 0.5)
            let delta = min(drawingBox.width, drawingBox.height)
            drawingBox.origin.x += fabs(drawingBox.width - delta) * 0.5
            drawingBox.origin.y += fabs(drawingBox.height - delta) * 0.5
            drawingBox.size.width = delta
            drawingBox.size.height = delta
            
            let radius = drawingBox.width * 0.5
            let innerRadius = radius * 0.5 + _lineWidth * 0.5
            let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
            let beginPoint = CGPoint(x: center.x - bounds.origin.x + innerRadius*cos(angle),
                                     y: center.y - bounds.origin.y + innerRadius * sin(angle))
            let endPoint = CGPoint(x: center.x - bounds.origin.x + radius * cos(angle),
                                   y: center.y - bounds.origin.y + radius * sin(angle))
            
            context.beginPath()
            
            context.move(to: beginPoint)
            context.addLine(to: endPoint)
            
            context.strokePath()
        }
    }
    
    /// Draws breached ring style of the activity indicator.
    private func _drawBreachedRing(using context: CGContext, in rect: CGRect) {
        let tintColor = self.tintColor ?? .black
        context.setStrokeColor(tintColor.cgColor)
        
        var drawingBox = bounds.insetBy(dx: _lineWidth, dy: _lineWidth)
        let delta = min(drawingBox.width, drawingBox.height)
        drawingBox.origin.x += fabs(drawingBox.width - delta) * 0.5
        drawingBox.origin.y += fabs(drawingBox.height - delta) * 0.5
        drawingBox.size.width = delta
        drawingBox.size.height = delta
        
        context.beginPath()
        
        context.addArc(center: CGPoint(x: drawingBox.midX, y: drawingBox.midY),
                       radius: delta * 0.5,
                       startAngle: 0.0,
                       endAngle: CGFloat.pi * 2 - _breachedAngle,
                       clockwise: false)
        
        context.strokePath()
    }
}
