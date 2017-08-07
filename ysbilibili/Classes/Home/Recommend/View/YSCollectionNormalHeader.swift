//
//  YSCollectionNormalHeader.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSCollectionNormalHeader: UIView {
    enum headerType {
        /// 普通的类型(类似  更多音乐> )
        case normal
        /// 推荐的直播(类似  当前XXX个主播> )
        case recommdLive
        /// 直播(类似  当前有XXX个主播,进去看看> )
        case live
        /// 热门推荐(类似  [img] 排行榜 > )
        case hotrecommd
    }
    
    // MARK: - 属性 set 方法
    var statusModel: YSRecommendModel? {
        didSet{
            
            iconLabel.text = statusModel?.title
            
            // 1.判断type 和 param存不存在
            guard let type = statusModel?.type else {return}
            guard let param = statusModel?.param else {return}
            
            // 2.拼接图片sring
            let imageStr = "home_\(type)_icon_\(param)"
            
            // 3.赋值图片
            iconImageView.image = UIImage(named: imageStr)
            
            // 4.赋值type类型
            if let model = statusModel {
                reinitWithType(type: type, status: model)
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        return iconImageView
    }()
    
    lazy var iconLabel: UILabel = {
        let iconLabel = UILabel()
        iconLabel.font = kCollectionHeaderTitleFont
        return iconLabel
    }()
    
    lazy var arrImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "more_arrow")
        arrowImageView.contentMode = UIViewContentMode.center
        return arrowImageView
    }()
    
    lazy var rightIconImageView: UIImageView = {
        let rightIconImageView = UIImageView()
        rightIconImageView.image = UIImage(named: "home_rank")
        return rightIconImageView
    }()
    
    lazy var noticeLabel: UILabel = {
        let noticeLabel = UILabel()
        noticeLabel.text = "更多"
        noticeLabel.textColor = kHomeHeadRightTextColor
        noticeLabel.font = kCollectionHeaderTitleFont
        return noticeLabel
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
        self.addSubview(iconImageView)
        self.addSubview(iconLabel)
        self.addSubview(arrImageView)
        self.addSubview(noticeLabel)
        self.addSubview(rightIconImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(kPadding)
            make.centerY.equalTo(self).offset(kCenterPadding)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        iconLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(kCenterPadding)
            make.left.equalTo(iconImageView.snp.right).offset(5)
        }
        
        arrImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-kPadding)
            make.centerY.equalTo(self).offset(kCenterPadding)
            make.size.equalTo(CGSize(width: 10, height: 15))
        }
        
        noticeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(kCenterPadding)
            make.right.equalTo(arrImageView.snp.left).offset(-5)
        }
        
        rightIconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(noticeLabel.snp.left).offset(-5)
            make.centerY.equalTo(self).offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
    }
}

// MARK: - 私有方法
extension YSCollectionNormalHeader {
    
    fileprivate func reinitWithType(type:String,status:YSRecommendModel) {
        
        // 1.排行榜
        if type == "recommend" {
            rightIconImageView.isHidden = false
            noticeLabel.text = "排行榜"
            noticeLabel.textColor = kNormalHearTextHotColor
            return
        }
        
        // 2.推荐里的直播
        if type == "live" {
            rightIconImageView.isHidden = true
            noticeLabel.textColor = kHomeHeadRightTextColor
            if let livecount = status.ext?.live_count {
                let countString = String.creatCountString(count: livecount)
                let attrStr = String.creatAttributesText(countString: countString, beginStr: "当前", endStr: "个直播")
                noticeLabel.attributedText = attrStr
            }
            return
        }
        
        // 3.普通情况
        rightIconImageView.isHidden = true
        noticeLabel.textColor = kHomeHeadRightTextColor
        if let title = status.title {
            let nstitle = NSString(string: title)
            let typeTitle = nstitle.substring(to: 2)
            noticeLabel.text = "更多\(typeTitle)"
        }
        
        return
    }
}

