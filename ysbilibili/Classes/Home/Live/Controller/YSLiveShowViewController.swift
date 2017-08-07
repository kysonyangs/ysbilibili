//
//  HomeLiveShowViewController.swift
//  zhnbilibili
//
//  Created by zhn on 16/11/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

import UIKit


let khomeLiveheadReuseKey = "khomeLiveheadReuseKey"
let khomeLiveFootReuseKey = "khomeLiveFootReuseKey"

class YSLiveShowViewController: YSRabbitFreshBaseViewController {

    // MARK: - 私有属性
    fileprivate lazy var liveVM: YSLiveViewModel = YSLiveViewModel()
    
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
        mainCollectionView.register(YSLiveShowCell.self, forCellWithReuseIdentifier: kLiveCellReuseKey)
        mainCollectionView.register(YSLiveHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: khomeLiveheadReuseKey)
        mainCollectionView.register(YSLiveFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: khomeLiveFootReuseKey)
        return mainCollectionView
    }()
    
    lazy var startLivIngButton: UIButton = {
        let startLivIngButton = UIButton()
        startLivIngButton.backgroundColor = UIColor.ysColor(red: 250, green: 91, blue: 136, alpha: 1)
        startLivIngButton.frame = CGRect(x: kScreenWidth - 80, y: kScreenHeight - 130, width: 60, height: 60)
        startLivIngButton.layer.cornerRadius = 30
        startLivIngButton.imageView?.contentMode = .center
        startLivIngButton.setImage(UIImage(named: "goLive"), for: .normal)
        startLivIngButton.setImage(UIImage(named: "goLive"), for: .highlighted)
        startLivIngButton.addTarget(self, action: #selector(startLive), for: .touchUpInside)
        return startLivIngButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 加载数据
        loadDatas()
        
        liveVM.delegate = self
        view.addSubview(startLivIngButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(carouselViewSelecLink(notification:)), name: kCarouselViewSelectedBangumiNotification, object: nil)
    }
    
    // MARK: - 重写父类的方法
    //1. 初始化滑动view
    override func setUpScrollView() -> UIScrollView {
        return  maincollectionView
    }
    
    // 2. 刷新状态调用的方法
    override func startRefresh() {
        loadDatas()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSLiveShowViewController {

    fileprivate func loadDatas() {
        liveVM.requestDatas(finishCallBack: {[weak self] in
            DispatchQueue.main.async {
                self?.maincollectionView.reloadData()
                self?.endRefresh(loadSuccess: true)
            }
            }, failueCallBack: {
                DispatchQueue.main.async {[weak self] in
                    self?.endRefresh(loadSuccess: false)
                }
        })
    }
}

//======================================================================
// MARK:- HomeLiveViewModelDelegate
//======================================================================
extension YSLiveShowViewController: YSLiveViewModelDelegate{
    
    func liveViewModelReloadSetion(section: Int) {
        DispatchQueue.main.async {
            self.maincollectionView.reloadSections(IndexSet(integer: section))
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension YSLiveShowViewController {
    func startLive()  {
        let startLiveVC = YSStartLiveViewController()
        _ = navigationController?.pushViewController(startLiveVC, animated: true)
    }
}

//======================================================================
// MARK:- collectionView 的数据源
//======================================================================
extension YSLiveShowViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return liveVM.statusModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveVM.returnRowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { 
        return liveVM.createCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return liveVM.createHeadorFoot(kind: kind,collectionView: collectionView, indexPath: indexPath)
    }
    
}

//======================================================================
// MARK:- collectionView 的代理方法
//======================================================================
extension YSLiveShowViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.拿到数据
        let sectionModel = liveVM.statusModelArray[indexPath.section]
        let rowModel = sectionModel.lives?[indexPath.row]
        // 2.生成控制器
        guard let playUrl = rowModel?.playurl else {return}
//        let vc = YSBilibiliLivePlayerViewController()
//        // 3.赋值
//        vc.liveString = playUrl
//        vc.liveModel = rowModel
//        // 4.跳转
//        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//======================================================================
// MARK:- collectionView layout 的代理方法
//======================================================================
extension YSLiveShowViewController: UICollectionViewDelegateFlowLayout{
    
    // 1. 每个section的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kPadding)
    }
    
    // 2.每个item的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return liveVM.calculateItemSize(indexPath: indexPath)
    }
    
    // 2.header的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return liveVM.calculateHeadHeight(section:section)
    }
    
    // 3.footer的size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return liveVM.calculateFootHeight(section: section)
    }
}

//======================================================================
// MARK:- banner 点击事件
//======================================================================
extension YSLiveShowViewController {
    
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

