//
//  HomebangumiViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit

let kBangumiALLCellReuseKey = "kBangumiALLCellReuseKey"
let kBangumiBannerMenuReuseKey = "kBangumiBannerMenuReuseKey"
let kBangumiNormalHeadReuseKey = "kBangumiNormalHeadReuseKey"
let kBangumiBannerFootReuseKey = "kBangumiBannerFootReuseKey"
let kBangumiRecommendReusekey = "kBangumiRecommendReusekey"

class YSBangumiViewController: YSRabbitFreshBaseViewController {

    var bangumiVM = YSBangumiViewModel()

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
        mainCollectionView.register(YSBangumiNormalCell.self, forCellWithReuseIdentifier: kBangumiALLCellReuseKey)
        mainCollectionView.register(YSBangumiRecommendCell.self, forCellWithReuseIdentifier: kBangumiRecommendReusekey)
        mainCollectionView.register(YSBangumiTopView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kBangumiBannerMenuReuseKey)
        mainCollectionView.register(YSBangumiNormalHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kBangumiNormalHeadReuseKey)
        mainCollectionView.register(YSBangumiTopFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kBangumiBannerFootReuseKey)
        return mainCollectionView
        }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 加载数据
        loadDatas()
        
        NotificationCenter.default.addObserver(self, selector: #selector(carouselViewSelecLink(notification:)), name: kCarouselViewSelectedLiveNotification, object: nil)
    }

    // MARK: - 重载父类
    override func setUpScrollView() -> UIScrollView {
        return maincollectionView
    }

    override func startRefresh() {
        loadDatas()
    }
    
    // 移除监听
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSBangumiViewController {
    
    fileprivate func loadDatas() {
        bangumiVM.requestDatas(finishCallBack: { [weak self] in
            DispatchQueue.main.async {
                self?.maincollectionView.reloadData()
                self?.endRefresh(loadSuccess: true)
            }
            }, failueCallBack: {
                DispatchQueue.main.async { [weak self] in
                    self?.maincollectionView.reloadData()
                    self?.endRefresh(loadSuccess: false)
                }
        })
    }
    
}

//======================================================================
// MARK:- collectionView 的数据源
//======================================================================
extension YSBangumiViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return bangumiVM.sectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bangumiVM.rowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return bangumiVM.createCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return bangumiVM.createFootHeadView(kind: kind, collectionView: collectionView, indexPath: indexPath)
    }
    
}

//======================================================================
// MARK:- collectionView 的代理方法
//======================================================================
extension YSBangumiViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bangumiVC = YSBangumiDetailViewController()
        let model = bangumiVM.statusArray[indexPath.section]
        let modelArray = model as! Array<Any>
        let detailModel = modelArray[indexPath.row]
        if detailModel is YSHomeBangumiDetailModel {
            bangumiVC.bangumiDetailModel = (detailModel as! YSHomeBangumiDetailModel)
            _ = navigationController?.pushViewController(bangumiVC, animated: true)
        }else {
            let recommdendModel = detailModel as! YSHomeBangumiRecommendModel
            let bangumiWebVC = YSBilibiliWebViewController()
            bangumiWebVC.urlString = recommdendModel.link
            _ = navigationController?.pushViewController(bangumiWebVC, animated: true)
        }
    }
}

//======================================================================
// MARK:- collectionView layout 的代理方法
//======================================================================
extension YSBangumiViewController: UICollectionViewDelegateFlowLayout{
    
    // 1. 每个section的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kPadding)
    }
    
    // 2.每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bangumiVM.caluateItemSize(indexPath: indexPath)
    }
    
    // 3.header的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return bangumiVM.caluateHeadSize(section: section)
    }
    
    // 4.footer的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return bangumiVM.caluateFootSize(section: section)
    }
}

//======================================================================
// MARK:- banner 点击事件
//======================================================================
extension YSBangumiViewController {
    func carouselViewSelecLink(notification:Notification) {
        let userInfo = notification.userInfo
        guard let link = userInfo?[kCarouselSelectedUrlKey] as? String else {
            self.noticeError("url错误")
            return
        }
        let webController = YSBilibiliWebViewController()
        webController.urlString = link
        navigationController?.pushViewController(webController, animated: true)
    }
}


