//
//  UIColor+ysAdd.swift
//
//  Created by YangShen on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

extension UIColor {
    class func ysColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    /** 16进制转UIColor */
    class func ysHexColor(hex: String) -> UIColor {
        return proceesHex(hex: hex, alpha: 1)
    }
    
    /** 16进制转UIColor */
    class func ysHexColorWithAlpha(hex: String, alpha: CGFloat) -> UIColor {
        return proceesHex(hex: hex, alpha: alpha)
    }
    
    /// 随机色
    class func ysRandomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return ysColor(red: r, green: g, blue: b, alpha: 1)
    }
}

// MARK: - 主要逻辑
fileprivate func proceesHex(hex: String, alpha: CGFloat) -> UIColor{
    /** 如果传入的字符串为空 */
    if hex.isEmpty {
        return UIColor.clear
    }
    
    /** 传进来的值。 去掉了可能包含的空格、特殊字符， 并且全部转换为大写 */
    let set = CharacterSet.whitespacesAndNewlines
    var hHex = hex.trimmingCharacters(in: set).uppercased()
    
    /** 如果处理过后的字符串少于6位 */
    if hHex.characters.count < 6 {
        return UIColor.clear
    }
    
    /** 开头是用0x开始的 */
    if hHex.hasPrefix("0X") {
        hHex = (hHex as NSString).substring(from: 2)
    }
    /** 开头是以＃开头的 */
    if hHex.hasPrefix("#") {
        hHex = (hHex as NSString).substring(from: 1)
    }
    /** 开头是以＃＃开始的 */
    if hHex.hasPrefix("##") {
        hHex = (hHex as NSString).substring(from: 2)
    }
    
    /** 截取出来的有效长度是6位， 所以不是6位的直接返回 */
    if hHex.characters.count != 6 {
        return UIColor.clear
    }
    
    /** R G B */
    var range = NSMakeRange(0, 2)
    
    /** R */
    let rHex = (hHex as NSString).substring(with: range)
    
    /** G */
    range.location = 2
    let gHex = (hHex as NSString).substring(with: range)
    
    /** B */
    range.location = 4
    let bHex = (hHex as NSString).substring(with: range)
    
    /** 类型转换 */
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    
    Scanner(string: rHex).scanHexInt32(&r)
    Scanner(string: gHex).scanHexInt32(&g)
    Scanner(string: bHex).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}
