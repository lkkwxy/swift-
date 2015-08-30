//
//  LKKDragView.swift
//  321
//
//  Created by lkk on 15-3-26.
//  Copyright (c) 2015年 LKK. All rights reserved.
//

import UIKit

class LKKDragView: UIView,NSCopying {
    var animator:UIDynamicAnimator!
    var snap:UISnapBehavior!
    func copyWithZone(zone: NSZone) -> AnyObject {
        let newView = LKKDragView(frame: CGRectZero, animator: self.animator)
        newView.bounds = self.bounds;
        newView.center = self.center;
        newView.transform = self.transform;
        newView.alpha = self.alpha;
        return newView
    }
    
    init(frame: CGRect,animator:UIDynamicAnimator) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.grayColor()
        self.animator = animator
        let pan = UIPanGestureRecognizer(target: self, action: "pan:")
        self.addGestureRecognizer(pan)
    }
    func pan(pan:UIPanGestureRecognizer){
        if(pan.state == UIGestureRecognizerState.Ended || pan.state == UIGestureRecognizerState.Cancelled){
            self.animator.removeBehavior(snap)
            self.snap = nil
        }else{
            if let _ = snap{
                self.animator.removeBehavior(snap)
            }
            self.snap = UISnapBehavior(item: self, snapToPoint: pan.locationInView(self.superview))
            self.snap.damping = 0.25
            self.animator.addBehavior(self.snap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
