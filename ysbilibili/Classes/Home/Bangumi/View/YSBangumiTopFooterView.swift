//
//  HomeBangumiTopFoot.swift
//  zhnbilibili
//
//  Created by zhn on 16/12/4.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class YSBangumiTopFooterView: UICollectionReusableView {
    
    // 数据
    var modelArray: [YSHomeBangumiADdetailModel]?
    
    // MARK: - 懒加载控件
    lazy var carouselView: YSCarouselView = {
        let carouselView = YSCarouselView(viewframe: CGRect(x: 0, y: 0, width: kScreenWidth, height: kCarouseHeight))
        return carouselView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(carouselView)
        carouselView.layer.cornerRadius = 6
        carouselView.layer.masksToBounds = true
        carouselView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        carouselView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kPadding))
        }
    }
}

extension YSBangumiTopFooterView: YSCarouselViewDelegate {
    func carouselViewSelectedIndex(index: Int) {
        guard let model = modelArray?[index] else {return}
        guard let link = model.link else {return}
        YSNotificationHelper.bangumicarouselClickNotification(link: link)
    }
}
