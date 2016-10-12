//
//  ViewController.swift
//  Popover
//
//  Created by iosci on 2016/10/9.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIViewControllerTransitioningDelegate {

    var interactionController: UIPercentDrivenInteractiveTransition?
    var psController: UIPresentationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_panForPresent(_:)))
        self.view.addGestureRecognizer(pan)
    }

    @IBAction func _tap(_ sender: UIButton) {
        let popover = PopoverViewController()
        popover.modalPresentationStyle = .popover
        
        popover.popoverPresentationController?.backgroundColor = UIColor.red
        popover.popoverPresentationController?.sourceView = sender
        popover.popoverPresentationController?.sourceRect = sender.bounds
        popover.popoverPresentationController?.permittedArrowDirections = .up
        popover.popoverPresentationController?.delegate = self
        
        present(popover, animated: true, completion: nil)
    }
    
    func _panForPresent(_ gesture: UIPanGestureRecognizer) -> Void {
        let offsetY = -gesture.translation(in: self.view).y
        let persent = offsetY / 400.0
        
        switch gesture.state {
        case .began:
            self.interactionController = UIPercentDrivenInteractiveTransition()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "SecondNav")
            let pan = UIPanGestureRecognizer(target: self, action: #selector(_handle(panGesture:)))
            nav.view.addGestureRecognizer(pan)
            nav.modalPresentationStyle = .custom
            nav.transitioningDelegate = self
            self.present(nav, animated: true, completion: nil)
        case .changed:
            if persent < 0 || persent > 1 {
                break
            }
            self.interactionController?.update(persent)
        case .ended:
            self.interactionController?.finish()
            self.interactionController = nil
        case .cancelled:
            self.interactionController?.cancel()
            self.interactionController = nil
        default: break
            
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func _handle(panGesture gesture: UIPanGestureRecognizer) -> Void {
        let offsetY = gesture.translation(in: self.view).y
        let persent = offsetY / 400.0
        
        switch gesture.state {
        case .began:
            self.interactionController = UIPercentDrivenInteractiveTransition()
            self.dismiss(animated: true, completion: nil)
        case .changed:
            self.interactionController?.update(persent)
        case .ended:
            self.interactionController?.finish()
            self.interactionController = nil
        case .cancelled:
            self.interactionController?.cancel()
            self.interactionController = nil
        default: break
            
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let customPresentationController = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        return customPresentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTranstion(transtionStyle: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTranstion(transtionStyle: .present)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(_handle(panGesture:)))
        nav.view.addGestureRecognizer(pan)
        
        nav.modalPresentationStyle = .custom
        nav.transitioningDelegate = self
    }
}


