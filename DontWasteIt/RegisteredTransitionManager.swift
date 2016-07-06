//
//  RegisterTransitionManager.swift
//  
//
//  Created by Dion Amini on 3/13/16.
//
//

import Foundation
import UIKit

class RegisteredTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let registerViewController = !self.presenting ? screens.from as! RegisteredViewController : screens.to as! RegisteredViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let regView = registerViewController.view
        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuController(registerViewController)
        }
        
        // add the both views to our view controller
        container!.addSubview(bottomView)
        container!.addSubview(regView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            
            if (self.presenting){
                self.onStageMenuController(registerViewController) // onstage items: slide in
            }
            else {
                self.offStageMenuController(registerViewController) // offstage items: slide out
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
        })
        
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(registerViewController: RegisteredViewController){
        
        registerViewController.view.alpha = 0
        
        // setup paramaters for 2D transitions for animations
        let topRowOffset  :CGFloat = 300
        let middleRowOffset :CGFloat = 250
//        let bottomRowOffset  :CGFloat = 50
        
//        registerViewController.textPostIcon.transform = self.offStage(-topRowOffset)
        registerViewController.textEmail.transform = self.offStage(-topRowOffset)
        
//        registerViewController.quotePostIcon.transform = self.offStage(-middleRowOffset)
        registerViewController.textPass.transform = self.offStage(middleRowOffset)
        
//        registerViewController.chatPostIcon.transform = self.offStage(-bottomRowOffset)
//        registerViewController.chatPostLabel.transform = self.offStage(-bottomRowOffset)
//        
//        registerViewController.photoPostIcon.transform = self.offStage(topRowOffset)
//        registerViewController.photoPostLabel.transform = self.offStage(topRowOffset)
//        
//        registerViewController.linkPostIcon.transform = self.offStage(middleRowOffset)
//        registerViewController.linkPostLabel.transform = self.offStage(middleRowOffset)
//        
//        registerViewController.audioPostIcon.transform = self.offStage(bottomRowOffset)
//        registerViewController.audioPostLabel.transform = self.offStage(bottomRowOffset)
        
        
        
    }
    
    func onStageMenuController(registerViewController: RegisteredViewController){
        
        // prepare menu to fade in
        registerViewController.view.alpha = 1
        
//        registerViewController.textPostIcon.transform = CGAffineTransformIdentity
        registerViewController.textEmail.transform = CGAffineTransformIdentity
        
//        menuViewController.quotePostIcon.transform = CGAffineTransformIdentity
        registerViewController.textPass.transform = CGAffineTransformIdentity
//
//        menuViewController.chatPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.chatPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.photoPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.photoPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.linkPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.linkPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.audioPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.audioPostLabel.transform = CGAffineTransformIdentity
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    
}

