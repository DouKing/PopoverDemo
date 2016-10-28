//
//  CustomTranstion.swift
//  Popover
//
//  Created by iosci on 2016/10/11.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

enum TranstionStyle {
    case present, dismiss
}

class CustomTranstion: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transtionStyle = TranstionStyle.present
    
    convenience init(transtionStyle: TranstionStyle) {
        self.init()
        self.transtionStyle = transtionStyle
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.transtionStyle {
        case .dismiss:
            let fromView = transitionContext.view(forKey: .from)!
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [UIViewAnimationOptions.curveLinear, UIViewAnimationOptions.allowUserInteraction], animations: {
                fromView.transform = fromView.transform.translatedBy(x: 0, y: fromView.bounds.size.height)
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        case .present:
            
            let toVC = transitionContext.viewController(forKey: .to)!
            let toView = transitionContext.view(forKey: .to)!
            
            let initialframe = transitionContext.finalFrame(for: toVC)
            let startFrame = initialframe.offsetBy(dx: 0, dy: initialframe.size.height)
            
            toView.frame = startFrame
            
            transitionContext.containerView.addSubview(toView)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [UIViewAnimationOptions.curveLinear, UIViewAnimationOptions.allowUserInteraction], animations: {
                toView.frame = initialframe
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
