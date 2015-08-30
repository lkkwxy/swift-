//
//  LKKDefaultBehavior.swift
//  321
//
//  Created by lkk on 15-3-26.
//  Copyright (c) 2015年 LKK. All rights reserved.
//

import UIKit

class LKKDefaultBehavior: UIDynamicBehavior {
    func add(Item:UIDynamicItem){
        for behaviors in self.childBehaviors{
            if ((behaviors as? UICollisionBehavior) != nil){
                (behaviors as! UICollisionBehavior).addItem(Item)
            }
            if ((behaviors as? UIGravityBehavior) != nil){
                (behaviors as! UIGravityBehavior).addItem(Item)
            }

        }
    }
    func remove(Item:UIDynamicItem){
        for behaviors in self.childBehaviors{
            if ((behaviors as? UICollisionBehavior) != nil){
                (behaviors as! UICollisionBehavior).addItem(Item)
            }
            if ((behaviors as? UIGravityBehavior) != nil){
                (behaviors as! UIGravityBehavior).addItem(Item)
            }

        }
    }
    override init() {
        super.init()
        let collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true;
        self.addChildBehavior(collisionBehavior)
        
        let gravityBehavior = UIGravityBehavior()
        self.addChildBehavior(gravityBehavior)
    }
}
