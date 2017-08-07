//
//  YSBangumiDetailViewController.swift
//
//  Created by YangShen on 17/1/20.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSBangumiDetailViewController: YSBaseViewController {

    // 模型数据
    var bangumiDetailModel: YSHomeBangumiDetailModel?
    // VM
    var bangumiDetailVM = YSBangumiDetailViewModel()
    
    // MARK - 懒加载控件
    lazy var contentTableView: UITableView = {
        let contentTableView = UITableView(frame: CGRect.zero, style: .grouped)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.bounces = false
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableViewAutomaticDimension
        contentTableView.separatorStyle = .none
        return contentTableView
    }()
    
    lazy var headView: YSBangumiHeaderView = {
        let headView = YSBangumiHeaderView()
        return headView
    }()
    
    lazy var recommendHeadView: YSBangumiCommendHeaderView = {
        let recommendHeadView = YSBangumiCommendHeaderView()
        recommendHeadView.isHidden = true
        recommendHeadView.backgroundColor = UIColor.ysColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        return recommendHeadView
    }()
    
    // MARK - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        requestData()
        
        addActionObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//======================================================================
// MARK:- tableview delegate datasource
//======================================================================
extension YSBangumiDetailViewController: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return bangumiDetailVM.dealSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bangumiDetailVM.dealRowCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return bangumiDetailVM.cell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return bangumiDetailVM.hotFooter(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // navibar的透明度变化
        let offsetY = scrollView.contentOffset.y
        let delta = offsetY + 20
        var alpha = delta/50
        alpha = alpha > 1 ? 1 : alpha
        naviBar.alpha = alpha
        
        // 评论的head的变化
        let recommendDelta = delta + CGFloat(BangumiheadSectionType.recommendHead.rawValue) + kNavBarHeight
        if recommendDelta >= headView.viewHeight() {
            recommendHeadView.isHidden = false
        }else {
            recommendHeadView.isHidden = true
        }
        // 初始化的时候的处理
        if delta == 0 {
            recommendHeadView.isHidden = true
        }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSBangumiDetailViewController {
    fileprivate func setupUI() {
        naviBar.isHidden = false
        naviBar.alpha = 0
        naviBar.backgroundColor = UIColor.white
        naviBar.titleLabel.textColor = UIColor.black
        naviBar.backArrowButton.setImage(UIImage(named: "common_back_v2")?.ysTintColor(UIColor.black), for: .normal)
        naviBar.backArrowButton.setImage(UIImage(named: "common_back_v2")?.ysTintColor(UIColor.black), for: .highlighted)
        
        view.insertSubview(contentTableView, belowSubview: naviBar)
        contentTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(-20, 0, 0, 0))
        }
        
        view.addSubview(recommendHeadView)
        recommendHeadView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(naviBar.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    fileprivate func requestData() {
        if let seasonID = bangumiDetailModel?.season_id {
            bangumiDetailVM.bangumiRequestData(seasonId: seasonID,finishAction: {[weak self] in
                DispatchQueue.main.async {
                    self?.headView.headModel = self?.bangumiDetailVM.bangumiDetailModel
                    self?.headView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: (self?.headView.viewHeight())!)
                    self?.contentTableView.tableHeaderView = self?.headView
                    self?.contentTableView.reloadData()
                    if let title = self?.bangumiDetailVM.bangumiDetailModel?.bangumi_title {
                        self?.naviBar.titleLabel.text = title
                    }
                }
            })
        }
    }
    
    fileprivate func addActionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(backAction), name: kBangumiDetainClickBackButtonNotification, object: nil)
    }
    
    @objc fileprivate func backAction() {
       _ = navigationController?.popViewController(animated: true)
    }
}

