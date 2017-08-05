//
//  String+ysAdd.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/1.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension String {
    
    // 获取字符串的高度
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    // 获取字符串的宽度
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
    
    // 直播的人数处理
    static func creatCountString(count:Int) -> String {
        if count < 10000 {
            return "\(count)"
        }else{
            return "\(count/1000)万"
        }
    }
    
    // 直播头部的富文本处理
    static func creatAttributesText(countString:String,beginStr:String,endStr:String) -> NSMutableAttributedString {
        
        // 1. 生成NSMutableAttributedString
        let titile = "\(beginStr)\(countString)\(endStr)"
        let str = NSMutableAttributedString(string: titile)
        
        // 2. 拿到主要的位置
        let beginlength = beginStr.characters.count
        let coutStringLength = countString.characters.count
        let titleLength = titile.characters.count
        
        // 3. 赋值主要的位置
        str.addAttributes([NSForegroundColorAttributeName:kHomeHeadRightTextColor], range: NSRange(location: 0,length: beginlength))
        str.addAttributes([NSForegroundColorAttributeName:kMainColor], range: NSRange(location: beginlength,length: coutStringLength))
        str.addAttributes([NSForegroundColorAttributeName:kHomeHeadRightTextColor], range: NSRange(location: coutStringLength+beginlength,length: titleLength - coutStringLength - beginlength))
        
        // 4. 返回str
        return str
    }
    
    
}
