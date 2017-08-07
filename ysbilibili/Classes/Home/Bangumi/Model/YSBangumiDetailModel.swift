//
//  YSBangumiDetailModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSBangumiDetailModel: HandyJSON {
    /// 是否正在连载
    var is_finish: Int = 0
    /// 连载更新的日期
    var weekday: Int = 0
    /// 番剧的标题
    var bangumi_title: String = ""
    /// 番剧的介绍
    var brief: String = ""
    /// 海报的图片
    var cover: String = ""
    /// 标签
    var tags: [YSTagModel]?
    /// 订阅数
    var favorites: Int = 0
    /// 播放数
    var play_count: Int = 0
    /// 当前季的id
    var season_id: Int = 0
    /// 集数
    var episodes: [YSBangumiCollectModel]?
    /// 季数
    var seasons: [YSBangumiSeasonModel]?
    
    required init() {}
}

class YSBangumiCollectModel: HandyJSON {
    
    /// 标题
    var index_title: String = ""
    /// 数据的id
    var episode_id: Int = 0
    ///
    var av_id: Int = 0
    
    required init() {}
}

class YSBangumiSeasonModel: HandyJSON {
    
    /// 季的id
    var season_id: Int = 0
    /// 季的标题
    var title: String = ""
    
    required init() {}
}


