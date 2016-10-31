//
//  DetailViewController.swift
//  Popover
//
//  Created by iosci on 2016/10/28.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let animator = WYPopoverAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func _testPopoverAction(_ sender: UIButton) {
        let vc = PopoverViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.animator
        vc.wy_popoverPresentationController?.backgroundColor = UIColor.red
        vc.wy_popoverPresentationController?.sourceView = sender
        vc.wy_popoverPresentationController?.sourceRect = sender.bounds
        vc.wy_popoverPresentationController?.permittedArrowDirections = .down
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return WYPopoverPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
