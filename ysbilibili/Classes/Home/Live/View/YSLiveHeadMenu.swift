//
//  HomeLiveHeadMenu.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class YSLiveHeadMenu: UIView {
    
    struct HeadItem {
        var title: String
        var imageName: String
    }
    
    fileprivate let items = [
        HeadItem(title: "关注", imageName: "live_home_follow_ico"),
        HeadItem(title: "中心", imageName: "live_home_center_ico"),
        HeadItem(title: "小视频", imageName: "live_home_video_ico"),
        HeadItem(title: "搜索", imageName: "live_home_search_ico"),
        HeadItem(title: "分类", imageName: "live_home_category_ico")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bWidth = kScreenWidth / CGFloat(items.count)
        for (index, headItem) in items.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = index
            button.addTarget(self, action: #selector(menuChoseAction(_:)), for: .touchUpInside)
            self.addSubview(button)
            button.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(self)
                make.width.equalTo(bWidth)
                make.left.equalTo(self).offset(bWidth * CGFloat(index))
            })
            let imgv = UIImageView(image: UIImage(named: headItem.imageName))
            button.addSubview(imgv)
            let textLabel = UILabel()
            textLabel.text = headItem.title
            textLabel.font = UIFont.systemFont(ofSize: 12)
            textLabel.textAlignment = .center
            button.addSubview(textLabel)
            
            imgv.snp.makeConstraints({ (make) in
                make.centerX.equalTo(button)
                make.size.equalTo(CGSize(width: 50, height: 50))
                make.centerY.equalTo(button).offset(-10)
            })
            
            textLabel.snp.makeConstraints({ (make) in
                make.centerX.equalTo(button)
                make.left.right.equalTo(button)
                make.top.equalTo(imgv.snp.bottom)
                make.height.equalTo(20)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func menuChoseAction(_ sender: UIButton) {
        print(sender.tag)
    }
}
