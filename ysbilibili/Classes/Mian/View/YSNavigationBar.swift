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
        return backArrowButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 18)
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
        
        backArrowButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 40, height: 30))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: kScreenWidth - 140, height: 40))
        }
        
        leftItem?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(backArrowButton)
        })
        
        rightItem?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self).offset(10)
            make.right.equalTo(self.snp.right).offset(-20)
            make.size.equalTo(CGSize(width: 40, height: 30))
        })
    }

}
