//
//  UIImage+ysAdd.swift
//
//  Created by YangShen on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension UIImage {
    /// 处理拉升的背景图片
    func ysResizingImage() -> UIImage {
        let hinset = self.size.width  * 0.5
        let vinset = self.size.height * 0.5
        return self.resizableImage(withCapInsets: UIEdgeInsetsMake(vinset, hinset, vinset, hinset), resizingMode: .stretch)
    }
    
    func ysTintColor(_ tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor: tintColor, blendMode: .destinationIn)
    }
    
    func ysGradientTintColor(_ tintColor: UIColor) -> UIImage {
        return imageWithTintColor(tintColor: tintColor, blendMode: .overlay)
    }
    
    fileprivate func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(rect)
        
        self.draw(in: rect, blendMode: blendMode, alpha: 1.0)
        
        if blendMode != .destinationIn {
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage!
    }

}
