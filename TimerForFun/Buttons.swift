//
//  Buttons.swift
//  ViewsLayersTraining
//
//  Created by Artur Kablak on 05/09/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import Foundation
import UIKit



class MyButton: UIButton {
    
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                switch self.currentTitle! {
                case "Pause":
                    setTitle("Resume", for: .selected)
                    setTitle("Resume", for: [.selected, .highlighted])
                case "Start":
                    setTitle("Stop", for: .selected)
                    setTitle("Stop", for: [.selected, .highlighted])
                default:
                    break
                }
            } else {
                switch self.currentTitle! {
                case "Resume":
                    setTitle("Pause", for: .normal)
                case "Stop":
                    setTitle("Start", for: .normal)
                default:
                    break
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 255/255, green: 155/255, blue: 220/255, alpha: 1.0) : UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0)
            self.setTitleColor(UIColor.darkGray, for: .highlighted)
            self.setTitleColor(UIColor.darkGray, for: [.highlighted, .selected])
            
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if (isEnabled) {
                self.backgroundColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 1.0)
            } else {
                //self.setTitle("Pause", forState: .Disabled)
                self.backgroundColor = UIColor(red: 210/255, green: 50/255, blue: 150/255, alpha: 0.4)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.bounds.width/2
        clipsToBounds = true
        
        titleLabel!.font = UIFont.systemFont(ofSize: 16)
        
    }
    
//    override func drawRect(rect: CGRect) {
//        
////        let path = UIBezierPath(ovalInRect: rect)
////        fillColor.setFill()
////        path.fill()
//        
//        //set up the width and height variables
//        //for the vertical stroke
//        if (selected) || (highlighted) {
//        
//        let pauseWidth: CGFloat = 4.0
//        let pauseHeight: CGFloat = min(bounds.width, bounds.height) * 0.5
//        
//        //create the path
//        let pausePath = UIBezierPath()
//        
//        //set the path's line width to the height of the stroke
//        pausePath.lineWidth = pauseWidth
//        
//        //move the initial point of the path
//        //to the start of the vertical stroke
//        pausePath.moveToPoint(CGPoint(
//            x:bounds.width/2 - 6, // + 0.5
//            y:bounds.height/2 - pauseHeight/2)) // + 0.5
//        
//        //add a point to the path at the end of the stroke
//        pausePath.addLineToPoint(CGPoint(
//            x:bounds.width/2 - 6, // + 0.5
//            y:bounds.height/2 + pauseHeight/2)) // + 0.5
//        
//        pausePath.moveToPoint(CGPoint(
//            x:bounds.width/2 + 6, // + 0.5
//            y:bounds.height/2 - pauseHeight/2)) // + 0.5
//        
//        //add a point to the path at the end of the stroke
//        pausePath.addLineToPoint(CGPoint(
//            x:bounds.width/2 + 6, // + 0.5
//            y:bounds.height/2 + pauseHeight/2)) // + 0.5
//
//        
////        //Vertical Line
////        if isAddButton {
////            //move to the start of the vertical stroke
////            plusPath.moveToPoint(CGPoint(
////                x:bounds.width/2 + 0.5,
////                y:bounds.height/2 - plusWidth/2 + 0.5))
////            
////            //add the end point to the vertical stroke
////            plusPath.addLineToPoint(CGPoint(
////                x:bounds.width/2 + 0.5,
////                y:bounds.height/2 + plusWidth/2 + 0.5))
////        }
//        
//        //set the stroke color
//        UIColor.whiteColor().setStroke()
//        
//        //draw the stroke
//        pausePath.stroke()
//        }
//        
//    }
    
}
