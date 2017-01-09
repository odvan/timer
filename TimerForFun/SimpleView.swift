//
//  SimpleView.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 07/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class SimpleView: UIView {

    //Didn't use it at all
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let scale: CGFloat = 0.9
    
    
    let circleStartAngle = CGFloat(0)
    let circleEndAngle = CGFloat(2 * M_PI)
    
    let circlePath = UIBezierPath()
    let circleLine = CAShapeLayer()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeScrollView()
   }


//    override init (frame : CGRect) {
//        super.init(frame : frame)
//        initializeScrollView()
//    }
//    
//    convenience init () {
//        self.init(frame:CGRect.zero)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding")
//        
//    }
//    
    
    func initializeScrollView() {
        
        circlePath.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
                                    radius: self.bounds.width / 2 * scale,
                                    startAngle: circleStartAngle,
                                    endAngle: circleEndAngle, clockwise: true)
        
        circleLine.path = circlePath.cgPath
        circleLine.strokeColor = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 0.4).cgColor
        circleLine.fillColor = UIColor.clear.cgColor
        circleLine.lineWidth = 10
        circleLine.lineCap = kCALineCapButt
        
        
        self.layer.addSublayer(circleLine)

    }

}
