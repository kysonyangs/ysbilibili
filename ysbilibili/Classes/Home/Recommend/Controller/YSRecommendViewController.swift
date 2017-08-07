//
//  YSHomeRecommendViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

let kCellReuseKey = "kCellReuseKey"
let kCommenAreaCell = "kCommenAreaCell"
let kLiveCellReuseKey = "kLiveCellReuseKey"
let kBanmikuCellReuseKey = "kBanmikuCellReuseKey"
let kActivityCellReuseKey = "kActivityCellReuseKey"
let kHeaderReuseKey = "kHeaderReuseKey"
let kFooterReuseKey = "kFooterReuseKey"

class YSRecommendViewController: YSRabbitFreshBaseViewController {

    // MARK: - 私有属性
    fileprivate lazy var recommendVM: YSRecommendViewModel = YSRecommendViewModel()
    
    // MARK: - 懒加载控件
    fileprivate lazy var maincollectionView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = kPadding
        let mainCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.showsVerticalScrollIndicator = false
        
        // 注册cell foot head
        mainCollectionView.register(YSNormalBaseCell.self, forCellWithReuseIdentifier: kCellReuseKey)
        mainCollectionView.register(YSRecommendActivityCell.self, forCellWithReuseIdentifier: kActivityCellReuseKey)
        mainCollectionView.register(YSCommenAreaCell.self, forCellWithReuseIdentifier: kCommenAreaCell)
        mainCollectionView.register(YSLiveShowCell.self, forCellWithReuseIdentifier: kLiveCellReuseKey)
        mainCollectionView.register(YSBanmikuShowCell.self, forCellWithReuseIdentifier: kBanmikuCellReuseKey)
        mainCollectionView.register(YSRecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderReuseKey)
        mainCollectionView.register(YSRecommendFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kFooterReuseKey)
        
        return mainCollectionView
        }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载数据
        loadData()
        
        // 设置代理
        recommendVM.delegate = self
        
        // 监听
        NotificationCenter.default.addObserver(self, selector: #selector(clickCarousel(notification:)), name: kCarouselViewSelectedRecommendNotification, object: nil)
    }
    
    // MARK: - 重写父类的方法
    // 1. 初始化滑动view
    override func setUpScrollView() -> UIScrollView {
        return maincollectionView
    }
    
    // 2. 刷新状态调用的方法
    override func startRefresh() {
        loadData()
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSRecommendViewController {
    
    fileprivate func loadData() {
        
        recommendVM.requestDatas(finishCallBack: { [weak self] in
            guard (self?.recommendVM.statusArray) != nil else {
                // 没数据的情况
                self?.endRefresh(loadSuccess: false)
                return
            }
            
            // 有数据的情况
            DispatchQueue.main.async {
                self?.maincollectionView.reloadData()
                self?.endRefresh(loadSuccess: true)
            }
            
            // 失败的情况
            }, failueCallBack: { [weak self] in
                self?.endRefresh(loadSuccess: false)
        })
    }
    
}

//======================================================================
// MARK:- collectionView 的数据源
//======================================================================
extension YSRecommendViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.statusArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendVM.calculateRowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return recommendVM.creatCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return recommendVM.createFootOrHead(kind: kind, collectionView: collectionView, indexPath: indexPath)
    }
    
}

//======================================================================
// MARK:- collectionView 的代理方法
//======================================================================
extension YSRecommendViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // banner 跳转的时候需要考虑可能是直播 bilibili://live/11
        let sectionModel = recommendVM.statusArray[indexPath.section]
        if sectionModel.sectionType == HomeStatustype.live {
            /// 实在拿不到播放的url
            //            let liveVC = ZHNbilibiliLivePlayerViewController()
        }else if sectionModel.sectionType == HomeStatustype.bangumi {
//            let bangumiVC = ZHNbangumiDetailViewController()
//            let rowModel = sectionModel.body[indexPath.row]
//            let detaimModel = YSHomeBangumiDetailModel()
//            detaimModel.season_id = rowModel.param
//            bangumiVC.bangumiDetailModel = detaimModel
//            _ = navigationController?.pushViewController(bangumiVC, animated: true)
        }else {
//            let rowModel = sectionModel.body[indexPath.row]
//            let playerVC = ZHNnormalPlayerViewController()
//            playerVC.itemModel = rowModel
//            self.navigationController?.pushViewController(playerVC, animated: true)
        }
    }
}

//======================================================================
// MARK:- collectionView layout 的代理方法
//======================================================================
extension YSRecommendViewController: UICollectionViewDelegateFlowLayout {
    
    // 1. 每个section的inset (item.size.with < collectionview.frame.size.width - (2 * padding) 如果items的width不满足上面这个的话会报警告)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return recommendVM.calculateSectionInset(section: section)
    }
    
    // 2.每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return recommendVM.calculateItemSize(section: indexPath.section)
    }
    
    
    // 2.header的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return recommendVM.calulateSectionHeadSize(section: section)
    }
    
    // 3.footer的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return recommendVM.calulateSectionfootSize(section: section)
    }
}

//======================================================================
// MARK:- recommendViewModel 的代理方法
//======================================================================
extension YSRecommendViewController: YSRecommendViewModelDelegate {
    func recommendViewModelReloadSetion(section: Int) {
        DispatchQueue.main.async {
            self.maincollectionView.reloadSections(IndexSet(integer: section))
        }
    }
}

//======================================================================
// MARK:- 轮播的点击
//======================================================================
extension YSRecommendViewController {
    @objc func clickCarousel(notification: Notification) {
        let url = notification.userInfo?[kCarouselSelectedUrlKey] as! String
        let webVC = YSBilibiliWebViewController()
        webVC.urlString = url
        _ = navigationController?.pushViewController(webVC, animated: true)
    }
}
