//
//  YSBanmikuShowCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSBanmikuShowCell: YSNormalBaseCell {
    var sonStatusModel: YSItemDetailModel? {
        didSet{
            detailLabel.text = createDetailString()
        }
    }
    
    
    // MARK: - 懒加载控件
    lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = UIColor.white
        detailLabel.font = kCellDetailFont
        return detailLabel
    }()
    
    // MARK: - 添加控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(detailLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(maskImageView.snp.left).offset(5)
            make.bottom.equalTo(maskImageView.snp.bottom).offset(-5)
        }
    }
    
}

extension YSBanmikuShowCell {
    
    fileprivate func createDetailString() -> String {
        
        // 1.创建一个formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss.s"
        
        // 2.判断数据存不存在
        guard let timeString = sonStatusModel?.mtime else {return ""}
        guard let index = sonStatusModel?.index else {return ""}
        
        // 3. 返回需要展示的数据格式
        let currentDate = dateFormatter.date(from: timeString)
        if let time = currentDate?.getCustomDateString(){
            return "\(time)  •  第\(index)话"
        }else{
            return ""
        }
    }
    
}
