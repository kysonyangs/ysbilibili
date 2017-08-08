//
//  YSNavigationBar.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSNavigationBar: UIView {

    // MARK: - 左右item自定义的情况
    var leftItem: UIView? {
        didSet {
            if leftItem != nil {
                self.addSubview(leftItem!)
                backArrowButton.isHidden = true
            }
        }
    }
    var rightItem: UIView? {
        didSet {
            if rightItem != nil {
                self.addSubview(rightItem!)
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var backArrowButton: UIButton = {
        let backArrowButton = UIButton()
        backArrowButton.setImage(UIImage(named: "common_back_v2"), for: .normal)
        backArrowButton.setImage(UIImage(named: "common_back_v2"), for: .highlighted)
        backArrowButton.isHidden = true
        return backArrowButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backArrowButton)
        addSubview(titleLabel)
        backgroundColor = kNavBarColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(8)
            make.size.equalTo(CGSize(width: kScreenWidth - 140, height: 44))
        }
        
        backArrowButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(self)
            make.size.equalTo(CGSize(width: 40, height: 44))
        }
        
        leftItem?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(backArrowButton)
        })
        
        rightItem?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(self.snp.right)
            make.size.equalTo(CGSize(width: 40, height: 44))
        })
    }

}
