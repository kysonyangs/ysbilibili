//
//  YSBilibiliMineViewModel.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSMineViewModel: NSObject {
    var itemNameArray = [
        [ "离线缓存","历史记录","我的收藏","我的关注","稍后再看","B币钱包","会员积分","游戏中心","主题选择","大会员","免流量服务","BML订单" ],
        [ "回复我的","@我","收到的赞","私信","系统通知","","","" ]
    ]
    
    var itemImageNameArray = [
        [ "mine_download","mine_history","mine_favourite","mine_follow","mine_watchLater","mine_pocketcenter","mine_intergal","mine_gamecenter","mine_theme","mine_vipmember","mine_freeCard","mine_bml_record" ],
            [ "mine_answerMessage","mine_shakeMe","mine_gotPrise","mine_privateMessage","mine_systemNotification","","","" ]
    ]
    
    func caluateSectionCount() -> Int {
        return 2
    }
    
    func caluateRowCount(section: Int) -> Int {
        return itemNameArray[section].count
    }
    
    func cell(collectionView: UICollectionView,indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMineCellReuseKey, for: indexPath) as! YSMineCollectionCell
        cell.title = itemNameArray[indexPath.section][indexPath.row]
        cell.iconName = itemImageNameArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func headOrFoot(collectionView: UICollectionView,kind: String,indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kMineHeaderViewReuseKey, for: indexPath) as! YSMineHeaderView
            
            if indexPath.section == 0 {
                headerView.isFirstHeader = true
                headerView.title = "个人中心"
            } else {
                headerView.isFirstHeader = false
                headerView.title = "我的消息"
            }
            return headerView
        }
        return UICollectionReusableView()
    }
}
