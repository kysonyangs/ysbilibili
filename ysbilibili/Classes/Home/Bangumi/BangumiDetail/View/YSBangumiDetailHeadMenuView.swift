//
//  ZHNbangumiDetailHeadMenuView.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class YSBangumiDetailHeadMenuView: UIView {
    
    @IBOutlet weak var shareIconImageView: UIImageView!
    @IBOutlet weak var faverateIconImageView: UIImageView!
    @IBOutlet weak var cacheIocnImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shareIconImageView.image = UIImage(named: "iphonevideoinfo_share")?.ysTintColor(kShareColor)
        faverateIconImageView.image = UIImage(named: "bangumi_like")
        cacheIocnImageView.image = UIImage(named: "iphonevideoinfo_dl")?.ysTintColor(kDownloadColor)
    }
    
    class func instanceView() -> YSBangumiDetailHeadMenuView {
        let bundName = String(describing: self)
        return Bundle.main.loadNibNamed(bundName, owner: nil, options: nil)?.last as! YSBangumiDetailHeadMenuView
    }
}
