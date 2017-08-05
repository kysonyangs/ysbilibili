//
//  YSNotificationHelper.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import Foundation

/// 首页
/// 点击了各个轮播的通知
///1.直播
let kCarouselViewSelectedLiveNotification = NSNotification.Name(rawValue: "kCarouselViewSelectedLiveNotification")
///2.推荐
let kCarouselViewSelectedRecommendNotification = NSNotification.Name(rawValue: "kCarouselViewSelectedRecommendNotification")
///3.番剧
let kCarouselViewSelectedBangumiNotification = NSNotification.Name(rawValue: "kCarouselViewSelectedBangumiNotification")
/// userInfo key
let kCarouselSelectedUrlKey = "kCarouselSelectedUrlKey"

/// 主页
/// 点击了普通视跳转
let kHomePageNormalPlayerSelectedNotification = NSNotification.Name(rawValue: "kHomePageNormalPlayerSelectedNotification")
let kHomePageSelectedAidKey = "kHomePageSelectedAidKey"

/// 分区
let kHomeViewControllerShowLiveNotification = NSNotification.Name(rawValue:"kHomeViewControllerShowLiveNotification")

/// 评论
/// 点击头像的通知
let kRecommendControllerSelectedHomePageNotification = NSNotification.Name(rawValue: "kRecommendControllerSelectedHomePageNotification")
let kRecommendNotificationKey = "kRecommendNotificationKey"

/// 关闭播放器
/// 最多只能有一个播放器 当开始播放的时候需要关掉之前的播放器
let kPlayingPlayerNeedToShutDownNotification = Notification.Name("kPlayingPlayerNeedToShutDownNotification")

/// 番剧
let kBangumiSelectedNotification = Notification.Name("kBangumiSelectedNotification")
let kBangumiModelKey = "kBangumiModelKey"


class YSNotificationHelper {
    
    // MARK - 首页
    class func livecarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kCarouselViewSelectedLiveNotification, object: nil, userInfo: [kCarouselSelectedUrlKey: link])
    }
    
    class func recommedcarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kCarouselViewSelectedRecommendNotification, object: nil, userInfo: [kCarouselSelectedUrlKey: link])
    }
    
    class func bangumicarouselClickNotification(link: String) {
        NotificationCenter.default.post(name: kCarouselViewSelectedBangumiNotification, object: nil, userInfo: [kCarouselSelectedUrlKey: link])
    }
    
    // MARK - 分区
    class func zoneItemClickNotification() {
        NotificationCenter.default.post(name: kHomeViewControllerShowLiveNotification, object: nil, userInfo: nil)
    }
    
    
    // MARK - 主页
    class func homePageSelectedNormalNotification(item: YSItemDetailModel) {
        NotificationCenter.default.post(name: kHomePageNormalPlayerSelectedNotification, object: nil, userInfo: [kHomePageSelectedAidKey: item])
    }
    
    // MARK - 评论
    class func recommendSelectedHomePage(mid: Int) {
        NotificationCenter.default.post(name: kRecommendControllerSelectedHomePageNotification, object: nil, userInfo: [kRecommendNotificationKey: mid])
    }
    
    // MARK - 关闭播放器
    class func shutDownOldPlayer() {
        NotificationCenter.default.post(name: kPlayingPlayerNeedToShutDownNotification, object: nil, userInfo: nil)
    }
    
    // MARK - 番剧
    class func bangumiItemSelected(bangumiModel: YSHomeBangumiDetailModel) {
        NotificationCenter.default.post(name: kBangumiSelectedNotification, object: nil, userInfo: [kBangumiModelKey: bangumiModel])
    }
    
}
