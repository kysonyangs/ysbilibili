//
//  UIView+captureImage.swift
//
//  Created by YangShen on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension UIView {
    /// 截图
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
