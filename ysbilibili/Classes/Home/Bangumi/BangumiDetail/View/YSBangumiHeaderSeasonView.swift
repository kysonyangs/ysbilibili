//
//  YSBangumiHeaderSeasonView.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

let kBangumiHeaderSeasonReuseKey = "kBangumiHeaderSeasonReuseKey"
fileprivate let kSeasonCollectionCellTitleFont = UIFont.systemFont(ofSize: 14)

class YSBangumiHeaderSeasonView: UIView {

    var seasonArray: [YSBangumiSeasonModel]? {
        didSet {
            guard let seasonArray = seasonArray else {return}
            for season in seasonArray {
                let width = season.title.widthWithConstrainedHeight(height: 1000, font: kSeasonCollectionCellTitleFont)
                itemWidthArray.append(width)
            }
            contentCollectionView.reloadData()
        }
    }
    
    /// 宽度数组
    var itemWidthArray = [CGFloat]()
    
    // MARK - 懒加载控件
    lazy var contentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let contentCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.backgroundColor = kHomeBackColor
        contentCollectionView.register(YSBangumiHeadSeasonCollectionViewCell.self, forCellWithReuseIdentifier: kBangumiHeaderSeasonReuseKey)
        contentCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20)
        return contentCollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentCollectionView)
        self.backgroundColor = kHomeBackColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.bottom.equalTo(self).offset(-15)
            make.left.right.equalTo(self)
        }
    }


}

//======================================================================
// MARK:- collectionview delegate datasource
//======================================================================
extension YSBangumiHeaderSeasonView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = seasonArray?.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBangumiHeaderSeasonReuseKey, for: indexPath) as! YSBangumiHeadSeasonCollectionViewCell
        cell.seasonModel = seasonArray?[indexPath.row]
        if indexPath.row == 0 {
            cell.type = .left
            cell.isShowingSeason = true
        }else if indexPath.row == (seasonArray?.count)! - 1 {
            cell.type = .right
        }else {
            cell.type = .center
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidthArray[indexPath.row] + 30
        return CGSize(width: width, height: 40)
    }
}


//======================================================================
// MARK:- cell
//======================================================================
enum BangumiHeadSeasonCellType: String {
    case left = "season_seasonLeft"
    case right = "season_seasonRight"
    case center = "season_seasonMiddle"
    
}

class YSBangumiHeadSeasonCollectionViewCell: UICollectionViewCell {
    
    var seasonModel: YSBangumiSeasonModel? {
        didSet {
            if let title = seasonModel?.title {
                titleLabel.text = title
            }
        }
    }
    
    var type: BangumiHeadSeasonCellType = .left {
        didSet {
            switch type {
            case .left:
                let imageStr = BangumiHeadSeasonCellType.left.rawValue
                let image = UIImage(named: imageStr)?.ysResizingImage()
                backImageView.image = image
            case .right:
                let imageStr = BangumiHeadSeasonCellType.right.rawValue
                let image = UIImage(named: imageStr)?.ysResizingImage()
                backImageView.image = image
            case .center:
                let imageStr = BangumiHeadSeasonCellType.center.rawValue
                let image = UIImage(named: imageStr)?.ysResizingImage()
                backImageView.image = image
            }
        }
    }
    
    var isShowingSeason = false {
        didSet {
            if !isShowingSeason {return}
            var imageStr = BangumiHeadSeasonCellType.left.rawValue
            imageStr = "\(imageStr)_s"
            let image = UIImage(named: imageStr)?.ysResizingImage()
            backImageView.image = image
        }
    }
    
    // MARK - cell 属性
    lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
    }()
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = kSeasonCollectionCellTitleFont
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backImageView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
}


