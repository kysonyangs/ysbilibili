//
//  HomeBangumiTopView.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/3.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class YSBangumiTopView: UICollectionReusableView {
    
    // MARK: - 外部赋值属性
    var isNoBanner = false
    var bannerModelArray: [YSHomeBangumiADdetailModel]?
    var imgStringArray: [String]? {
        didSet{
            guard let count = imgStringArray?.count else {return}
            if count > 0 {
                carouselView.intnetImageArray = imgStringArray
                carouselView.snp.remakeConstraints { (make) in
                    make.top.left.right.equalTo(self)
                    make.height.equalTo(kCarouseHeight)
                }
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var carouselView: YSCarouselView = {
        let carouselView = YSCarouselView(viewframe: CGRect(x: 0, y: 0, width: kScreenWidth, height: kCarouseHeight))
        carouselView.delegate = self
        return carouselView
    }()
    
    fileprivate lazy var menuView: YSBangumiMenuView = {
        let menuView = YSBangumiMenuView.instanceView()
        return menuView
    }()
    
    fileprivate lazy var noticeHead: YSCollectionNormalHeader = {
        let noticeHead = YSCollectionNormalHeader()
        noticeHead.rightIconImageView.isHidden = true
        return noticeHead
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(carouselView)
        self.addSubview(menuView)
        self.addSubview(noticeHead)
        self.backgroundColor = kHomeBackColor
        noticeHead.iconLabel.text = "新番连载"
        noticeHead.iconImageView.image = UIImage(named: "bangumi_unfinished")
        noticeHead.noticeLabel.text = "更多连载"
        carouselView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        menuView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.height.equalTo(140)
            make.top.equalTo(carouselView.snp.bottom)
        }
        
        noticeHead.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(menuView.snp.bottom).offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YSBangumiTopView: YSCarouselViewDelegate {
    func carouselViewSelectedIndex(index: Int) {
        guard let model = bannerModelArray?[index] else {return}
        guard let link = model.link else {return}
        YSNotificationHelper.bangumicarouselClickNotification(link: link)
    }
}
