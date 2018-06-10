//
//  ProgressIndicator.swift
//  Toast
//
//  Created by devedbox on 2018/6/10.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

// MARK: - ProgressIndicator.

extension ToastView.Component {
    /// The indicator view for progress of a task.
    public final class ProgressIndicator: UIView {
        
        // MARK: Style.
        
        public enum Style {
            /// Horizontal bar style of the progress indicator.
            case horizontalBar
            /// Pie style of the progress indicator.
            case pie
            /// Ring style of the progress indicator.
            case ring
            /// Colourred bar style of the progress indicator.
            case colourredBar
        }
        
        /// The storage of the progress value.
        private var _progress: CGFloat = 0.0
        /// The gradient layer of the progress indicator.
        private lazy var _gradientLayer = { () -> CAGradientLayer in
            let layer = CAGradientLayer()
            layer.startPoint = .zero
            layer.endPoint = CGPoint(x: 1.0, y: 0.0)
            layer.type = kCAGradientLayerAxial
            layer.colors = [UInt](0..<360).map { UIColor(hue: CGFloat($0) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor }
            return layer
        }()
        /// The colors of the gradient layer.
        private var _colors: [CGColor] = [] {
            didSet {
                _gradientLayer.colors = _colors
            }
        }
        /// The display link of the progress indicator.
        private lazy var _displayLink = { () -> CADisplayLink in
            let link: CADisplayLink = CADisplayLink(target: self, selector: #selector(_handleDisplayLink(_:)))
            if #available(iOS 10.0, *) {
                link.preferredFramesPerSecond = 60
            } else {
                link.frameInterval = 1
            }
            return link
        }()
        /// The style of the progress indicator.
        public let style: Style
        /// The drawing line width of the progress indicator.
        public var lineWidth: CGFloat = 1.0 {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The line cap of the progress indicator if any.
        public var lineCap: CGLineCap = .round {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The tint color of the progress indicator.
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
        
        required public init?(coder aDecoder: NSCoder) {
            style = .horizontalBar
            super.init(coder: aDecoder)
            self._init()
        }
        
        public override func awakeFromNib() {
            super.awakeFromNib()
            
            self._init()
        }
        
        private func _init() {
            backgroundColor = .clear
            
            if style == .colourredBar {
                layer.addSublayer(_gradientLayer)
                _beginAnimating()
            }
        }
        
        deinit {
            if style == .colourredBar {
                _displayLink.invalidate()
            }
        }
        
        // MARK: Overrides.
        
        public override func layoutSublayers(of layer: CALayer) {
            super.layoutSublayers(of: layer)
            
            _gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width * _progress, height: bounds.height))
        }
        
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            switch style {
            case .horizontalBar:
                _drawProgressOfHorizontalBar(using: context, in: rect)
            case .pie:
                _drawProgressOfPie(using: context, in: rect)
            case .ring:
                _drawProgressOfRing(using: context, in: rect)
            default: break
            }
        }
        
        public override func tintColorDidChange() {
            super.tintColorDidChange()
            
            setNeedsDisplay()
        }
    }
}

// MARK: - Public.

extension ToastView.Component.ProgressIndicator {
    /// The progress value of the progress indicator between [0.0, 1.0]. Default is 0.0.
    public var progress: CGFloat {
        get {
            return _progress
        }
        set {
            _progress = min(max(newValue, 0.0), 1.0)
            setNeedsDisplay()
        }
    }
    
