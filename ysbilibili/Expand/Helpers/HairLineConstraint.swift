//
//  HairLineConstraint.swift
//
//  Created by YangShen on 2017/7/19.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class HairLineConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.constant == 1 {
            self.constant = 1 / UIScreen.main.scale
        }
    }
}
