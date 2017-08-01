//
//  YSFPSStatus.swift
//  ysbilibili
//
//  Created by Kyson on 2017/7/18.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

class YSFPSStatus: NSObject {
    static let shared = YSFPSStatus()
    
    fileprivate var fpsLabel: UILabel!
    fileprivate var displayLink: CADisplayLink!
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var count: Int = 0
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(YSFPSStatus.applicationDidBecomeActiveNotification), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(YSFPSStatus.applicationWillResignActiveNotification), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        displayLink = CADisplayLink(target: self, selector: #selector(YSFPSStatus.displayLinkTick))
        displayLink.isPaused = true
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        fpsLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.size.width - 50) * 0.5 + 50, y: 0, width: 50, height: 20))
        fpsLabel.font = UIFont.boldSystemFont(ofSize: 12)
        fpsLabel.textColor = UIColor(red: 0.33, green: 0.84, blue: 0.43, alpha: 1.0)
        fpsLabel.backgroundColor = UIColor.clear
        fpsLabel.textAlignment = NSTextAlignment.center
        fpsLabel.tag = 101
    }
    
    deinit {
        displayLink.isPaused = true;
        displayLink.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func displayLinkTick() {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        
        let interval = displayLink.timestamp - lastTime
        if interval < 1 { return }
        lastTime = displayLink.timestamp
        
        let fps = Double(count) / interval
        count = 0
        
        fpsLabel.text = "\(Int(round(fps))) FPS"
    }
    
    @objc fileprivate func applicationDidBecomeActiveNotification() {
        displayLink.isPaused = false
    }
    
    @objc fileprivate func applicationWillResignActiveNotification() {
        displayLink.isPaused = true
    }
    
    public func open() {
        let view = UIApplication.shared.delegate?.window??.rootViewController?.view
        for label in view!.subviews {
            if label.isKind(of: UILabel.self) && label.tag == 101 {
                return
            }
        }
        
        displayLink.isPaused = false
        view!.addSubview(fpsLabel)
    }
    
    public func close() {
        displayLink.isPaused = true
        let rootVCViewSubViews = UIApplication.shared.delegate?.window??.rootViewController?.view.subviews
        for label in rootVCViewSubViews! {
            if label.isKind(of: UILabel.self) && label.tag == 101 {
                label.removeFromSuperview()
                return
            }
        }
    }
    
}