    /// Returns an instance of `ProgressIndicator` with style of `.horizontalBar` and size as `{ 180.0, 12.0 }`.
    public class var horizontalBar: ToastView.Component.ProgressIndicator {
        let indicator = ToastView.Component.ProgressIndicator(style: .horizontalBar)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 180.0, height: 12.0))
        return indicator
    }
    
    /// Returns an instance of `ProgressIndicator` with style of `.pie` and size as `{ 37.0, 37.0 }`.
    public class var pie: ToastView.Component.ProgressIndicator {
        let indicator = ToastView.Component.ProgressIndicator(style: .pie)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 37.0, height: 37.0))
        return indicator
    }
    
    /// Returns an instance of `ProgressIndicator` with style of `.ring` and size as `{ 37.0, 37.0 }`.
    public class var ring: ToastView.Component.ProgressIndicator {
        let indicator = ToastView.Component.ProgressIndicator(style: .ring)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 37.0, height: 37.0))
        return indicator
    }
    
    /// Returns an instance of `ProgressIndicator` with style of `.colourredBar` and size as `{ 180.0, 1.0 }`.
    public class var colourredBar: ToastView.Component.ProgressIndicator {
        let indicator = ToastView.Component.ProgressIndicator(style: .colourredBar)
        indicator.frame = CGRect(origin: .zero, size: CGSize(width: 180.0, height: 1.0))
        return indicator
    }
}

// MARK: - Private.

extension ToastView.Component.ProgressIndicator {
    
    private func _beginAnimating() {
        _displayLink.add(to: .main, forMode: .commonModes)
    }
    
    /// Handle display link.
    @objc
    private func _handleDisplayLink(_ sender: CADisplayLink) {
        var colors: [Any] = _gradientLayer.colors ?? []
        if let color = colors.popLast() {
            colors.insert(color, at: 0)
        }
        _gradientLayer.colors = colors
    }
    
