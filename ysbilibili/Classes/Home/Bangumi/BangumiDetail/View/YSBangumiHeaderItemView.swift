//
//  YSBangumiHeaderItemView.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

fileprivate let kBangumiItemCellReuseKey = "kBangumiItemCellReuseKey"

class YSBangumiHeaderItemView: UIView {

    var listArray: [YSBangumiCollectModel]? {
        didSet{
            contentCollectionView.reloadData()
            if let count = listArray?.count {
                titleRightLabel.text = "更新至 第\(count)话"
            }
        }
    }
    
    // MARK - 懒加载控件
    fileprivate lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: kScreenWidth/2.7, height: 80)
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = kHomeBackColor
        contentCollectionView.register(YSBangumiItemCollectionCell.self, forCellWithReuseIdentifier: kBangumiItemCellReuseKey)
        contentCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20)
        return contentCollectionView
    }()
    
    fileprivate lazy var titleLeftLabel: UILabel = {
        let titleLeftLabel = UILabel()
        titleLeftLabel.text = "选集"
        return titleLeftLabel
    }()
    
    lazy var titleRightLabel : UILabel = {
        let titleRightLabel = UILabel()
        titleRightLabel.textColor = UIColor.lightGray
        titleRightLabel.font = UIFont.systemFont(ofSize: 14)
        return titleRightLabel
    }()
    
    lazy var titleArrowImageView: UIImageView = {
        let titleArrowImageView = UIImageView()
        titleArrowImageView.image = UIImage(named: "more_arrow")
        titleArrowImageView.contentMode = .center
        return titleArrowImageView
    }()
    
    lazy var lineView: UIImageView = {
        let lineView = UIImageView()
        lineView.backgroundColor = kCellLineColor
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentCollectionView)
        self.addSubview(titleArrowImageView)
        self.addSubview(titleRightLabel)
        self.addSubview(titleLeftLabel)
        self.addSubview(lineView)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLeftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(15)
        }
        titleArrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLeftLabel)
            make.right.equalTo(self).offset(-10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        titleRightLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleArrowImageView)
            make.right.equalTo(titleArrowImageView.snp.left).offset(-5)
        }
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLeftLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-15)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

}

//======================================================================
// MARK:- collectionView delegate datasource
//======================================================================
extension YSBangumiHeaderItemView: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = listArray?.count else {return 0}
        return  count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBangumiItemCellReuseKey, for: indexPath) as! YSBangumiItemCollectionCell
        cell.index = indexPath.row
        if let listModel = listArray?[indexPath.row] {
            cell.detailModel = listModel
        }
        if (listArray?.count) != nil {
            if indexPath.row  == 0 {
                cell.isShowing = true
            }else {
                cell.isShowing = false
            }
        }
        return cell
    }
}

//======================================================================
// MARK:- collcetionview cell
//======================================================================
class YSBangumiItemCollectionCell: UICollectionViewCell {
    
    var index: Int = 0 {
        didSet {
            titleLabel.text = "第\(index + 1)话"
        }
    }
    
    var detailModel: YSBangumiCollectModel? {
        didSet {
            guard let content = detailModel?.index_title else {return}
            contentLabel.text = content
        }
    }
    
    var isShowing = false {
        didSet {
            if isShowing {
                self.ysBoderColor = kNavBarColor
                titleLabel.textColor = kNavBarColor
                contentLabel.textColor = kNavBarColor
            } else {
                self.ysBoderColor = UIColor.lightGray
                titleLabel.textColor = UIColor.black
                contentLabel.textColor = UIColor.black
            }
        }
    }
    // MARK - 懒加载控件
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "title"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.text = "lalal"
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    // MARK - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ysBoderColor = UIColor.lightGray
        self.ysCornerRadius = 5
        self.ysBoderWidth = 1
        self.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
}
