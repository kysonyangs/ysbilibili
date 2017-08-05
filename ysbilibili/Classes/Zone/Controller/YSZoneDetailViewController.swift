//
//  YSZoneDetailViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

fileprivate let kMenuRowHeight: CGFloat = 26
let kMiniPadding: CGFloat = 20

class YSZoneDetailViewController: YSBaseViewController {

    var zoneModel: YSZoneModel?
    
    fileprivate var menuView: SlideMenu?
    fileprivate lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = kHomeBackColor
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        initialControllers()
    }
}

//======================================================================
// MARK:- private method
//======================================================================
extension YSZoneDetailViewController {
    fileprivate func setupUI() {
        view.backgroundColor = kNavBarColor
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        naviBar.titleLabel.text = zoneModel?.name
        naviBar.backArrowButton.isHidden = false
        naviBar.backArrowButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        view.addSubview(contentScrollView)
        let titleArray = zoneModel?.titleArray()
        contentScrollView.frame = CGRect(x: 0, y: kNavBarHeight + kMenuRowHeight, width: kScreenWidth, height: kScreenHeight)
        contentScrollView.contentSize = CGSize(width: kScreenWidth * CGFloat((zoneModel?.children?.count)!), height: 1)
        contentScrollView.isPagingEnabled = true
        contentScrollView.panGestureRecognizer.require(toFail: (navigationController?.interactivePopGestureRecognizer)!)
        
        let normalColor = SlideMenu.SlideMenuTitleColor(red: 230, green: 230, blue: 230)
        let hightLightColor = SlideMenu.SlideMenuTitleColor(red: 255, green: 255, blue: 255)
        
        menuView = SlideMenu(frame: CGRect(x: 10, y: 10, width: kScreenWidth - 20, height: 30), titles: titleArray!, padding: kMiniPadding, normalColor: normalColor, highlightColor: hightLightColor, font: 13, sliderColor: UIColor.white, scrollView: contentScrollView, rowHeight: kMenuRowHeight)
        view.addSubview(menuView!)
        
        
        let menuHeight = kMenuRowHeight * CGFloat((menuView?.rowCount)!) + CGFloat((menuView?.rowCount)! - 1) * (menuView?.kVerticalPadding)!
        
        menuView?.frame = CGRect(x: 10, y: kNavBarHeight, width: kScreenWidth - 20, height: menuHeight)
        contentScrollView.frame = CGRect(x: 0, y: kNavBarHeight + menuHeight, width: kScreenWidth, height: kScreenHeight - (kNavBarHeight + menuHeight))
    }
    
    @objc fileprivate func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func initialControllers() {
        guard let count = zoneModel?.children?.count else {return}
        for i in 0..<count {
            let vc = YSZoneItemViewController()
            vc.zoneItemModel = zoneModel?.children?[i]
            addChildViewController(vc)
            contentScrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: kScreenWidth * CGFloat(i), y: 0, width: kScreenWidth, height: contentScrollView.ysHeight)
            vc.inset = UIEdgeInsetsMake(0, 0, contentScrollView.ysY, 0)
        }
    }
}

//======================================================================
// MARK:- UIGestureRecognizerDelegate
//======================================================================
extension YSZoneDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
