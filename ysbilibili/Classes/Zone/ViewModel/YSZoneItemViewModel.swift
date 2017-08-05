//
//  YSZoneItemViewModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/4.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class YSZoneItemViewModel: UIView {
    
    // 热门推荐
    var recommendArray = [YSItemDetailModel]()
    // 最新数据
    var newestArray = [YSItemDetailModel]()
    // 数据
    var statusArray = [[YSItemDetailModel]]()
    
}

extension YSZoneItemViewModel {
    func requestData(rid: Int, finishAction: @escaping (() -> Void)) {
        YSNetworkTool.shared.requestData(.get, URLString: "http://app.bilibili.com/x/v2/region/show/child?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&device=phone&mobi_app=iphone&platform=ios&rid=\(rid)&sign=f2850f2934407d055f8b200d49a96a6f&ts=1483686014", finished: { (result) in
            // 字典转模型
            let resultJson = JSON(result)
            let recommendAryStr = YSJsonHelper.getjsonArrayString(key: "recommend", json: resultJson["data"].dictionaryObject)
            let newAryStr = YSJsonHelper.getjsonArrayString(key: "new", json: resultJson["data"].dictionaryObject)
            if let tempRecommedArray = JSONDeserializer<YSItemDetailModel>.deserializeModelArrayFrom(json: recommendAryStr) {
                self.recommendArray = tempRecommedArray as! [YSItemDetailModel]
            }
            if let rempNewArray = JSONDeserializer<YSItemDetailModel>.deserializeModelArrayFrom(json: newAryStr) {
                self.newestArray = rempNewArray as! [YSItemDetailModel]
            }
            self.statusArray.append(self.recommendArray)
            self.statusArray.append(self.newestArray)
            finishAction()
        }) { (error) in
            
        }
    }
}
