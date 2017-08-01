//
//  YSDynamicViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSDynamicViewController: YSBaseViewController {
    
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        var tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        return tableView
    }()
    
    fileprivate lazy var noLoginImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_forbidden")
        return imageView
    }()
    
    fileprivate lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = kNavBarColor
        loginButton.setTitle("登录", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginButton.layer.cornerRadius = kCellCornerRadius
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.titleLabel.text = "动态"
        
        view.addSubview(tableView)
        tableView.addSubview(noLoginImageview)
        tableView.addSubview(loginButton)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(64)
        }
        
        noLoginImageview.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableView)
            make.centerY.equalTo(tableView).offset(-150)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(tableView)
            make.top.equalTo(noLoginImageview.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 80, height: 24))
        }
        
    }

    

}
