//
//  HomeLiveFoot.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class YSLiveFooterView: UICollectionReusableView {
    
    lazy var allLiveButton: UIButton = {
        let allButton = UIButton()
        allButton.layer.cornerRadius = 5
        allButton.setTitle("全部直播", for: .normal)
        allButton.setTitleColor(UIColor.black, for: .normal)
        allButton.backgroundColor = UIColor.white
        allButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        allButton.ysBorderWidth = kLineHeight
        allButton.ysBorderColor = kCellLineBlackColor
        return allButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(allLiveButton)
        allLiveButton.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
