//
//  ViewController.swift
//  321
//
//  Created by lkk on 15-3-26.
//  Copyright (c) 2015年 LKK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var defaultBehavior:LKKDefaultBehavior!
    var animator:UIDynamicAnimator!
    var snap:UISnapBehavior!
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化物理仿真器
        self.animator = UIDynamicAnimator(referenceView: self.view)
        let dragView = LKKDragView(frame: CGRectMake(300, 100, 50, 50), animator: self.animator)
        dragView.alpha = 0.5
        self.view.addSubview(dragView)
        self.defaultBehavior = LKKDefaultBehavior()
        let custom = LKKCustonBehavior(draggableView: dragView, anchor: dragView.center, handler:{(tornView,newPinView) in
            tornView.alpha = 1;
            self.defaultBehavior.add(tornView)
            let tap = UITapGestureRecognizer(target: self, action: "split:")
            tornView.addGestureRecognizer(tap)
            tap.numberOfTapsRequired = 2
      
       })
        self.animator.addBehavior(custom)
        self.animator.addBehavior(defaultBehavior)
    }
    //双击
    func split(tap:UITapGestureRecognizer){
        
        let view1 = tap.view;
        //分割View
        let subview = sliceView(view1!)
        let trashAnimator = UIDynamicAnimator(referenceView: self.view)
        for(var i = 0;i < subview.count;i++){
            let addView = subview[i] as! UIView
            self.view.addSubview(addView)
            //设置push行为
            let push = UIPushBehavior(items: [addView], mode: UIPushBehaviorMode.Continuous)
            //设置push方向
            push.pushDirection =
                CGVectorMake((CGFloat)((CGFloat)(rand()) * 1.0 / (CGFloat)(RAND_MAX)) - 0.5,(CGFloat)((CGFloat)(rand()) * 1.0 / (CGFloat)(RAND_MAX)) - 0.5)
            //在仿真器中添加行为
            trashAnimator.addBehavior(push)
            UIView.animateWithDuration(2, animations: { () -> Void in
                addView.alpha = 0.0
            }, completion: { (completion) -> Void in
                addView.removeFromSuperview()
                trashAnimator.removeBehavior(push)
            })

        }
        self.animator = trashAnimator;
        self.defaultBehavior.remove(view1!)
        view1!.removeFromSuperview()
    }
    //分割view
    func sliceView(tempView:UIView) -> NSArray{
        let array = NSMutableArray()
        //首先通过View得到一个UIImage
        UIGraphicsBeginImageContext(tempView.bounds.size)
        tempView.drawViewHierarchyInRect(tempView.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let row = 6
        let column = 6
        let width = tempView.bounds.size.width / (CGFloat)(row)
        let height = tempView.bounds.size.height / (CGFloat)(column)
        
        for i in 1...row {
            for j in 1...column{
                let rect = CGRectMake((CGFloat)(i - 1) * width, (CGFloat)(j - 1) * height, width, height)
                //把UIImage分割成好多小UIImage
                let smallImage = CGImageCreateWithImageInRect(image.CGImage, rect)
                let imageView = UIImageView(image: UIImage(CGImage: smallImage!))
                let rect1 = CGRectOffset(rect, CGRectGetMinX(tempView.frame), CGRectGetMinY(tempView.frame))
                
                imageView.backgroundColor = UIColor.yellowColor()
                imageView.frame = rect1
                array.addObject(imageView)
            }
        }
        return array
    }

}

