//
//  YSPlayerRelatesCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/5.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSPlayerRelatesCell: YSBaseLineCell {
    
    // 点击的响应
    var tapAction: ((_ model: YSRelatesModel)->Void)?
    
    // 数据
    var detailModel: YSRelatesModel? {
        didSet{
            if let pic = detailModel?.pic {
                let url = URL(string: pic)
//                showImageView.kf.setImage(with: url)
                showImageView.sd_setImage(with: url)
            }
            if let title = detailModel?.title {
                titleLabel.text = title
            }
            if let name = detailModel?.owner?.name {
                upNameLabel.text = name
            }
            if let danmu = detailModel?.stat?.danmaku {
                danmuNumberLabel.text = "\(danmu.returnShowString())"
            }
            if let playNumber = detailModel?.stat?.view {
                playNumberLabel.text = "\(playNumber.returnShowString())"
            }
        }
    }
    
    var playItemModel: YSItemDetailModel? {
        didSet{
            if let pic = playItemModel?.cover {
                let url = URL(string: pic)
//                showImageView.kf.setImage(with: url)
                showImageView.sd_setImage(with: url)
            }
            if let title = playItemModel?.title {
                titleLabel.text = title
            }
            if let name = playItemModel?.name {
                upNameLabel.text = name
            }
            if let danmu = playItemModel?.danmaku {
                danmuNumberLabel.text = "\(danmu.returnShowString())"
            }
            if let playNumber = playItemModel?.play {
                playNumberLabel.text = "\(playNumber.returnShowString())"
            }
        }
    }
    
    // MARK - 控件
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var danmuNumberLabel: UILabel!
    @IBOutlet weak var playNumberLabel: UILabel!
    @IBOutlet weak var upNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        if detailModel != nil {
            let tapGes = UITapGestureRecognizer {[weak self] in
                print("tag self")
                self?.tapAction!((self?.detailModel)!)
            }
            self.addGestureRecognizer(tapGes)
        }
    }

    class func relatesCellWithTableView(tableView: UITableView) -> YSPlayerRelatesCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ZHNplayerRelatesTableViewCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("YSPlayerRelatesCell", owner: nil, options: nil)?.last as! YSPlayerRelatesCell
        }
        cell?.backgroundColor = kHomeBackColor
        return cell as! YSPlayerRelatesCell
    }

}
