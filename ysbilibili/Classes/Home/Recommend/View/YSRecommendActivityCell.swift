//
//  YSRecommendActivityCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSRecommendActivityCell: UICollectionViewCell {
    let kActivityReuseKey = "kActivityReuseKey"
    // cell的宽高
    let cellheight: CGFloat = 150
    var cellWidth: CGFloat {
        return (kScreenWidth - kPadding) / 2
    }
    
    var statusArray:[YSItemDetailModel]? {
        didSet{
            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - 懒加载
    lazy var mainCollectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumLineSpacing = kPadding
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: self.cellWidth, height: self.cellheight)
        let mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 150), collectionViewLayout: flowLayout)
        mainCollectionView.backgroundColor = UIColor.white
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.contentInset = UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kPadding)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.backgroundColor = kHomeBackColor
        mainCollectionView.register(YSNormalBaseCell.self, forCellWithReuseIdentifier: self.kActivityReuseKey)
        return mainCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainCollectionView)
        self.backgroundColor = kHomeBackColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 代理方法
extension YSRecommendActivityCell: UICollectionViewDelegate {
    
}

// MARK: - 数据源
extension YSRecommendActivityCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (statusArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. 生成cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kActivityReuseKey, for: indexPath) as! YSNormalBaseCell
        // 2. 获取赋值数据
        let statusModel = statusArray?[indexPath.row]
        cell.statusModel = statusModel
        // 3. 返回cell
        return cell
    }
}


