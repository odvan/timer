//
//  SimpleRing.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 05/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit


let π: CGFloat = CGFloat(M_PI)

// @IBDesignable
class SimpleRing: UIView {
    
    // MARK: Constants & Variables
    
    var restIntervalSR: Double?
    var specialMode: Bool = false
    var timerDuration: Double? {
        didSet {
            if (timerDuration != nil) {
                setNeedsDisplay()
            } else {
                progressLine.removeFromSuperlayer()
                progressLineOutside.removeFromSuperlayer()
            }
        }
    }
    
    let scale: CGFloat = 0.8
    
    fileprivate var circleRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    fileprivate var circleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    let circleStartAngle = CGFloat(0)
    let circleEndAngle = CGFloat(2 * π)
    
    let ovalStartAngle = CGFloat(3/2 * π)
    
    var circlePath = UIBezierPath()
    var circleLine = CAShapeLayer()
    
    var progressLine = CAShapeLayer()
    var progressLineOutside = CAShapeLayer()
    
    @IBInspectable var color: CGColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 0.4).cgColor
    
    // MARK: Functions creates rings
    
    fileprivate func addShapeLayer() {
        
        circlePath.addArc(withCenter: CGPoint(x: circleCenter.x, y: circleCenter.y),
                                    radius: circleRadius,
                                    startAngle: circleStartAngle,
                                    endAngle: circleEndAngle, clockwise: false)
        
        circleLine.path = circlePath.cgPath
        circleLine.strokeColor = color
        circleLine.fillColor = UIColor.clear.cgColor
        circleLine.lineWidth = min(bounds.size.width, bounds.size.height) / 6
        circleLine.lineCap = kCALineCapButt
        
        self.layer.addSublayer(circleLine)
        //print("position:", circleLine.position)
        //print("Circle Line scale: \(circleLine.contentsScale)")
        
        //        self.layer.cornerRadius = self.frame.width/2
        //        self.layer.borderColor = UIColor(red: 0.8, green: 0.2, blue: 1, alpha: 0.4).CGColor
        //        self.layer.backgroundColor = UIColor.clearColor().CGColor
        //        self.layer.borderWidth = 2
        
    }
    
    fileprivate func progressLine(_ duration: Double, circleRadius: CGFloat, lineWidth: CGFloat) {
        
        var ovalEndAngle: CGFloat {
            if duration >= 3600 {
                return 4 * π
            } else {
                return (CGFloat(duration) * π/1800) + (3 * π/2)
            }
        }
        
        // create the bezier path
        let ovalPath = UIBezierPath()
        
        
        ovalPath.addArc(withCenter: CGPoint(x: circleCenter.x, y: circleCenter.y),
                                  radius: circleRadius,
                                  startAngle: ovalStartAngle,
                                  endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        progressLine.path = ovalPath.cgPath
        progressLine.strokeColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).cgColor
        progressLine.fillColor = UIColor.clear.cgColor
        progressLine.lineWidth = lineWidth
        progressLine.lineCap = kCALineCapButt
        
        // add the curve to the screen
        self.layer.addSublayer(progressLine)
        
        //progressLine.contentsScale = UIScreen.mainScreen().scale
        //progressLine.rasterizationScale = 2.0
        //progressLine.shouldRasterize = true
        
        //print("Progress Line scale: \(progressLine.contentsScale)")
        
    }
    
    fileprivate func progressLineOutside(_ duration: Double) {
        
        let ovalEndAngle = (CGFloat(duration) * π/43200) + (3 * π/2)
        
        // create the bezier path
        let outsidePathInside = UIBezierPath()
        
        outsidePathInside.addArc(withCenter: CGPoint(x: circleCenter.x, y: circleCenter.y),
                                           radius: circleRadius + min(bounds.size.width, bounds.size.height) / 12 - 2,
                                           startAngle: ovalStartAngle,
                                           endAngle: ovalEndAngle, clockwise: true)
        
        // create an object that represents how the curve
        // should be presented on the screen
        progressLineOutside.path = outsidePathInside.cgPath
        progressLineOutside.strokeColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).cgColor
        progressLineOutside.fillColor = UIColor.clear.cgColor
        progressLineOutside.lineWidth = 4.0
        progressLineOutside.lineCap = kCALineCapRound
        
        // add the curve to the screen
        self.layer.addSublayer(progressLineOutside)
        //print("Progress Line Outside scale: \(progressLineOutside.contentsScale)")
        
    }
    
    //MARK: Drawing rings
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if specialMode {
            circleLine.removeFromSuperlayer()
            progressLine.removeFromSuperlayer()
            progressLineOutside.removeFromSuperlayer()
            
            if let duration = timerDuration {
                
                let rest = restIntervalSR!
                
                if duration > rest {
                    
                    // Tried subviews instead of layers for creating circles, for fun 
                    
                    let circleWork = UIBezierPath(arcCenter: circleCenter, radius: circleRadius + min(bounds.size.width, bounds.size.height) / 24, startAngle: ovalStartAngle, endAngle: (CGFloat(duration - rest) * π/1800) + (3 * π/2), clockwise: true)
                    
                    circleWork.lineWidth = min(bounds.size.width, bounds.size.height) / 12
                    UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).setStroke()
                    circleWork.lineCapStyle = .round
                    circleWork.stroke()
                    
                    let circleRest = UIBezierPath(arcCenter: circleCenter, radius: circleRadius - min(bounds.size.width, bounds.size.height) / 24, startAngle: ovalStartAngle, endAngle: (CGFloat(rest) * π/1800) + (3 * π/2), clockwise: true)
                    
                    circleRest.lineWidth = min(bounds.size.width, bounds.size.height) / 12
                    UIColor(red: 0/255, green: 175/255, blue: 255/255, alpha: 1.0).setStroke()
                    circleRest.lineCapStyle = .round
                    circleRest.stroke()
                    
                } else {
                    let circleRest = UIBezierPath(arcCenter: circleCenter, radius: circleRadius - min(bounds.size.width, bounds.size.height) / 24, startAngle: ovalStartAngle, endAngle: (CGFloat(duration) * π/1800) + (3 * π/2), clockwise: true)
                    
                    circleRest.lineWidth = min(bounds.size.width, bounds.size.height) / 12
                    UIColor(red: 0/255, green: 175/255, blue: 255/255, alpha: 1.0).setStroke()
                    circleRest.lineCapStyle = .round
                    circleRest.stroke()
                }

            }
        } else {
            
        addShapeLayer()
        
        if let duration = timerDuration {
            
            if duration < 3600 {
                
                let lineWidth = min(bounds.size.width, bounds.size.height) / 6//circleLine.lineWidth
                
                progressLineOutside.removeFromSuperlayer()
                progressLine(duration, circleRadius: circleRadius, lineWidth: lineWidth)
                
//                let circle = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: ovalStartAngle, endAngle: (CGFloat(duration) * π/1800) + (3 * π/2), clockwise: true)
//                
//                circle.lineWidth = min(bounds.size.width, bounds.size.height) / 6
//                UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).setStroke()
//                circle.stroke()
                
            } else {
                let radius = circleRadius - 3.5
                let lineWidth = min(bounds.size.width, bounds.size.height) / 6 - 7//circleLine.lineWidth - 7
                
                progressLine(duration, circleRadius: radius, lineWidth: lineWidth)
                progressLineOutside(duration)
                
//                let circle = UIBezierPath(arcCenter: circleCenter, radius: radius, startAngle: ovalStartAngle, endAngle: (CGFloat(duration) * π/1800) + (3 * π/2), clockwise: true)
//                
//                circle.lineWidth = lineWidth
//                UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).setStroke()
//                circle.stroke()
//                
//                let circleS = UIBezierPath(arcCenter: circleCenter, radius: circleRadius + min(bounds.size.width, bounds.size.height) / 12 - 2, startAngle: ovalStartAngle, endAngle: (CGFloat(duration) * π/43200) + (3 * π/2), clockwise: true)
//                
//                circleS.lineWidth = 4.0
//                circleS.lineCapStyle = .Round
//                UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0).setStroke()
//                circleS.stroke()
                
            }
        }
        
        //        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //        label.text = "It works!!!"
        //        label.layer.rasterizationScale = 2.0
        //        label.layer.shouldRasterize = true
        //        self.addSubview(label)
        
        }
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        //circleLine.frame = self.layer.bounds
    //
    //        //opaque = false
    //
    //        print("view:", self.frame, self.bounds, self.center)
    //        print("circleLine:", circleLine.frame, circleLine.bounds, circleLine.position)
    //
    //    }
    //
    //    override func layoutSublayersOfLayer(layer: CALayer) {
    //        super.layoutSublayersOfLayer(layer)
    //        
    //        if (layer == self.layer)
    //        {
    //           circleLine.frame = layer.bounds;
    //        }
    //    }
}