    /// Draw progress of horizontal bar style.
    private func _drawProgressOfHorizontalBar(using context: CGContext, in rect: CGRect) {
        let tintColor: UIColor = self.tintColor ?? .black
        let lineWidth: CGFloat = self.lineWidth
        let lineWidth2 = lineWidth * 2.0
        var radius = rect.height * 0.5 - lineWidth
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(tintColor.cgColor)
        context.setFillColor(UIColor.clear.cgColor)
        
        context.move(to: CGPoint(x: lineWidth, y: rect.height * 0.5))
        context.addArc(tangent1End: CGPoint(x: lineWidth, y: lineWidth),
                       tangent2End: CGPoint(x: lineWidth + radius, y: lineWidth),
                       radius: radius)
        context.addLine(to: CGPoint(x: rect.width - radius - lineWidth, y: lineWidth))
        context.addArc(tangent1End: CGPoint(x: rect.width - lineWidth, y: lineWidth),
                       tangent2End: CGPoint(x: rect.width - lineWidth, y: rect.height * 0.5),
                       radius: radius)
        context.addArc(tangent1End: CGPoint(x: rect.width - lineWidth, y: rect.height - lineWidth),
                       tangent2End: CGPoint(x: rect.width - radius - lineWidth, y: rect.height - lineWidth),
                       radius: radius)
        context.addLine(to: CGPoint(x: radius + lineWidth, y: rect.height - lineWidth))
        context.addArc(tangent1End: CGPoint(x: lineWidth, y: rect.height - lineWidth),
                       tangent2End: CGPoint(x: lineWidth, y: rect.height * 0.5),
                       radius: radius)
        
        context.fillPath()
        
        context.move(to: CGPoint(x: lineWidth, y: rect.height * 0.5))
        context.addArc(tangent1End: CGPoint(x: lineWidth, y: lineWidth),
                       tangent2End: CGPoint(x: lineWidth + radius, y: lineWidth),
                       radius: radius)
        context.addLine(to: CGPoint(x: rect.width - radius - lineWidth, y: lineWidth))
        context.addArc(tangent1End: CGPoint(x: rect.width - lineWidth, y: lineWidth),
                       tangent2End: CGPoint(x: rect.width - lineWidth, y: rect.height * 0.5),
                       radius: radius)
        context.addArc(tangent1End: CGPoint(x: rect.width - lineWidth, y: rect.height - lineWidth),
                       tangent2End: CGPoint(x: rect.width - radius - lineWidth, y: rect.height - lineWidth),
                       radius: radius)
        context.addLine(to: CGPoint(x: radius + lineWidth, y: rect.height - lineWidth))
        context.addArc(tangent1End: CGPoint(x: lineWidth, y: rect.height - lineWidth),
                       tangent2End: CGPoint(x: lineWidth, y: rect.height * 0.5),
                       radius: radius)
        
        context.strokePath()
        
        context.setFillColor(tintColor.cgColor)
        
        radius -= lineWidth
        let amount = _progress * rect.width
        
        if amount >= radius + lineWidth2 && amount <= rect.width - radius - lineWidth2 {
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: amount, y: lineWidth2))
            context.addLine(to: CGPoint(x: amount, y: radius + lineWidth2))
            
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: rect.height - lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: rect.height - lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: amount, y: rect.height - lineWidth2))
            context.addLine(to: CGPoint(x: amount, y: radius + lineWidth2))
            
            context.fillPath()
        } else if amount > radius + lineWidth2 {
            let x = amount - (rect.width - radius - lineWidth2)
            
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: rect.width - radius - lineWidth2, y: lineWidth2))
            
            var angle = -acos(x / radius)
            angle = angle.isNaN ? 0.0 : angle
            
            context.addArc(center: CGPoint(x: rect.width - radius - lineWidth2, y: rect.height * 0.5),
                           radius: radius,
                           startAngle: CGFloat.pi,
                           endAngle: angle,
                           clockwise: false)
            context.addLine(to: CGPoint(x: amount, y: rect.height * 0.5))
            
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: rect.height - lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: rect.height - lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: rect.width - radius - lineWidth2, y: rect.height - lineWidth2))
            
            angle = acos(x / radius)
            angle = angle.isNaN ? 0.0 : angle
            
            context.addArc(center: CGPoint(x: rect.width - radius - lineWidth2, y: rect.height * 0.5),
                           radius: radius,
                           startAngle: -CGFloat.pi,
                           endAngle: angle,
                           clockwise: true)
            context.addLine(to: CGPoint(x: amount, y: rect.height * 0.5))
            
            context.fillPath()
        } else if amount < radius + lineWidth2 && amount > 0 {
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: lineWidth2 + radius, y: rect.height * 0.5))
            
            context.move(to: CGPoint(x: lineWidth2, y: rect.height * 0.5))
            context.addArc(tangent1End: CGPoint(x: lineWidth2, y: rect.height - lineWidth2),
                           tangent2End: CGPoint(x: lineWidth2 + radius, y: rect.height - lineWidth2),
                           radius: radius)
            context.addLine(to: CGPoint(x: lineWidth2 + radius, y: rect.height * 0.5))
            
            context.fillPath()
        }
    }
    
    /// Draw progress of ring style.
    private func _drawProgressOfPie(using context: CGContext, in rect: CGRect) {
        let tintColor: UIColor = self.tintColor ?? .black
        let circleRect = rect.insetBy(dx: lineWidth, dy: lineWidth)
        
        context.setStrokeColor(tintColor.cgColor)
        context.setFillColor(tintColor.withAlphaComponent(0.1).cgColor)
        context.setLineWidth(lineWidth)
        
        context.fillEllipse(in: circleRect)
        context.strokeEllipse(in: circleRect)
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = (rect.width - lineWidth * 2) * 0.5
        let startAngle = -CGFloat.pi * 0.5
        
        context.setFillColor(tintColor.cgColor)
        
        context.move(to: center)
        context.addArc(center: center,
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: startAngle + CGFloat.pi * 2.0 * _progress,
                       clockwise: false)
        context.closePath()
        context.fillPath()
    }
    
    /// Draw progress of pie style.
    private func _drawProgressOfRing(using context: CGContext, in rect: CGRect) {
        let tintColor: UIColor = self.tintColor ?? .black
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = (rect.width - lineWidth) * 0.5
        
        context.setLineWidth(lineWidth)
        context.setLineCap(.butt)
        context.setStrokeColor(tintColor.withAlphaComponent(0.1).cgColor)
        
        let startAngle = -CGFloat.pi * 0.5
        
        context.addArc(center: center,
                       radius: radius,
                       startAngle: startAngle,
                       endAngle: startAngle + CGFloat.pi * 2.0,
                       clockwise: false)
        context.strokePath()

        context.setLineCap(lineCap)
        context.setStrokeColor(tintColor.cgColor)

        context.beginPath()

        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: startAngle + CGFloat.pi * 2.0 * _progress, clockwise: false)
        context.strokePath()
    }
}
