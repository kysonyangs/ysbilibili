//
//  YSMainNavigationController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSMainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        isNavigationBarHidden = true
        
        // 设置导航控制器
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = kNavBarColor
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                      NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if viewController.isKind(of: YSBaseViewController.self) {
                let vc = viewController as! YSBaseViewController
                vc.naviBar.backArrowButton.isHidden = false
            }
        }
        super.pushViewController(viewController, animated: animated)
    }

}
