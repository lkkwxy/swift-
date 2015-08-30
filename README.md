###最近搞了一下物理仿真行为，demo效果如下图，一共分为3部分
####一、拖拽上面的灰色view产生新的view
####二、下面的view之间的相互碰撞
####三、双击时以小方块的形式向外面散去
![效果如图](http://img.blog.csdn.net/20150830090731421)

###首先先说一下我的实现思路：
####一、给上面的黑色view添加拖拽手势，并在拖拽手势的方法里添加UISnapBehavior捕捉行为，在拖动的过程中不断改变捕捉点即
snapPoint。核心代码如下
```
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
```
#### 二：双击时向四周分散的销毁的过程，首先把view分成好多个小view，然后给每个小view添加UIPushBehavior推动行为，代码如下

```
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

```

####三：下面可以相互碰撞的view，给他们添加了重力，碰撞和捕捉行为，并且他们都有Pan手势，在移动的过程中改变捕捉点，

