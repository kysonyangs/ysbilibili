//
//  YSHairLineConstraint.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSHairLineConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.constant == 1 {
            self.constant = 1 / UIScreen.main.scale
        }
    }
}
