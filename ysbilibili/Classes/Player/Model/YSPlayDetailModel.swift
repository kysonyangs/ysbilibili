//
//  YSPlayDetailModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSPlayDetailModel: HandyJSON {
    /// 相关数据
    var relates: [YSRelatesModel]?
    /// 播放数据
    var stat: YSRelatesStatModel?
    /// 描述
    var desc: String = ""
    /// 标题
    var title: String = ""
    /// 上传的时间戳
    var ctime: Double = 0
    /// 用户
    var owner: YSRelatesOwnerModel?
    /// 标签
    var tag: [YSTagModel]?
    /// 充能
    var elec: YSElecModel?
    /// 分级的列表
    var pages: [YSPageDetailModel]?
    /// 图片
    var pic: String = ""
    /// aid
    var aid: Int = 0
    
    required init() {}
}

// MARK - 关联数据
class YSRelatesModel: HandyJSON {
    
    /// 用户数据
    var owner: YSRelatesOwnerModel?
    /// 播放内容的数据
    var stat: YSRelatesStatModel?
    /// 视频id
    var aid: Int = 0
    /// 图片
    var pic: String = ""
    /// 标题
    var title: String = ""
    
    required init() {}
}

class YSRelatesOwnerModel: HandyJSON {
    /// 头像
    var face: String = ""
    /// 名字
    var name: String = ""
    ///
    var mid: Int = 0
    
    required init() {}
}

class YSRelatesStatModel: HandyJSON {
    
    //    "coin": 0,
    //    "danmaku": 11,
    //    "favorite": 52,
    //    "his_rank": 0,
    //    "now_rank": 0,
    //    "reply": 17,
    //    "share": 0,
    //    "view": 3608
    /// 收藏数量
    var favorite: Int = 0
    /// 分享的数量
    var share: Int = 0
    /// 硬币数量
    var coin: Int = 0
    /// 弹幕数量
    var danmaku: Int = 0
    /// 观看数量
    var view: Int = 0
    
    
    required init() {}
}

// MARK - 标签的model
class YSTagModel: HandyJSON {
    
    //    "cover": "",
    //    "hates": 0,
    //    "likes": 9,
    //    "tag_id": 2485355,
    //    "tag_name": "东方project"
    var tag_name: String = ""
    
    required init() {}
}

// MARK - 充能
class YSElecModel: HandyJSON {
    /// 本月充能的人数
    var count: Int = 0
    /// 充能总数
    var total: Int = 0
    /// 充能的人的具体数据
    var list: [YSElecListetailModel]?
    
    required init() {}
}

class YSElecListetailModel: HandyJSON {
    
    //    "avatar": "http://static.hdslb.com/images/member/noface.gif",
    //    "pay_mid": 12046616,
    //    "rank": 1,
    //    "uname": "zhengyanqing"
    // 头像
    var avatar: String = ""
    
    required init() {}
}

// MARK - 分级
class YSPageDetailModel: HandyJSON {
    
    //    "cid": 10989703,
    //    "from": "vupload",
    //    "has_alias": 0,
    //    "link": "",
    //    "page": 1,
    //    "part": "动图版",
    //    "rich_vid": "",
    //    "vid": "vupload_10989703",
    //    "weblink": ""
    /// cid
    var cid: Int = 0
    /// 名字
    var part: String = ""
    
    required init() {}
}
