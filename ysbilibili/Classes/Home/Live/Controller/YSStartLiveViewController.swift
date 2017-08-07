//
//  HomeStartLiveViewController.swift
//  zhnbilibili
//
//  Created by 张辉男 on 17/1/23.
//  Copyright © 2017年 zhn. All rights reserved.
//

import UIKit

class YSStartLiveViewController: UIViewController {

    // MARK - 懒加载控件
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3, outputImageOrientation: UIInterfaceOrientation.portrait)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        session?.captureDevicePosition = AVCaptureDevicePosition.back
        session?.beautyFace = true
        return session!
    }()
    
    lazy var liveStartEndButton: UIButton = {
        let liveStartEndButton = UIButton()
        liveStartEndButton.ysCornerRadius = 25
        liveStartEndButton.ysBoderColor = kNavBarColor
        liveStartEndButton.ysBoderWidth = 1
        liveStartEndButton.setTitle("开始直播", for: .normal)
        liveStartEndButton.setTitleColor(kNavBarColor, for: .normal)
        liveStartEndButton.addTarget(self, action: #selector(liveButtonAction), for: .touchUpInside)
        return liveStartEndButton
    }()

    lazy var disMissButton: UIButton = {
        let disMissButton = UIButton()
        disMissButton.setImage(UIImage(named: "circle_buy_vip_close"), for: .normal)
        disMissButton.addTarget(self, action: #selector(disMissAction), for: .touchUpInside)
        return disMissButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(liveStartEndButton)
        liveStartEndButton.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(50)
            make.right.equalTo(view).offset(-50)
            make.bottom.equalTo(view).offset(-30)
            make.height.equalTo(50)
        }
        view.addSubview(disMissButton)
        disMissButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(30)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}

//======================================================================
// MARK:- 私有方法
//======================================================================
extension YSStartLiveViewController {
    fileprivate func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        }
    }
    
    fileprivate func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeAudio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        }
    }
    
    fileprivate func startLive() {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://192.168.0.103:1935/rtmplive/room"
        requestAccessForAudio()
        requestAccessForVideo()
        session.startLive(stream)
    }
    
    fileprivate func stopLive() {
        session.running = false
        session.stopLive()
    }
    
    fileprivate func buttonStartType() {
        liveStartEndButton.ysBoderColor = kNavBarColor
        liveStartEndButton.setTitle("开始直播", for: .normal)
        liveStartEndButton.setTitleColor(kNavBarColor, for: .normal)
    }
    
    fileprivate func buttonEndType() {
        liveStartEndButton.ysBoderColor = UIColor.white
        liveStartEndButton.setTitle("结束直播", for: .normal)
        liveStartEndButton.setTitleColor(UIColor.white, for: .normal)
    }
}

//======================================================================
// MARK:- LFLiveSessionDelegate
//======================================================================
extension YSStartLiveViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print(debugInfo as Any)
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print(errorCode)
    }
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case LFLiveState.ready:
            buttonStartType()
            print("未连接")
            break;
        case LFLiveState.pending:
            print("连接中")
            break;
        case LFLiveState.start:
            buttonEndType()
            print("已连接")
            break;
        case LFLiveState.error:
            print("连接错误")
            break;
        case LFLiveState.stop:
            buttonStartType()
            print("未连接")
            break;
        default:
            break;
        }
    }
}

//======================================================================
// MARK:- target action
//======================================================================
extension YSStartLiveViewController {
    @objc func liveButtonAction() {
        switch session.state {
        case .ready:
            startLive()
        case .start:
            stopLive()
        default:
            startLive()
        }
    }
    
    @objc func disMissAction() {
        _ = navigationController?.popViewController(animated: true)
    }
}

