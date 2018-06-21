//
//  ToastViewComponents.swift
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
    public struct Component {
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
        public var layout = ToastView.Component.Layout(insets: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
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
    public func layout(in container: ToastComponentsContainer, provider: ToastComponentsProvider) {
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

// MARK: - ActivityIndicator.

extension ToastView.Component {
    /// The indicator for activity like `UIActivityIndicator` do.
    public final class ActivityIndicator: View {
        
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

// MARK: - ProgressIndicator.

extension ToastView.Component {
    /// The indicator view for progress of a task.
    public final class ProgressIndicator: View {
        
        // MARK: Style.
        
        public enum Style {
            /// Horizontal bar style of the progress indicator.
            case horizontalBar
            /// Pie style of the progress indicator.
            case pie
            /// Ring style of the progress indicator.
            case ring
            /// Coloured bar style of the progress indicator.
            case colouredBar
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
            
            if style == .colouredBar {
                layer.addSublayer(_gradientLayer)
                _beginAnimating()
            }
        }
        
        deinit {
            if style == .colouredBar {
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
            setNeedsLayout()
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
    
    /// Returns an instance of `ProgressIndicator` with style of `.colouredBar` and size as `{ 180.0, 1.0 }`.
    public class var colouredBar: ToastView.Component.ProgressIndicator {
        let indicator = ToastView.Component.ProgressIndicator(style: .colouredBar)
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

// MARK: - ResultIndicator.

extension ToastView.Component {
    /// The component represents the result of processes like success or error.
    public final class ResultIndicator: View {
        
        // MARK: Style.
        
        /// The style of `ResultIndicator`.
        public enum Style {
            /// The error style of the result indicator.
            case error
            /// The success style of the result indicator.
            case success
        }
        
        /// The style of the result indicator.
        public let style: Style
        /// The line width of the drawing. Default is 3.0.
        public var lineWidth: CGFloat = 3.0 {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The line cap of the drawing. Default is `.round`.
        public var lineCap: CGLineCap = .round {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The line join of the drawing. Defaut is `.round`.
        public var lineJoin: CGLineJoin = .round {
            didSet {
                setNeedsDisplay()
            }
        }
        /// The width of the indicator.
        public var width: CGFloat = 37.0 {
            didSet {
                sizeToFit()
                setNeedsDisplay()
            }
        }
        
        public override func tintColorDidChange() {
            super.tintColorDidChange()
            
            setNeedsDisplay()
        }
        
        // MARK: Init.
        
        public init(style: Style) {
            self.style = style
            super.init(frame: .zero)
            self._init()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            self.style = .success
            super.init(coder: aDecoder)
            self._init()
        }
        
        private func _init() {
            backgroundColor = .clear
            sizeToFit()
        }
        
        // MARK: Overrides.
        
        public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _sizeThatFits(width)
        }
        
        public override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            let tintColor = self.tintColor ?? .black
            
            context.setStrokeColor(tintColor.cgColor)
            context.setLineWidth(lineWidth)
            context.setLineCap(lineCap)
            context.setLineJoin(lineJoin)
            
            switch style {
            case .success:
                _drawSuccess(using: context, in: rect)
            case .error:
                _drawError(using: context, in: rect)
            }
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            sizeToFit()
        }
    }
}

// MARK: - Public.

extension ToastView.Component.ResultIndicator {
    /// Returns the result indicator of success style.
    public class var success: ToastView.Component.ResultIndicator {
        let indicator = ToastView.Component.ResultIndicator(style: .success)
        indicator.width = 28.0
        return indicator
    }
    
    /// Returns the result indicator of success style.
    public class var error: ToastView.Component.ResultIndicator {
        let indicator = ToastView.Component.ResultIndicator(style: .error)
        indicator.width = 20.0
        return indicator
    }
}

// MARK: - Private.

extension ToastView.Component.ResultIndicator {
    /// Returns the size that fits the given width.
    private func _sizeThatFits(_ width: CGFloat) -> CGSize {
        switch style {
        case .success:
            return CGSize(width: width, height: width * 2.0 / 3.0)
        case .error:
            return CGSize(width: width, height: width)
        }
    }
    
    /// Draws error indicator.
    private func _drawError(using context: CGContext, in rect: CGRect) {
        let box = rect.insetBy(dx: lineWidth, dy: lineWidth)
        
        context.move(to: CGPoint(x: box.minX, y: box.minY))
        context.addLine(to: CGPoint(x: box.maxX, y: box.maxY))
        context.move(to: CGPoint(x: box.minX, y: box.maxY))
        context.addLine(to: CGPoint(x: box.maxX, y: box.minY))
        
        context.strokePath()
    }
    
    /// Draws success indicator.
    private func _drawSuccess(using context: CGContext, in rect: CGRect) {
        let width = self.width - lineWidth * 2.0
        let boxSize = _sizeThatFits(width)
        let box = CGRect(origin: CGPoint(x: rect.width * 0.5 - boxSize.width * 0.5,
                                         y: rect.height * 0.5 - boxSize.height * 0.5),
                         size: boxSize)
        
        context.move(to: CGPoint(x: box.maxX, y: box.minY))
        context.addLine(to: CGPoint(x: box.minX + box.width * 1.0 / 3.0, y: box.maxY))
        context.addLine(to: CGPoint(x: box.minX, y: box.minY + box.height * 0.5))
        
        context.strokePath()
    }
}
