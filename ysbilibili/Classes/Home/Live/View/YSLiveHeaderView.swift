//
//  homeLivehead.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kLiveMenuHeight: CGFloat = 100

class YSLiveHeaderView: UICollectionReusableView {

    // 普通的头部数据
    var headModel: YSLiveHeadModel? {
        didSet {
            // 1. 设置图标
            if let imgStr = headModel?.sub_icon?.src {
                let imgUrl = URL(string: imgStr)
                contentView.iconImageView.kf.setImage(with: imgUrl)
            }
            // 2. 设置坐标的标题
            contentView.iconLabel.text = headModel?.name
            
            // 3. 设置标题的文字
            let countString = String.creatCountString(count: (headModel?.count)!)
            let attrStr = String.creatAttributesText(countString: countString, beginStr: "当前", endStr: "个直播,进去看看")
            contentView.noticeLabel.attributedText = attrStr
            
            // 4. 设置arrowimage
            contentView.arrImageView.image = UIImage(named: "common_rightArrowShadow")
            contentView.rightIconImageView.isHidden = true
            
            // 5. 更改控件位置
            normalHead()
        }
    }
    
    // 带banner的数据
    var bannerModelArray: [YSLiveBannerModel]? {
        didSet{
            // 1. 赋值数据
            var imageStringArray = [String]()
            guard let bannerModelArray = bannerModelArray else {return}
            for model in bannerModelArray{
                guard let imgString = model.img else {return}
                imageStringArray.append(imgString)
            }
            carouselView.intnetImageArray = imageStringArray
           
            // 2.更改位置
            topHead()
        }
    }
    
    // MARK: - 懒加载控件
    lazy var contentView: YSCollectionNormalHeader = {
        let conteView = YSCollectionNormalHeader()
        return conteView
    }()
    
    lazy var carouselView: YSCarouselView = {
        let carouselView = YSCarouselView(viewframe: CGRect(x: 0, y: 0, width: kScreenWidth, height: kCarouseHeight))
        carouselView.delegate = self
        return carouselView
    }()
    
    lazy var menuView: YSLiveHeadMenu = {
        let menuView = YSLiveHeadMenu()
        menuView.backgroundColor = kHomeBackColor
        return menuView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
        self.addSubview(carouselView)
        self.addSubview(menuView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 私有方法
extension YSLiveHeaderView {
    // 普通头部的内部控件的位置
    fileprivate func normalHead() {
        menuView.isHidden = true
        carouselView.removeFromSuperview()
        menuView.removeFromSuperview()
        
        contentView.snp.remakeConstraints { (make) in
            make.left.top.bottom.right.equalTo(self)
        }
    }
    
    // 第一个section的内部控件的位置
    fileprivate func topHead() {
        menuView.isHidden = false
        self.addSubview(carouselView)
        self.addSubview(menuView)
        
        carouselView.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(kCarouseHeight)
        }
        
        menuView.snp.remakeConstraints { (make) in
            make.top.equalTo(carouselView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(kLiveMenuHeight)
        }
        
        contentView.snp.remakeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.top.equalTo(menuView.snp.bottom)
        }
    }

}

extension YSLiveHeaderView: YSCarouselViewDelegate {
    func carouselViewSelectedIndex(index: Int) {
        guard let model = bannerModelArray?[index] else {return}
        guard let link = model.link else {return}
        YSNotificationHelper.livecarouselClickNotification(link: link)
    }
}

