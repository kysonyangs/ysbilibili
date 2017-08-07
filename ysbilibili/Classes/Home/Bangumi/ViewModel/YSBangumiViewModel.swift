//
//  YSBangumiViewModel.swift
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class YSBangumiViewModel {
    
// MARK: - 私有属性
    // 新番
    fileprivate var previousModelArray = [YSHomeBangumiDetailModel]()
    // 连载
    fileprivate var serializingModelArray = [YSHomeBangumiDetailModel]()
    // 推荐连载
    fileprivate var bangumiRecommendArray = [YSHomeBangumiRecommendModel]()
// MARK: - 外部属性
    // banner的数组array
    var headBannerModelArray = [YSHomeBangumiADdetailModel]()
    // 第一个section底部的banner数组
    var bodyBannerModelArray = [YSHomeBangumiADdetailModel]()
    
    // 图片string的数组
    var headImageStringArray = [String]()
    var bodyImageStringArray = [String]()
    
    // 数据的数组
    var statusArray = [Any]()
    
    // 判断新番的月份
    var season: Int = 0
    
}

//======================================================================
// MARK:-  请求数据
//======================================================================
extension YSBangumiViewModel {
    
    func requestDatas(finishCallBack:@escaping ()->(),failueCallBack:@escaping ()->()) {
        
        let netGroup = DispatchGroup()
        
        // 2. 获取新番和连载番剧的数据
        netGroup.enter()
        
        YSNetworkTool.shared.requestData(.get, URLString: "http://bangumi.bilibili.com/api/app_index_page_v4?build=3970&device=phone&mobi_app=iphone&platform=ios", finished: { (result) in
            // 1. 转成json
            let resultJson = JSON(result)
            // 2. 转成模型
            // <1. 头部的banner
            let headArrayString = YSJsonHelper.getjsonArrayString(key: "head", json: resultJson["result"]["ad"].dictionaryObject ?? "")
            if let bannerHeadArray = JSONDeserializer<YSHomeBangumiADdetailModel>.deserializeModelArrayFrom(json: headArrayString){
                guard let bannerHeadArray = bannerHeadArray as? [YSHomeBangumiADdetailModel] else {return}
                self.headBannerModelArray = bannerHeadArray
            }
            // 2. top model array  -> string array
            self.headImageStringArray.removeAll()
            for head in  self.headBannerModelArray {
                guard let img = head.img else {return}
                self.headImageStringArray.append(img)
            }
            
            // <3. 第一组的底部的banner
            let bodyArrayString = YSJsonHelper.getjsonArrayString(key: "body", json: resultJson["result"]["ad"].dictionaryObject ?? "")
            if let bodyBannerArray = JSONDeserializer<YSHomeBangumiADdetailModel>.deserializeModelArrayFrom(json: bodyArrayString){
                guard let bodyBannerArray = bodyBannerArray as? [YSHomeBangumiADdetailModel] else {return}
                self.bodyBannerModelArray = bodyBannerArray
            }
            // <4. bottom model array -> string array
            self.bodyImageStringArray.removeAll()
            for body in  self.bodyBannerModelArray {
                guard let img = body.img else {return}
                self.bodyImageStringArray.append(img)
            }
            
            // <3. 新番
            let previousArrayString = YSJsonHelper.getjsonArrayString(key: "list", json: resultJson["result"]["previous"].dictionaryObject ?? "")
            if let previousModelArray = JSONDeserializer<YSHomeBangumiDetailModel>.deserializeModelArrayFrom(json: previousArrayString ){
                guard let previousModelArray = previousModelArray as? [YSHomeBangumiDetailModel] else {return}
                self.previousModelArray = previousModelArray
            }
            
            // <4. 连载番剧
            let serializingArrayString = YSJsonHelper.getjsonArrayString(key: "serializing", json: resultJson["result"].dictionaryObject ?? "")
            if let serializingModelArray = JSONDeserializer<YSHomeBangumiDetailModel>.deserializeModelArrayFrom(json: serializingArrayString){
                guard let serializingModelArray = serializingModelArray as? [YSHomeBangumiDetailModel] else {return}
                self.serializingModelArray = serializingModelArray
            }
            
            // <5. 拿到连载的新番的月份
            self.season = resultJson["result"]["previous"]["season"].int!
            
            netGroup.leave()
        }) { (error) in
            // 错误的处理
            netGroup.leave()
        }
        
        // 3. 获取番剧推荐的数据
        netGroup.enter()
        
        YSNetworkTool.shared.requestData(.get, URLString: "http://bangumi.bilibili.com/api/bangumi_recommend?actionKey=appkey&appkey=27eb53fc9058f8c3&build=3970&cursor=0&device=phone&mobi_app=iphone&pagesize=10&platform=ios&sign=a47247d303f51e1328a43c2d49c69051&ts=1479350934", finished: { (result) in
            // <1. 转成json
            let resultJson = JSON(result)
            // <2. 转modelarray
            let recommendArrayString = YSJsonHelper.getjsonArrayString(key: "result", json: resultJson.dictionaryObject ?? "")
            if let recommendArray = JSONDeserializer<YSHomeBangumiRecommendModel>.deserializeModelArrayFrom(json: recommendArrayString) {
                // <<1. 赋值
                guard let recommendArray = recommendArray as? [YSHomeBangumiRecommendModel] else {return}
                self.bangumiRecommendArray = recommendArray
                // <<2. 计算行高
                for model in recommendArray {
                    model.caluateRowHeight()
                }
            }
            
            netGroup.leave()
        }) { (error) in
            failueCallBack()
            // 错误的处理
            netGroup.leave()
        }
        
        // 3. 合并数据
        netGroup.notify(queue: DispatchQueue.main) {
            // <1. 清空数据
            if self.serializingModelArray.count > 0 && self.previousModelArray.count > 0 && self.bangumiRecommendArray.count > 0 {
                self.statusArray.removeAll()
            }
            // <2. 添加数据
            self.statusArray.append(self.serializingModelArray)
            self.statusArray.append(self.previousModelArray)
            self.statusArray.append(self.bangumiRecommendArray)
          
            finishCallBack()
        }
    }
    
}

