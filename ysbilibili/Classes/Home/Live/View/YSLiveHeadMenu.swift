//
//  HomeLiveHeadMenu.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

class YSLiveHeadMenu: UIView {

    class func instanceView() -> YSLiveHeadMenu {
        return Bundle.main.loadNibNamed("YSLiveHeadMenu", owner: self, options: nil)?.last as! YSLiveHeadMenu
    }

    @IBAction func menuChoseAction(_ sender: AnyObject) {
        print(sender.tag)
    }
}
