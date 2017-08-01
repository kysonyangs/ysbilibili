//
//  UIView+frameAdd.swift
//  Stopwatch
//
//  Created by MOLBASE on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension UIView {
    
    var ysX: CGFloat {
        get {
            return frame.origin.x
        }
        
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    
    var ysY: CGFloat {
        get {
            return frame.origin.y
        }
        
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    
    var ysWidth: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    
    var ysHeight: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
    
    var ysLeft: CGFloat {
        get {
            return ysX
        }
        
        set {
            ysX = newValue
        }
    }
    
    var ysTop:CGFloat {
        get {
            return ysY
        }
        
        set {
            ysY = newValue
        }
    }
    
    var ysRight: CGFloat {
        get {
            return ysX + ysWidth
        }
        
        set {
            ysX = newValue - ysWidth
        }
    }
    
    var ysBottom: CGFloat {
        get {
            return ysY + ysHeight
        }
        
        set {
            ysY = newValue - ysHeight
        }
    }
    
    var ysCenterX: CGFloat {
        get {
            return center.x
        }
        
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    var ysCenterY: CGFloat {
        get {
            return center.y
        }
        
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    var ysMiddleX: CGFloat {
        get {
            return ysWidth * 0.5
        }
    }
    
    var ysMiddleY: CGFloat {
        get {
            return ysHeight * 0.5
        }
    }
    
    var middlePoint: CGPoint {
        get {
            return CGPoint(x: ysMiddleX, y: ysMiddleY)
        }
    }
    
    @IBInspectable var ysCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var ysBoderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var ysBoderColor: UIColor {
        get {
            return UIColor.black
        }
        
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
