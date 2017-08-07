//
//  AppDelegate.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.setStatusBarHidden(false, with: .fade)
        // 初始化控制器
        initMainController()
        // 加载动画
        splashAnimate()
        // 显示FPS
        YSFPSStatus.shared.open()
        // 添加观察者观察网络变化
        YSNetworkTool.shared.startNetworkObserver()
        
        return true
    }
    
    fileprivate func splashAnimate() {
        let backImageView = UIImageView()
        backImageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "bilibili_splash_iphone_bg@3x", ofType: "png")!)
        backImageView.contentMode = .scaleAspectFill
        backImageView.frame = window!.bounds
        let splashView = UIImageView()
        splashView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "bilibili_splash_default@3x", ofType: "png")!)
        splashView.bounds = CGRect(x: 0, y: 0, width: backImageView.ysWidth * 0.7, height: backImageView.ysHeight * 0.7)
        splashView.center = CGPoint(x: backImageView.ysCenterX, y: backImageView.ysCenterY - backImageView.ysHeight * 0.3 / 2)
        backImageView.addSubview(splashView)
        splashView.transform = splashView.transform.scaledBy(x: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.8, animations: {
            splashView.isHidden = false
            splashView.transform = CGAffineTransform.identity
        }) { (complete) in
            DispatchQueue.afer(time: 0.5, action: {
                backImageView.removeFromSuperview()
            })
        }
        window?.addSubview(backImageView)
    }
    
    fileprivate func initMainController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = YSMainTabBarController()
        window?.makeKeyAndVisible()
    }

}

