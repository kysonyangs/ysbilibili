//
//  YSNormalBaseCell.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/7.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol YSNormalBaseCellDelegate {
    @objc optional func normalBaseReloadSection(section: Int, type: String?)
}

class YSNormalBaseCell: UICollectionViewCell {
    // 自定义内容的高度 （默认是40）
    var customContentImageBottomOffset: CGFloat = 40
    
    // MARK: - 属性 set 方法
    var statusModel: YSItemDetailModel? {
        didSet{
            intialStatus()
        }
    }
    // MARK: - 属性
    /// 是否显示刷新按钮
    var showReloadButton = false {
        didSet {
            // 特殊处理每一个section的最后一个数据 (涉及重用的需要在赋值的时候对不同状态做不同的处理)
            if showReloadButton {
                reloadButton.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self).offset(5)
                    make.right.equalTo(self).offset(10)
                    make.size.equalTo(CGSize(width: 60, height: 60))
                }
            } else {
                reloadButton.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self)
                    make.right.equalTo(self)
                    make.size.equalTo(CGSize(width: 0, height: 0))
                }
            }
        }
    }
    
    /// 这连个属性用来判断
    var selectedSection: Int = 0
    var sectiontype: String?
    
    /// 代理
    var delegate:YSNormalBaseCellDelegate?
    
    
    // MARK: - 懒加载控件
    lazy var maskImageView: UIImageView = {
        let maskImageView = UIImageView()
        maskImageView.image = UIImage(named: "live_bottom_bg")
        maskImageView.layer.cornerRadius = 6
        return maskImageView
    }()
    
    lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.contentMode = UIViewContentMode.scaleAspectFill
        contentImageView.layer.masksToBounds = true
        contentImageView.layer.cornerRadius = 6
        return contentImageView
    }()
    
    lazy var placeholderImageView: UIImageView = {
        let placeHolderImageView = UIImageView()
        placeHolderImageView.contentMode = UIViewContentMode.center
        placeHolderImageView.image = UIImage(named: "default_img")
        return placeHolderImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titileLabel = UILabel()
        titileLabel.numberOfLines = 0
        titileLabel.backgroundColor = kHomeBackColor
        titileLabel.layer.masksToBounds = true
        titileLabel.font = kNormalItemCellTitleFont
        // 这个属性设置的是超出uilabel的部分不显示（默认是显示...）
        titileLabel.lineBreakMode = .byCharWrapping
        return titileLabel
    }()
    
    lazy var reloadButton: UIButton = {
        let reloadButton = UIButton()
        reloadButton.setBackgroundImage(UIImage(named: "home_refresh_new"), for: .normal)
        reloadButton.setBackgroundImage(UIImage(named: "home_refresh_new"), for: .highlighted)
        reloadButton.addTarget(self, action: #selector(clickReload), for: .touchUpInside)
        return reloadButton
    }()
    
    // MARK: - 添加子控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(placeholderImageView)
        self.addSubview(contentImageView)
        contentImageView.addSubview(maskImageView)
        self.addSubview(titleLabel)
        self.addSubview(reloadButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化位置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        placeholderImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(kCenterPadding)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-customContentImageBottomOffset)
        }
        
        contentImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(kCenterPadding)
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-customContentImageBottomOffset)
        }
        
        maskImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        }
        
        // 特殊处理每一个section的最后一个数据
        if showReloadButton{
            reloadButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(self).offset(5)
                make.right.equalTo(self).offset(10)
                make.size.equalTo(CGSize(width: 60, height: 60))
            }
        }else{
            reloadButton.snp.makeConstraints { (make) in
                make.bottom.equalTo(self)
                make.right.equalTo(self)
                make.size.equalTo(CGSize(width: 0, height: 0))
            }
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(reloadButton.snp.left)
            make.top.equalTo(contentImageView.snp.bottom)
            make.height.lessThanOrEqualTo(40)
        }
    }
}

// MARK: - target action
extension YSNormalBaseCell {
    
    // 点击刷新了每个section的数据
    @objc fileprivate func clickReload(){
        
        // 1.按钮做旋转动画
        let rotaAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotaAnimation.toValue = Float.pi * 8
        rotaAnimation.repeatCount = MAXFLOAT
        rotaAnimation.duration = 3
        reloadButton.layer.add(rotaAnimation, forKey: "rotaanimation")
        
        // 2.通知代理
        if let delegate = delegate {
            if let method = delegate.normalBaseReloadSection{
                method(selectedSection, sectiontype)
            }
        }
    }
}

// MARK -
extension YSNormalBaseCell {
    func intialStatus() {
        // 1.赋值图片
        if let urlString = statusModel?.cover {
            let url = URL(string: urlString)
            contentImageView.sd_setImage(with: url)
        }
        // 2.赋值标题
        if let title = statusModel?.title {
            let str = "\(title)\n\n\n"
            titleLabel.text = str
        }
    }
}

