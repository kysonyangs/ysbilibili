//
//  Double+dateAdd.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension Double {
    
    func showTime() -> String {
        let currentTimeInterval = TimeInterval(self)
        let selfDate = Date(timeIntervalSince1970: currentTimeInterval)
        let dateComponent = Calendar.current.dateComponents([.day], from: selfDate, to: Date())
        guard let day = dateComponent.day else {return ""}
        if day == 0 {
            return "今天投递"
        }else {
            return "\(day)天前投递"
        }
    }
    
    func commendTime() -> String {
        let currentTimeInterval = TimeInterval(self)
        let selfDate = Date(timeIntervalSince1970: currentTimeInterval)
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        guard let minute = dateComponent.minute else {return ""}
        let hour = minute / 60
        if hour == 0 {
            return "\(minute)分钟前"
        }else {
            if hour < 24 {
                return "\(hour)小时前"
            }else {
                let day = hour / 24
                if day > 0 {
                    return "\(day)天前"
                }else {
                    return ""
                }
            }
        }
        
    }
}

extension TimeInterval {
    func timeString() -> String {
        let minute = Int(self / 60)
        let second = Int(self) % 60
        var minuteString = ""
        var secondString = ""
        // 分钟
        if minute < 10 {
            minuteString = "0\(minute)"
        }else {
            minuteString = "\(minute)"
        }
        // 秒
        if second < 10 {
            secondString = "0\(second)"
        }else {
            secondString = "\(second)"
        }
        
        return"\(minuteString):\(secondString)"
    }
    
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
