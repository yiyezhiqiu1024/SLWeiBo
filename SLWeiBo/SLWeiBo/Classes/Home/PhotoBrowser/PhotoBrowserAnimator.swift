//
//  PhotoBrowserAnimator.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/20.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageView(indexPath : NSIndexPath) -> UIImageView
}


class PhotoBrowserAnimator: NSObject {
    var isPresented : Bool = false
    var presentedDelegate : AnimatorPresentedDelegate?
    var indexPath : NSIndexPath?
}

extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext)
    }
    
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 0.nil值校验
        guard let presentedDelegate = presentedDelegate, indexPath = indexPath else {
            return
        }
        
        // 1.取出弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 2.将prensentedView添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        
        // 3.获取执行动画的imageView
        let startRect = presentedDelegate.startRect(indexPath)
        let imageView = presentedDelegate.imageView(indexPath)
        transitionContext.containerView()?.addSubview(imageView)
        imageView.frame = startRect
        
        // 4.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            imageView.frame = presentedDelegate.endRect(indexPath)
        }) { (_) -> Void in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
            transitionContext.completeTransition(true)
        }
    }
    
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.取出消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 2.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            dismissView?.alpha = 0.0
        }) { (_) -> Void in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
