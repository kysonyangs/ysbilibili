//
//  YSPlayCommendModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSPlayCommendModel: HandyJSON {
    // 回复的数量
    var count: Int = 0
    // 点赞的数量
    var like: Int = 0
    // 回复的时间
    var ctime: Double = 0
    // 用户的数据
    var member: YSPlayCommendMember?
    // 回复这条消息的回复
    var replies: [YSPlayCommendModel]?
    // 回复的内容
    var content: YSPlayCommendContetModel?
    // 楼层
    var floor: Int = 0
    
    required init() {}
}

// MARK - 评论的用户的数据
class YSPlayCommendMember: HandyJSON {
    var mid: Int = 0
    // 名字
    var uname: String = ""
    // 头像
    var avatar: String = ""
    // 等级
    var level_info: YSPlayCommendMemberLevel?
    
    required init() {}
}

// 用户等级
class YSPlayCommendMemberLevel: HandyJSON {
    // 用户等级
    var current_level: Int = 0
    required init() {}
}

class YSPlayCommendContetModel: HandyJSON {
    // 回复的消息内容
    var message: String = ""
    required init() {}
}
