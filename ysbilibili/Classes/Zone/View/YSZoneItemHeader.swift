//
//  YSZoneItemHeader.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/4.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

enum ZoneItemHeaderType {
    case recommend
    case new
}

class YSZoneItemHeader: UIView {
    var type: ZoneItemHeaderType = .recommend {
        didSet {
            if type == .new {
                iconImageView.image = UIImage(named: "home_new_region")
                nameLabel.text = "最新投稿"
            } else if type == .recommend {
                iconImageView.image = UIImage(named: "home_recommend_icon_0")
                nameLabel.text = "热门推荐"
            }
        }
    }
    
    // Mark: - 懒加载控件
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home_recommend_icon_0")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "热门推荐"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(nameLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(CGSize(width: 20, height: 15))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }
    }

}
