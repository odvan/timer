//
//  ChoosingPresentationController.swift
//  PresentationControllerTest
//
//  Created by Artur Kablak on 06/06/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit

class ChoosingPresentationController: UIPresentationController {
    
    let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
       
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0.0
        containerView!.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            context in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
//    override func dismissalTransitionWillBegin() {
//        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({
//            context in
//            self.dimmingView.alpha = 0.0
//            }, completion: {
//                context in
//                self.dimmingView.removeFromSuperview()
//        })
//    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        let containerFrame = self.containerView!.frame
        
        return CGRect(x: 0, y: containerFrame.height*1/3, width: containerFrame.width, height: containerFrame.height*2/2)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    
}
