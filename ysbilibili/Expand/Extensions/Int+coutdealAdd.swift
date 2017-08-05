//
//  Int+coutdealAdd.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import Foundation

fileprivate let kShowingMaxCount: Int = 10000

extension Int {
    
    func returnShowString() -> String {
        
        if self > kShowingMaxCount{
            let newCount = Double(self) / Double(kShowingMaxCount)
            let formatter = String(format:"%.1f",newCount)
            let newStr = "\(formatter)万"
            return newStr
        }else{
            return "\(self)"
        }
    }
    
    func weekDay() -> String {
        if self == 1 {
            return "一"
        }
        if self == 2 {
            return "二"
        }
        if self == 3 {
            return "三"
        }
        if self == 4 {
            return "四"
        }
        if self == 5 {
            return "五"
        }
        if self == 6 {
            return "六"
        }
        if self == 7 {
            return "日"
        }
        return ""
    }
}
