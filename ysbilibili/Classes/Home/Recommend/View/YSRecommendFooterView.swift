//
//  YSrecommendFooterView.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

let kFootButtonHeight: CGFloat = 50
let kFootCarouselViewHeight: CGFloat = 110
let kFootCarouselPadding: CGFloat = 10
let kFootButtonVpadding: CGFloat = 10

class YSRecommendFooterView: UICollectionReusableView {
    enum footType {
        
        /// 普通 只有banner
        case normal
        /// 番剧 banner没值
        case bangumi
        /// 番剧 banner 有值
        case bangumiWithBanner
        /// 没有footer
        case none
    }
    
    // MARK: - 属性 set 方法
    var type:footType = .normal{
        
        didSet{
            // 重置状态
            switch type {
            // 普通情况 只有banner
            case .normal:
                
                everydayPushButton.isHidden = true
                bangumiIndexButton.isHidden = true
                self.addSubview(carouselView)
                carouselView.frame = CGRect(origin: CGPoint(x: 0, y: kFootCarouselPadding), size: bounds.size)
            // 番剧 没有banner
            case .bangumi:
                carouselView.removeFromSuperview()
                everydayPushButton.isHidden = false
                bangumiIndexButton.isHidden = false
                let width = (kScreenWidth - 3*kPadding)/2
                everydayPushButton.frame = CGRect(x: kPadding, y: kFootButtonVpadding, width: width, height: kFootButtonHeight)
                bangumiIndexButton.frame = CGRect(x: kPadding * 2 + width, y: kFootButtonVpadding, width: width, height: kFootButtonHeight)
            // 番剧 有banner
            case .bangumiWithBanner:
                self.addSubview(carouselView)
                everydayPushButton.isHidden = false
                bangumiIndexButton.isHidden = false
                
                let width = (kScreenWidth - 3*kPadding)/2
                everydayPushButton.frame = CGRect(x: kPadding, y: kFootButtonVpadding, width: width, height: kFootButtonHeight)
                bangumiIndexButton.frame = CGRect(x: kPadding * 2 + width, y: kFootButtonVpadding, width: width, height: kFootButtonHeight)
                let maxY = bangumiIndexButton.frame.maxY
                carouselView.frame = CGRect(x: 0, y: maxY + 20, width: kScreenWidth, height: kFootCarouselViewHeight)
            case .none:
                everydayPushButton.isHidden = true
                bangumiIndexButton.isHidden = true
                carouselView.removeFromSuperview()
            }
        }
    }
    
    var statusModel: YSRecommendModel? {
        
        didSet{
            // banner设置
            guard let banner = statusModel?.banner?.bottom else{return}
            
            var imageAry = [String]()
            for bannerItem in banner {
                imageAry.append(bannerItem.image!)
            }
            carouselView.intnetImageArray = imageAry
            carouselView.selectedAction = {(_ index: Int) in
                let bannerMdel = banner[index]
                guard let bannerURL = bannerMdel.uri else {return}
                YSNotificationHelper.recommedcarouselClickNotification(link: bannerURL)
            }
        }
    }
    
    // MARK: - 懒加载控件
    lazy var carouselView: YSCarouselView = {[unowned self] in
        let carouselFrame = CGRect(x: 0, y: 0, width: kScreenWidth, height:kFootCarouselViewHeight)
        let carouselView = YSCarouselView(viewframe: carouselFrame)
        carouselView.backgroundColor = kHomeBackColor
        return carouselView
        }()
    
    /// 每日推荐按钮 （猥琐的用了imageview button设置图片老是拉伸）
    lazy var everydayPushButton: UIImageView = {
        let everydayPushButton = UIImageView()
        everydayPushButton.image = UIImage(named:"hd_home_bangumi_timeline")
        everydayPushButton.contentMode = UIViewContentMode.scaleAspectFill
        everydayPushButton.clipsToBounds = true
        everydayPushButton.isUserInteractionEnabled = true
        everydayPushButton.layer.cornerRadius = kCellCornerRadius
        return everydayPushButton
    }()
    
    /// 番剧索引按钮
    lazy var bangumiIndexButton: UIImageView = {
        let bangumiIndexButton = UIImageView()
        bangumiIndexButton.image = UIImage(named:"hd_home_bangumi_category")
        bangumiIndexButton.contentMode = UIViewContentMode.scaleAspectFill
        bangumiIndexButton.clipsToBounds = true
        bangumiIndexButton.isUserInteractionEnabled = true
        bangumiIndexButton.layer.cornerRadius = kCellCornerRadius
        //        bangumiIndexButton.aliCornerRadius = kcellcornerradius
        return bangumiIndexButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kHomeBackColor
        self.addSubview(carouselView)
        self.addSubview(everydayPushButton)
        self.addSubview(bangumiIndexButton)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YSRecommendFooterView {
    
    /// 判断foot的类型
    class func returnFootType(statusModel:YSRecommendModel) -> YSRecommendFooterView.footType {
        if statusModel.type == "bangumi" {// 番剧
            if (statusModel.banner?.bottom) != nil {
                return .bangumiWithBanner
            }
            return .bangumi
        }else{
            if statusModel.banner?.bottom != nil {
                return .normal
            }
            return .none
        }
    }
    
    // head管理自己的高度
    class func returnFoodHeight(statusModel:YSRecommendModel) ->CGFloat {
        let type = YSRecommendFooterView.returnFootType(statusModel: statusModel)
        switch type {
        case .none:
            return 0
        case .normal:
            return kFootCarouselViewHeight + kFootCarouselPadding
        case .bangumi:
            return 2 * kFootButtonVpadding + kFootButtonHeight
        case.bangumiWithBanner:
            return 190
        }
    }
}
