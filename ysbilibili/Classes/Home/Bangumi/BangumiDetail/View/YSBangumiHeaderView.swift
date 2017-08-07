//
//  YSBangumiHeaderView.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

enum BangumiheadSectionType: Float {
    case detail = 240
    case season = 70
    case list = 160
    case intro = 0
    case recommendHead = 60
}

class YSBangumiHeaderView: UIView {
    var introHight: CGFloat = 0
    
    // MARK - 属性
    var headModel: YSBangumiDetailModel? {
        didSet {
            // 1. 计算排列
            typeArray.append(.detail)
            if let seasonCount = headModel?.seasons?.count {
                if seasonCount > 1 {
                    typeArray.append(.season)
                }
            }
            if let itemCount = headModel?.episodes?.count {
                if itemCount > 1 {
                    typeArray.append(.list)
                }
            }
            typeArray.append(.intro)
            typeArray.append(.recommendHead)
            
            // 2. 初始化ui
            setupUI()
        }
    }
    ///
    var typeArray = [BangumiheadSectionType]()
}

extension YSBangumiHeaderView {
    func viewHeight() -> CGFloat {
        var height: CGFloat = 0
        for type in typeArray {
            let currentHeight = CGFloat(type.rawValue)
            height += currentHeight
        }
        height += introHight
        return height
    }
    
    fileprivate func setupUI() {
        var currentMaxHeight: Float = 0
        for type in typeArray {
            switch type {
            case .detail:
                let detailHeadView = YSBangumiDetailHeaderView()
                detailHeadView.headDetailModel = headModel
                self.addSubview(detailHeadView)
                let currentHeight = BangumiheadSectionType.detail.rawValue
                detailHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kScreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .season:
                let seasonHeadView = YSBangumiHeaderSeasonView()
                seasonHeadView.seasonArray = headModel?.seasons
                self.addSubview(seasonHeadView)
                let currentHeight = BangumiheadSectionType.season.rawValue
                seasonHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kScreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .list:
                let listItemView = YSBangumiHeaderItemView()
                listItemView.listArray = headModel?.episodes
                self.addSubview(listItemView)
                let currentHeight = BangumiheadSectionType.list.rawValue
                listItemView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kScreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            case .intro:
                let introView = YSBangumiHeaderTagView()
                introView.detailModel = headModel
                self.addSubview(introView)
                let currentHeight = introView.caculateContentHeight()
                introHight = currentHeight
                introView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kScreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += Float(currentHeight)
            case .recommendHead:
                let recommendHeadView = YSBangumiCommendHeaderView()
                self.addSubview(recommendHeadView)
                let currentHeight = BangumiheadSectionType.recommendHead.rawValue
                recommendHeadView.frame = CGRect(x: 0, y:CGFloat(currentMaxHeight), width: kScreenWidth, height: CGFloat(currentHeight))
                currentMaxHeight += currentHeight
            }
        }
    }
}

