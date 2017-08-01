//
//  YSZoneCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import Kingfisher

class YSZoneCell: UICollectionViewCell {
    var zoneModel: YSZoneModel? {
        didSet {
            if let logo = zoneModel?.logo {
                iconImageView.kf.setImage(with: URL(string: logo))
            }
            titleLabel.text = zoneModel?.name
        }
    }
    
    fileprivate var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.ysCornerRadius = kCellCornerRadius
        return imageView
    }()
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = kHomeBackColor
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
            make.centerX.equalTo(contentView)
        }
    }
    
}
