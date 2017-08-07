//
//  YSRecommendSectionModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSRecommendSectionModel: HandyJSON {
    var aid: String?
    var typeid: Int = 0
    var subtitle: String?
    var review: Int = 0
    
    /// 播放的数量
    var play: Int = 0
    /// 评论的数量
    var video_review: Int = 0
    /// 标题
    var title: String?
    /// 图片
    var pic: String?
    
    required init() {}
}
