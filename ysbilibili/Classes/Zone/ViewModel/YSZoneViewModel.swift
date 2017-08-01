//
//  YSZoneViewModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON

let kZoneURL = "http://app.bilibili.com/x/v2/region?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&sign=f4aa89fae4cb28e040b27febfb29f75e&ts=1483685717"

class YSZoneViewModel: NSObject {
    var zoneModelArray = [YSZoneModel]()
}

extension YSZoneViewModel {
    func requestData(finishAction: @escaping (() -> Void)) {
        YSNetworkTool.requestData(.get, URLString: kZoneURL, finished: { (result) in
            let jsonArryStr = YSJsonHelper.getjsonArrayString(key: "data", json: result)
            if let zoneArray = JSONDeserializer<YSZoneModel>.deserializeModelArrayFrom(json: jsonArryStr) as? [YSZoneModel] {
                self.zoneModelArray = zoneArray
            }
            finishAction()
        }) { (error) in
            
        }
    }
}
