//
//  UIGestureRecognizer+ysAdd.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/1.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

extension UITapGestureRecognizer {
    typealias tapAction = () -> Void // @convention貌似是会把闭包变成block
    
    // 存储的key值(oc 一般用_cmd来当值，不知道swift里有没有类似的，查了貌似没找到)
    fileprivate struct AssociatedKeys {
        static var DescriptiveName = "ys_DescriptiveName"
    }
    
    convenience init(tap:tapAction) {
        self.init()
        self.addTarget(self, action: #selector(action))
        objc_setAssociatedObject(self,&AssociatedKeys.DescriptiveName,tap, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func action() {
        let tap = self.getAction()
        tap()
    }
    
    func getAction() -> tapAction{
        let action: AnyObject = objc_getAssociatedObject(self,&AssociatedKeys.DescriptiveName) as AnyObject
        return action as! UITapGestureRecognizer.tapAction
    }
    
}
