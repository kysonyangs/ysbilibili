//
//  YSZoneViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/31.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

let kZoneCellReuseKey = "kZoneCellReuseKey"
let kHomeViewControllerShowLiveNotification = "kHomeViewControllerShowLiveNotification"

class YSZoneViewController: YSBaseViewController {
    
    fileprivate var zoneViewModel = YSZoneViewModel()
    
    fileprivate lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: kScreenWidth / 4, height: kScreenWidth / 4)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(YSZoneCell.self, forCellWithReuseIdentifier: kZoneCellReuseKey)
        collectionView.backgroundColor = kHomeBackColor
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        view.addSubview(contentCollectionView)
        setupContraints()
        
        requestData()
        
    }
    
    fileprivate func setupNav() {
        naviBar.titleLabel.text = "分区"
    }
    
    fileprivate func setupContraints() {
        contentCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(kNavBarHeight)
        }
    }
    
    fileprivate func requestData() {
        zoneViewModel.requestData { [weak self] in
            self?.contentCollectionView.reloadData()
        }
    }

}

extension YSZoneViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return zoneViewModel.zoneModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kZoneCellReuseKey, for: indexPath) as! YSZoneCell
        let model = zoneViewModel.zoneModelArray[indexPath.row]
        cell.zoneModel = model
        return cell
    }
}

extension YSZoneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let zoneModel = zoneViewModel.zoneModelArray[indexPath.row]
        if zoneModel.name == "直播" {
            print("goto 直播")
        } else if zoneModel.name == "广告" {
            print("goto 广告")
        } else if zoneModel.name == "游戏中心" {
            print("goto 游戏中心")
        } else {
            print("goto 详情页")
            let detailVc = YSZoneDetailViewController()
            detailVc.zoneModel = zoneModel
            navigationController?.pushViewController(detailVc, animated: true)
        }
        
    }
}
