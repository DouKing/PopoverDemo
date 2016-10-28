//
//  CustomPresentationController.swift
//  Popover
//
//  Created by iosci on 2016/10/11.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    
    var bgView: UIView!
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            print("error!")
            return
        }
        self.bgView = UIView(frame: containerView.bounds)
        self.bgView.backgroundColor = UIColor(white: 0, alpha: 0)
        containerView.insertSubview(self.bgView, at: 0)
        
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (UIViewControllerTransitionCoordinatorContext) in
                self.presentingViewController.view.transform = self.presentingViewController.view.transform.scaledBy(x: 0.9, y: 0.9)
                self.bgView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.bgView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (transitionCoordinatorContext) in
            self.presentingViewController.view.transform = CGAffineTransform.identity
            self.bgView.backgroundColor = UIColor(white: 0, alpha: 0)
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.bgView.removeFromSuperview()
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return CGRect.zero
        }
        let width: CGFloat = containerView.bounds.size.width
        let height: CGFloat = 400.0
        return CGRect(x: 0, y: containerView.bounds.size.height - height, width: width, height: height)
    }
    
    override var presentedView: UIView? {
        let v = self.presentedViewController.view
        v?.layer.cornerRadius = 5
        v?.clipsToBounds = true
        return v
    }
}
