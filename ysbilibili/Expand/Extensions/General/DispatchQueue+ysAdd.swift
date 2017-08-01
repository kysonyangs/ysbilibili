//
//  DisPatchQueue+ysAdd.swift
//
//  Created by YangShen on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import Foundation

extension DispatchQueue {
    class func afer(time: Double, action: @escaping ()->()){
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            action()
        })
    }
}
