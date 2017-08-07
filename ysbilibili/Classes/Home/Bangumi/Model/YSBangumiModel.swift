//
//  YSBangumiModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSBangumiModel: HandyJSON {
    required init() {}
}

// 广告的model（其他页面叫banner）
class YSHomeBangumiADdetailModel: HandyJSON {
    
    var id: Int = 0
    var is_ad: Int = 0
    
    // 显示的图片
    var img: String?
    // 链接
    var link: String?
    // 创建的时间
    var pub_time: String?
    // 标题
    var title: String?
    
    required init() {}
}

class YSHomeBangumiDetailModel: HandyJSON {
    
    // 显示的图片
    var cover: String?
    // 追番的人数
    var favourites: Int = 0
    // 是否连载
    var is_finish: Int = 0
    // 连载的最新剧集
    var newest_ep_index: Int = 0
    // 正在观看的人数
    var watching_count: Int = 0
    // 标题
    var title: String?
    
    var is_started: Int = 0
    var season_id: Int = 0
    var season_status: Int = 0
    var last_time: String?
    var pub_time: String?
    
    required init() {}
}


class YSHomeBangumiRecommendModel: HandyJSON {
    
    // 展示的图片
    var cover: String?
    // 描述
    var desc: String?
    // 判断是不是new
    var is_new: Int = 0
    // 链接 （html结尾的是用webview打开）
    var link: String?
    // 标题
    var title: String?
    
    var onDt: String?
    var cursor: String?
    var id: Int = 0
    
    // 计算的行高
    var rowHight: Double = 0
    func caluateRowHeight() {
        guard let height = desc?.heightWithConstrainedWidth(width: kScreenWidth - 2 * kPadding, font: kHomeBangumiRecommendDesFont) else {return}
        rowHight = Double(height + kHomeBangumiRecommendCoverHeight + 60)
    }
    required init() {}
}
