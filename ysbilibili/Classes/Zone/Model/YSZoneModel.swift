
//
//  YSZoneModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

class YSZoneModel: HandyJSON {
    //    "tid": 13,
    //    "reid": 0,
    //    "name": "番剧",
    //    "logo": "",
    //    "goto": "",
    //    "param": "",
    //    "children"
    
    var tid: Int = 0
    var name: String = ""
    var logo: String = ""
    var children: [YSZoneModel]?
    
    required init(){}
}

extension YSZoneModel {
    func titleArray() -> [String] {
        var titleArray = [String]()
        if let childrens = children {
            for zoneModel in childrens {
                titleArray.append(zoneModel.name)
            }
        }
        return titleArray
    }
}