//======================================================================
// MARK:- datesource 方法
//======================================================================
extension YSBangumiViewModel {
    // 组
    func sectionCount() -> Int {
        return statusArray.count
    }
    // 行
    func rowCount(section: Int) -> Int {
        guard let array:[Any] = statusArray[section] as? Array else {return 0}
        return array.count
    }
    // cell
    func createCell(collectionView: UICollectionView , indexPath: IndexPath) -> UICollectionViewCell {
        if  indexPath.section == 0 || indexPath.section == 1 {
            // 1. 拿到cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBangumiALLCellReuseKey, for: indexPath) as! YSBangumiNormalCell
            // 2. 赋值数据
            if let sectionModelArray = statusArray[indexPath.section] as? [YSHomeBangumiDetailModel] {
                let rowModel = sectionModelArray[indexPath.row]
                cell.bangumiDetailModel = rowModel
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBangumiRecommendReusekey, for: indexPath) as! YSBangumiRecommendCell
            cell.recommendModel = bangumiRecommendArray[indexPath.row]
            return cell
        }
    }
    
    // head foot
    func createFootHeadView(kind:String,collectionView:UICollectionView,indexPath:IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader { // head
            
            if indexPath.section == 0 {
                let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kBangumiBannerMenuReuseKey, for: indexPath) as! YSBangumiTopView
                // banner的数据可能不存在
                if headImageStringArray.count > 0 {
                    head.isNoBanner = false
                    head.imgStringArray = headImageStringArray
                    head.bannerModelArray = headBannerModelArray
                }else{
                    head.isNoBanner = true
                }
                return head
            }else {
                let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kBangumiNormalHeadReuseKey, for: indexPath) as! YSBangumiNormalHeaderView
                head.section = indexPath.section
                if indexPath.section == 1 {
                    head.season = season
                }
                return head
            }

        }else{ // foot
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kBangumiBannerFootReuseKey, for: indexPath) as! YSBangumiTopFooterView
            footer.carouselView.intnetImageArray = bodyImageStringArray
            footer.modelArray = bodyBannerModelArray
            return footer
        }
    }
}

//======================================================================
// MARK:- layout delegate 方法
//======================================================================
extension YSBangumiViewModel {

    func caluateItemSize(indexPath:IndexPath) -> CGSize {
        if indexPath.section == 2 {// 1. 推荐番剧
            let model = bangumiRecommendArray[indexPath.row]
            return CGSize(width: kScreenWidth - 2 * kPadding, height: CGFloat(model.rowHight))
        }else {// 2. 普通
             return CGSize(width: (kScreenWidth - 4 * kPadding)/3, height: 200)
        }
    }
    
    func caluateHeadSize(section:Int) -> CGSize {
        if  section == 0 {
            if headImageStringArray.count > 0 {
                return CGSize(width: kScreenWidth, height: 275)
            }else {
                return CGSize(width: kScreenWidth, height: 275 - kCarouseHeight)
            }
        }else {
            return CGSize(width: kScreenWidth, height: 40)
        }
    }
    
    func caluateFootSize(section:Int) -> CGSize {
        if section == 0 {
            if bodyImageStringArray.count > 0 {
                return CGSize(width: kScreenWidth, height: 90)
            }
            return CGSize(width: 0, height: 0)
        }else {
            return CGSize(width: 0, height: 0)
        }
    }
}



