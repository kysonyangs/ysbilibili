//
//  YSJsonHelper.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSJsonHelper {
    
    // 获取json array 的字符串（字典转模型需要的）
    class func getjsonArrayString(key:String,json:Any) -> String? {
        
        // 1.any -> dict
        guard let jsonDict = json as? [String:Any] else {return nil}
        
        // 2.dict -> array
        guard let jsonArray = jsonDict[key] as? NSArray else {return nil}
        
        // 3.array -> string
        guard let jsonString = jsonArray.arrayToString() else {return nil}
        
        // 4.返回 string
        return jsonString
    }
    
}

extension NSArray {
    // array 转字符串
    func arrayToString() -> String? {
        let data = try?JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        var dictStr:String? = nil
        if data != nil {
            dictStr = String(data: (data)!, encoding: String.Encoding.utf8)
        }
        return dictStr
    }
}
