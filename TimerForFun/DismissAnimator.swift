//
//  DismissAnimator.swift
//  PanGestureCustomTransition
//
//  Created by Artur Kablak on 11/10/16.
//  Copyright © 2016 Artur Kablak. All rights reserved.
//

import UIKit


class DismissAnimator: NSObject {
    
    
}

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView

        guard
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            //let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            else {
                return
        }
        
        fromView.isHidden = true
        // Create the snapshot.
        let snapshot = fromView.snapshotView(afterScreenUpdates: false)
        snapshot!.center.y += UIScreen.main.bounds.height * 1/3
        // Don't forget to add it
        containerView.addSubview(snapshot!)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                // Shift the snapshot down by one screen length
                print(snapshot!.center)

                snapshot!.center.y += UIScreen.main.bounds.height * 2/3
            },
            completion: { _ in
                // Cleanup.
                // Undo the hidden state. User won't see this because transition is already over.
                fromView.isHidden = false
                // It's already off-screen, but get rid of the snapshot anyway.
                snapshot!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
//        let screenBounds = UIScreen.mainScreen().bounds
//        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
//        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
//        
//        
//        UIView.animateWithDuration(
//            self.transitionDuration(transitionContext),
//            animations: {
//                fromVC.frame = finalFrame
//            },
//            completion: { _ in
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//            }
//        )
    }
}
