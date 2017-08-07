//
//  YSRecommendModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/4.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

enum HomeStatustype {
    /// 1.热门推荐
    case recommend
    /// 2.推荐直播
    case live
    /// 3.番剧推荐
    case bangumi
    /// 4.动画区
    case donghua
    /// 5.音乐
    case music
    /// 6.舞蹈区
    case dance
    /// 7.游戏
    case game
    /// 8.鬼畜
    case guichu
    /// 9.科技
    case tecnolegy
    /// 10.活动中心
    case activity
    /// 11.生活区
    case life
    /// 12.时尚
    case morden
    /// 13.广告
    case advetise
    /// 14.娱乐
    case entertainment
    /// 15.电视剧
    case TVshow
    /// 16.电影
    case film
}

class YSRecommendModel: HandyJSON {
    // 判断是什么区的数据
    var sectionType: HomeStatustype?
    
    var param: Int = 0
    var type: String?
    var style: String?
    var title: String?
    var banner: YSBanner?
    var ext: YSRecommendLiveDetailModel?
    var body: [YSItemDetailModel] = [YSItemDetailModel]()
    
    required init(){}
}

// MARK: - ecommendModel的一些公开方法
extension YSRecommendModel {
    func setHomeStatusType() {
        if type == "recommend" {
            sectionType = .recommend
        }
        if type == "live" {
            sectionType = .live
        }
        if type == "bangumi" {
            sectionType = HomeStatustype.bangumi
        }
        if type == "activity" {
            sectionType = HomeStatustype.activity
        }
        // 动画
        if param == 1 {
            sectionType = HomeStatustype.donghua
        }
        // 音乐
        if param == 3 {
            sectionType = HomeStatustype.music
        }
        // 舞蹈区
        if param == 129 {
            sectionType = HomeStatustype.dance
        }
        // 游戏区
        if param == 4 {
            sectionType = HomeStatustype.game
        }
        // 鬼畜区
        if param == 119 {
            sectionType = HomeStatustype.guichu
        }
        // 科技区
        if param == 36 {
            sectionType = HomeStatustype.tecnolegy
        }
        // 舞蹈区
        if param == 160 {
            sectionType = HomeStatustype.life
        }
        // 时尚区
        if param == 155 {
            sectionType = HomeStatustype.morden
        }
        // 广告区
        if param == 165 {
            sectionType = HomeStatustype.advetise
        }
        // 娱乐区
        if param == 5 {
            sectionType = HomeStatustype.entertainment
        }
        // 电视剧区
        if param == 11 {
            sectionType = HomeStatustype.TVshow
        }
        // 电影区
        if param == 23 {
            sectionType = HomeStatustype.film
        }
    }
}

// MARK: - 普通显示的model
class YSItemDetailModel: HandyJSON {
    // 标题
    var title: String?
    // 显示的图片
    var cover: String?
    // 播放的url
    var uri: String?
    //
    var param: Int = 0
    // 直播的状态
    var goto: String?
    // 类型
    var area: String?
    // 类型的id
    var area_id: String?
    // 用户的名字
    var name: String?
    // 用户的头像
    var face: String?
    //
    var online: Int = 0
    // 播放数
    var play: Int = 0
    // 评论数
    var danmaku: Int = 0
    // 时间
    var mtime: String?
    // 连载剧集
    var index: Int?
    // 角上的图标
    var corner:String?
    
    required init(){}
}

// MARK: -
class YSBanner: HandyJSON {
    // 顶部的轮播
    var top: [YSBannerDetailModel]?
    // 底部的轮播
    var bottom: [YSBannerDetailModel]?
    
    required init(){}
}

// MARK: - 轮播的model
class YSBannerDetailModel: HandyJSON {
    
    var id: String?
    
    var title: String?
    
    var image: String?
    
    var hash: String?
    
    var uri: String?
    
    /// 是否是广告
    var is_ad: Bool?
    
    required init(){}
}

// MARK: - 直播的model
class YSRecommendLiveDetailModel: HandyJSON {
    var live_count: Int = 0
    
    required init(){}
}

