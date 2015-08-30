//
//  LKKCustonBehavior.swift
//  321
//
//  Created by lkk on 15-3-26.
//  Copyright (c) 2015年 LKK. All rights reserved.
//

import UIKit

typealias TearOffHandler = (LKKDragView,LKKDragView) -> Void
    

class LKKCustonBehavior: UIDynamicBehavior {
    var active = true
    init(draggableView:LKKDragView,anchor:CGPoint,handler:TearOffHandler) {
       super.init()
       self.addChildBehavior(UISnapBehavior(item: draggableView, snapToPoint: anchor))
        let distance:CGFloat = 100.0;
        self.action = {
            if(self.PointsAreWithinDistance(draggableView.center, toPoint: anchor, distance: distance)){
                if(self.active){
                    print(self)
                    let newView: LKKDragView = draggableView.copy() as! LKKDragView
                    draggableView.superview?.addSubview(newView)
                    let newTearOff = LKKCustonBehavior(draggableView: newView, anchor: anchor, handler: handler)
                    newTearOff.active = false
                    self.dynamicAnimator?.addBehavior(newTearOff)
                    print((CGFloat)(arc4random() % 255) / 255.0)
                    draggableView.backgroundColor = UIColor(red: (CGFloat)(arc4random() % 255) / 255.0, green: (CGFloat)(arc4random() % 255) / 255.0, blue: (CGFloat)(arc4random() % 255) / 255.0, alpha: 1.0)
                    handler(draggableView,newView)
                    self.dynamicAnimator?.removeBehavior(self)
                }
                
            
            }else{
                self.active = true
            }
        
        }

       
    }
    func PointsAreWithinDistance(p1:CGPoint,toPoint p2:CGPoint,
        distance:CGFloat) -> Bool{
        let distancex = p1.x - p2.x
        let distancey = p1.y - p2.y
        let currentDictance = (CGFloat)(hypotf((Float)(distancex), (Float)(distancey)))
        return currentDictance > distance
    }
}
