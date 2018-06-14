//
//  ResultIndicator.swift
//  Toast
//
//  Created by devedbox on 2018/6/14.
//  Copyright © 2018年 AxziplinLib. All rights reserved.
//

import UIKit

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
        indicator.width = 32.0
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
