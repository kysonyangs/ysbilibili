//
//  YSBaseViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSBaseViewController: UIViewController {
    
    lazy var naviBar: YSNavigationBar = {
        let naviBar = YSNavigationBar()
        return naviBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kNavBarColor
        //        automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.height.equalTo(kNavBarHeight)
        }
        naviBar.backArrowButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    }
    
    @objc func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }

}
