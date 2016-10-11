//
//  CustomTranstion.swift
//  Popover
//
//  Created by iosci on 2016/10/11.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class CustomTranstion: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [UIViewAnimationOptions.curveLinear, UIViewAnimationOptions.allowUserInteraction], animations: {
                fromView.transform = fromView.transform.translatedBy(x: 0, y: fromView.bounds.size.height)
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
