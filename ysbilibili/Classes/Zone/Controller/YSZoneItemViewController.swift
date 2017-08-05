//
//  YSZoneItemViewController.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/2.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSZoneItemViewController: UIViewController {

    var zoneItemModel: YSZoneModel?
    var inset = UIEdgeInsets.zero {
        didSet {
            contentTableView.contentInset = inset
            contentTableView.scrollIndicatorInsets = contentTableView.contentInset
        }
    }
    var itemViewModel = YSZoneItemViewModel()
    
    fileprivate lazy var contentTableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = kHomeBackColor
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        view.addSubview(contentTableView)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        contentTableView.frame = view.bounds
        contentTableView.mj_header = YSGifHeader(refreshingBlock: { [weak self] in
            self?.requestData()
        })
        requestData()
    }
}

extension YSZoneItemViewController {
    fileprivate func requestData() {
        guard let tid = zoneItemModel?.tid else {
            return
        }
        
        itemViewModel.requestData(rid: tid) { [weak self] in
            self?.contentTableView.reloadData()
            self?.contentTableView.mj_header.endRefreshing()
        }
        
    }
}

extension YSZoneItemViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemViewModel.statusArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemViewModel.statusArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = YSPlayerRelatesCell.relatesCellWithTableView(tableView: tableView)
        let sectionArray = itemViewModel.statusArray[indexPath.section]
        let itemModel = sectionArray[indexPath.row]
        cell.playItemModel = itemModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = YSZoneItemHeader()
        if section == 0 {
            header.type = .recommend
        }else {
            header.type = .new
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension YSZoneItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("跳转到播放界面")
//        let sectionArray = itemViewModel.statusArray[indexPath.section]
//        let itemModel = sectionArray[indexPath.row]
//        let playerVC = YSNormalPlayerViewController()
//        playerVC.itemModel = itemModel
//        self.navigationController?.pushViewController(playerVC, animated: true)
    }
}
