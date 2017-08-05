//
//  YSBaseLineCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSBaseLineCell: UITableViewCell {
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = UIColor.ysColor(red: 217, green: 217, blue: 217, alpha: 1)
        return lineView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(lineView)
        lineView.frame = CGRect(x: 10, y: frame.height - 1, width: frame.width-20, height: 1 / UIScreen.main.scale)
    }
}
