//
//  YSHomeViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSHomeViewController: YSBaseViewController {
    lazy var contentScrollView: UIScrollView = {[unowned self] in
        let contentScrollView = UIScrollView()
        contentScrollView.frame = self.view.bounds
        contentScrollView.contentSize = CGSize(width: self.view.frame.width*3, height: self.view.frame.height)
        contentScrollView.isPagingEnabled = true
        contentScrollView.backgroundColor = UIColor.orange
        return contentScrollView
        }()
    
    lazy var titleMenu: SlideMenu = { [unowned self] in
        
        // 1.frame
        let width: CGFloat = 200
        let height: CGFloat = 30
        let x = (self.view.ysWidth - width) / 2
        let y = kNavBarHeight - 30
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        // 2.平常的颜色
        let normalColor = SlideMenu.SlideMenuTitleColor(red: 230, green: 230, blue: 230)
        
        // 3.显示的颜色
        let hightLightColor = SlideMenu.SlideMenuTitleColor(red: 255, green: 255, blue: 255)
        
        // 4.生成slidemenu
        let menu = SlideMenu(frame: rect, titles: ["直播","推荐","追番"], padding: 30, normalColor: normalColor, highlightColor: hightLightColor, font: 16, sliderColor: UIColor.white, scrollView: self.contentScrollView, isHorizon: true, rowHeight: 30)
        menu.backgroundColor = kNavBarColor
        return menu
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化ui
        setupUI()
        
        // 默认选中中间的推荐
        self.contentScrollView.contentOffset = CGPoint(x: kScreenWidth, y: 0)
        
        // 监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(showLive), name: kHomeViewControllerShowLiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSHomeViewController {
    
    fileprivate func setupUI(){
        
        view.addSubview(contentScrollView)
        
        view.addSubview(titleMenu)
        
        addChildVCs()
    }
    
    fileprivate func addChildVCs() {
        
        // 1 直播
        let liveVC = UIViewController() //HomeLiveShowViewController()
        liveVC.view.backgroundColor = UIColor.ysRandomColor()
        self.addChildViewController(liveVC)
        contentScrollView.addSubview(liveVC.view)
        liveVC.view.frame = CGRect(x: 0, y: kNavBarHeight, width: view.ysWidth, height: view.ysHeight - kTabbarHeight)
        
        // 2 推荐
        let recommondVC = UIViewController() //HomeRecommendViewController()
        recommondVC.view.backgroundColor = UIColor.ysRandomColor()
        self.addChildViewController(recommondVC)
        contentScrollView.addSubview(recommondVC.view)
        recommondVC.view.frame = CGRect(x: view.ysWidth, y: kNavBarHeight, width: view.ysWidth, height: view.ysHeight - kTabbarHeight)
        
        // 3 番剧
        let serialVC = UIViewController() //HomebangumiViewController()
        serialVC.view.backgroundColor = UIColor.ysRandomColor()
        self.addChildViewController(serialVC)
        contentScrollView.addSubview(serialVC.view)
        serialVC.view.frame = CGRect(x: view.ysWidth*2, y: kNavBarHeight, width: view.ysWidth, height: view.ysHeight - kTabbarHeight)
    }
}

//======================================================================
// MARK:- notification
//======================================================================
extension YSHomeViewController {
    @objc func showLive() {
        DispatchQueue.main.async {
            self.contentScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: kScreenWidth, height: 100), animated: false)
        }
    }
}
