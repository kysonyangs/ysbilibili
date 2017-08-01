//
//  YSMainTabBarController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSMainTabBarController: UITabBarController {
    
    struct MainTabBarItem {
        var title = ""
        var image = ""
        var selectedImage = ""
    }
    
    fileprivate lazy var controllerArray: [UIViewController] = {
        var controllers = [UIViewController]()
        
        let item1 = YSMainNavigationController(rootViewController: UIViewController())
        controllers.append(item1)
        
        let item2 = YSMainNavigationController(rootViewController: YSZoneViewController())
        controllers.append(item2)
        
        let item3 = YSMainNavigationController(rootViewController: YSDynamicViewController())
        controllers.append(item3)
        
        let item4 = YSMainNavigationController(rootViewController: YSMineViewController())
        controllers.append(item4)
        
        return controllers
    }()
    
    fileprivate lazy var tabbarItemArray: [MainTabBarItem] = {
        var tabbarItems = [MainTabBarItem]()
        
        let item1 = MainTabBarItem(title: "首页", image: "home_home_tab", selectedImage: "home_home_tab_s")
        tabbarItems.append(item1)
        
        let item2 = MainTabBarItem(title: "分区", image: "home_category_tab", selectedImage: "home_category_tab_s")
        tabbarItems.append(item2)
        
        let item3 = MainTabBarItem(title: "动态", image: "home_attention_tab", selectedImage: "home_attention_tab_s")
        tabbarItems.append(item3)
        
        let item4 = MainTabBarItem(title: "我的", image: "home_mine_tab", selectedImage: "home_mine_tab_s")
        tabbarItems.append(item4)
        
        return tabbarItems
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tabBar.isTranslucent = false
        tabBar.tintColor = kNavBarColor
        
        for (index, vc) in controllerArray.enumerated() {
            let tabbarItem = tabbarItemArray[index]
            vc.tabBarItem.image = UIImage(named: tabbarItem.image)
            vc.tabBarItem.selectedImage = UIImage(named: tabbarItem.selectedImage)
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            addChildViewController(vc)
        }
        
    }
    
    // 和statusbar的旋转相呼应
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

}
