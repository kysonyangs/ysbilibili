//
//  YSBilibiliMineVC.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/7/28.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import SnapKit

let kMineCellReuseKey = "kMineCellReuseKey"
let kMineHeaderViewReuseKey = "kMineHeaderViewReuseKey"

class YSMineViewController: YSBaseViewController {
    
    let kPadding: CGFloat = 1
    let kTopMargin: CGFloat = 150
    
    let mineViewModel = YSMineViewModel()
    
    // Mark: - 懒加载控件
    fileprivate lazy var contentCollectionView: UICollectionView = { [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        let widthHeight = (kScreenWidth - 3 * self.kPadding) / 4
        flowLayout.itemSize = CGSize(width: widthHeight, height: widthHeight)
        flowLayout.minimumLineSpacing = self.kPadding
        flowLayout.minimumInteritemSpacing = self.kPadding
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(YSMineCollectionCell.self, forCellWithReuseIdentifier: kMineCellReuseKey)
        collectionView.register(YSMineHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kMineHeaderViewReuseKey)
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        collectionView.ysCornerRadius = kCornerRadius
        
        return collectionView
    }()
    
    fileprivate lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = kHomeBackColor
        view.ysCornerRadius = kCornerRadius
        return view
    }()
    
    fileprivate var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitleColor(kNavBarColor, for: .normal)
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = kCellCornerRadius
        return loginButton
    }()
    
    fileprivate var registButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        loginButton.setTitle("注册", for: .normal)
        loginButton.layer.cornerRadius = kCellCornerRadius
        return loginButton
    }()
    
    fileprivate var settingButton: UIButton = {
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "mine_setting_22x22_"), for: .normal)
        settingButton.backgroundColor = UIColor.clear
        return settingButton
    }()
    
    fileprivate var qrButton: UIButton = {
        let qrButton = UIButton()
        qrButton.setImage(UIImage(named: "mine_qr_22x22_"), for: .normal)
        qrButton.backgroundColor = UIColor.clear
        return qrButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kNavBarColor
        
        view.addSubview(settingButton)
        view.addSubview(qrButton)
        settingButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        qrButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.right.equalTo(settingButton.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(10)
            make.top.equalTo(view).offset(kTopMargin)
        }
        
        view.addSubview(contentCollectionView)
        contentCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(10)
            make.top.equalTo(view).offset(kTopMargin)
        }
        
        view.addSubview(registButton)
        registButton.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(80)
            make.right.equalTo(view.snp.centerX).offset(-10)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(registButton.snp.top)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.size.equalTo(registButton.snp.size)
        }
    }

}

extension YSMineViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mineViewModel.caluateSectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mineViewModel.caluateRowCount(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return mineViewModel.cell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return mineViewModel.headOrFoot(collectionView: collectionView, kind: kind, indexPath: indexPath)
    }
}

extension YSMineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: kScreenWidth, height: 40)
        }
        return CGSize(width: kScreenWidth, height: 50)
    }
}

extension YSMineViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            let delta = kTopMargin - offsetY
            backView.snp.updateConstraints({ (make) in
                make.top.equalTo(view).offset(delta)
            })
        } else {
            backView.snp.updateConstraints({ (make) in
                make.top.equalTo(view).offset(kTopMargin)
            })
        }
    }
}

//======================================================================
// MARK:- Collection Cell
//======================================================================
class YSMineCollectionCell: UICollectionViewCell {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var iconName: String = "" {
        didSet {
            iconImageView.image = UIImage(named: iconName)
        }
    }
    
    // Mark: - 懒加载控件
    fileprivate lazy var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(iconImageView.snp.bottom).offset(5)
        }
        
    }
    
}

//======================================================================
// MARK:- header view
//======================================================================
class YSMineHeaderView: UICollectionReusableView {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isFirstHeader = false {
        didSet {
            if isFirstHeader {
                ysCornerRadius = kCornerRadius
                topSpaceView.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
            } else {
                ysCornerRadius = 0
                topSpaceView.snp.updateConstraints({ (make) in
                    make.height.equalTo(10)
                })
            }
        }
    }
    
    // Mark: - 懒加载控件
    fileprivate var topSpaceView: UIView = {
        var view = UIView()
        view.backgroundColor = kHomeBackColor
        return view
    }()

    fileprivate var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    fileprivate var lineView: UIView = {
        var line = UIView()
        line.backgroundColor = kHomeBackColor
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(topSpaceView)
        addSubview(titleLabel)
        addSubview(lineView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        topSpaceView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(topSpaceView.snp.bottom)
            make.bottom.equalTo(self)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
    
}




