//
//  SlideMenu.swift
//  ysbilibili
//
//  Created by MOLBASE on 2017/8/1.
//  Copyright © 2017年 YangShen. All rights reserved.
//

import UIKit

@objc protocol SlideMenuDelegate {
    @objc optional func selectedIndex(index: Int)
}

class SlideMenu: UIView {
    
    // Mark: - 常量
    fileprivate let kLabelWidthAppend: CGFloat = 5
    fileprivate let kSliderVPadding: CGFloat = 6
    fileprivate let kSliderHeight: CGFloat = 2
    let kVerticalPadding: CGFloat = 8
    
    struct SlideMenuTitleColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
    }
    
    // 当前显示的index
    fileprivate var showingIndex = 0
    
    // 标题数组
    fileprivate var titleArray: [String]?
    // 标题之间的间距
    fileprivate var padding: CGFloat = 15
    // 标题常态的颜色
    fileprivate var normalColor = SlideMenuTitleColor()
    // 标题高亮的颜色
    fileprivate var highlightColor = SlideMenuTitleColor()
    // 标题字体大小，默认：15
    fileprivate var titleFont: CGFloat = 15
    // 滑块颜色，默认：白色
    fileprivate var sliderColor = UIColor.white
    
    // 是否横向展示(不换行)
    fileprivate var isHorizon = false
    
    // 容器的scrollView，对应的scrollView，根据偏移量来判断在哪个标题以及做动画
    fileprivate var contentScrollView: UIScrollView?
    
    // 代理
    weak var delegate: SlideMenuDelegate?
    
    // 高亮和常态颜色之间的色差，滑动变化时需要根据这个改变颜色
    fileprivate var redDelta: CGFloat = 0
    fileprivate var greenDelta: CGFloat = 0
    fileprivate var blueDelta: CGFloat = 0
    
    fileprivate var labelArray = [UILabel]()
    
    // 计算frame需要的一些变量
    fileprivate var titleFrameArray = [CGRect]()
    fileprivate var titleWidthArray = [CGFloat]()
    fileprivate var lineFeedIndex: Int = 0   // 记录需要换行的位置
    fileprivate var oldMenuScrollViewContentX: CGFloat = 0
    fileprivate var rowHeight: CGFloat = 30
    var rowCount: Int = 1
    
    // Mark: - 懒加载
    fileprivate lazy var slider = UIView()
    
    fileprivate lazy var menuScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        return scrollView
    }()
    
    deinit {
        // 移除监听
        contentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

}

//======================================================================
// MARK:- public method
//======================================================================
extension SlideMenu {
    convenience init(frame: CGRect, titles: [String], padding: CGFloat, normalColor: SlideMenuTitleColor, highlightColor: SlideMenuTitleColor, font: CGFloat, sliderColor: UIColor, scrollView: UIScrollView, isHorizon: Bool = false, rowHeight: CGFloat) {
        self.init(frame: frame)
        self.titleArray = titles
        self.padding = padding
        self.normalColor = normalColor
        self.highlightColor = highlightColor
        self.titleFont = font
        self.sliderColor = sliderColor
        self.slider.backgroundColor = sliderColor
        self.contentScrollView = scrollView
        self.isHorizon = isHorizon
        self.rowHeight = rowHeight
        
        scrollView.bounces = false
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        redDelta = highlightColor.red - normalColor.red
        greenDelta = highlightColor.green - normalColor.green
        blueDelta = highlightColor.blue - normalColor.blue
        
        initSubViews()
    }

}

//======================================================================
// MARK:- private method
//======================================================================
extension SlideMenu {
    fileprivate func initSubViews() {
        var superView: UIView = self
        if isHorizon {
            self.addSubview(menuScrollView)
            menuScrollView.frame = bounds
            superView = menuScrollView
        }
        
        // 1. 添加label控件
        guard let tempArray = titleArray else {
            return
        }
        
        let delta = (contentScrollView?.contentSize.width)! / CGFloat(tempArray.count)
        for i in 0..<tempArray.count {
            let label = UILabel()
            label.tag = i
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            let tapGest = UITapGestureRecognizer(tap: {  [weak self] in
                self?.delegate?.selectedIndex!(index: i)
                let visableRect = CGRect(x: delta * CGFloat(i), y: 0, width: (self?.contentScrollView?.ysWidth)!, height: (self?.contentScrollView?.ysHeight)!)
                self?.contentScrollView?.scrollRectToVisible(visableRect, animated: true)
            })
            label.addGestureRecognizer(tapGest)
            label.text = tempArray[i]
            label.font = UIFont.systemFont(ofSize: titleFont)
            labelArray.append(label)
            superView.addSubview(label)
            
            if i == showingIndex {
                label.textColor = UIColor.ysColor(red: highlightColor.red, green: highlightColor.green, blue: highlightColor.blue, alpha: 1)
            } else {
                label.textColor = UIColor.ysColor(red: normalColor.red, green: normalColor.green, blue: normalColor.blue, alpha: 1)
            }
            
        }
        
        // 2.布局
        let tempString = "k"
        let fitHeight = tempString.heightWithConstrainedWidth(width: 100, font: UIFont.systemFont(ofSize: titleFont))
        
        var startX: CGFloat = 0
        var startY: CGFloat = 0
        var autoPadding: CGFloat = 0
        
        for i in 0..<tempArray.count {
            let str = tempArray[i]
            if isHorizon { // 水平显示(超出边界的情况滑动显示)
                let fitWidth = str.widthWithConstrainedHeight(height: fitHeight, font: UIFont.systemFont(ofSize: titleFont)) + kLabelWidthAppend
                var x = padding + startX
                if startX == 0 {
                    x = 0
                }
                let currentRect = CGRect(x: x, y: startY, width: fitWidth, height: fitHeight)
                startX = currentRect.maxX
                
                // 缓存frame和宽度
                titleFrameArray.append(currentRect)
                titleWidthArray.append(fitWidth)
            } else { // 竖直显示 超过边界换行显示，均分哪一行的间距
                // 如果需要自适应的话就重新计算一下padding
                if i == lineFeedIndex {
                    let zrowCount = rowCount
                    autoPadding = countPadding(height: fitHeight)
                    startX = 0
                    if zrowCount > 1 {
                        startY += (rowHeight + kVerticalPadding) * CGFloat(rowCount-1)
                    }
                }
                
                // 先生成一个frame 主要是用来计算
                let fitwidth = str.widthWithConstrainedHeight(height: fitHeight, font: UIFont.systemFont(ofSize: titleFont)) + kLabelWidthAppend
                var x: CGFloat = 0
                if startX != 0 {
                    x = startX + autoPadding
                }
                let currentRect = CGRect(x: x, y: startY, width: fitwidth, height: fitHeight)
                let maxX = currentRect.maxX
        
                titleFrameArray.append(currentRect)
                titleWidthArray.append(fitwidth)
                startX = maxX
    
            }
        }
        
        if isHorizon {
            menuScrollView.contentSize = CGSize(width: startX, height: self.ysHeight)
        }
        
        // 3.label位置赋值
        for item in labelArray.enumerated(){
            item.element.frame = titleFrameArray[item.offset]
        }
        
        // 4.初始化滑块的位置
        superView.addSubview(slider)
        let firstRect = titleFrameArray.first!
        slider.frame = CGRect(x: firstRect.origin.x, y: firstRect.maxY + kSliderVPadding, width: firstRect.width, height: kSliderHeight)
    }
    
    // 计算自适应padding的情况下的 padding
    fileprivate func countPadding(height:CGFloat) -> CGFloat {
        var addedWidth: CGFloat = 0
        var autoPadding: CGFloat = padding
        
        for i in lineFeedIndex..<(titleArray!.count){
            let str = titleArray![i]
            let width = str.widthWithConstrainedHeight(height: height, font: UIFont.systemFont(ofSize: titleFont)) + kLabelWidthAppend
            
            addedWidth += width + padding
            
            // 如果是需要换行的情况下返回一个 设置的padding值
            if addedWidth - padding > self.ysWidth {
                autoPadding = (self.ysWidth - addedWidth + width + padding * CGFloat(i+1)) / (CGFloat(i - lineFeedIndex - 1))
                lineFeedIndex = i
                rowCount += 1
                return autoPadding
            }
        }
        
        if lineFeedIndex == 0 {
            autoPadding = (self.ysWidth - addedWidth + padding * CGFloat(titleArray!.count)) / (CGFloat(titleArray!.count - lineFeedIndex - 1))
        }
  
        return autoPadding
    }

}

//======================================================================
// MARK:- scrollView 的 KVO
//======================================================================
extension SlideMenu {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else {return}
        
        let offsetX = (contentScrollView?.contentOffset.x)!
        let scrollWidth = (contentScrollView?.contentSize.width)!
        // 每一页的宽度
        let pageWidth = scrollWidth / CGFloat((titleArray?.count)!)
        // 显示的位置 = 页数 + 百分比
        let floatDelta = offsetX / pageWidth
        // 页数
        let index = Int(floatDelta)
        // 百分比
        let percent = floatDelta - CGFloat(index)
        
        // 当前显示的index (percent = 0 的情况下设置这个index便于计算)
        if percent == 0 {
            showingIndex = index
        }
                
        // 超出数组的边界处理
        guard index < (titleArray?.count)! - 1 else {return}
        
        let leftRect = titleFrameArray[index]
        let rightRect = titleFrameArray[index + 1]
        
        let leftLabel = labelArray[index]
        let rightLabel = labelArray[index + 1]
        
        let normalToHightColor = UIColor.ysColor(red: normalColor.red + percent * redDelta, green: normalColor.green + percent * greenDelta, blue: normalColor.blue + percent * blueDelta, alpha: 1)
        let hightToNormalColor = UIColor.ysColor(red: highlightColor.red - percent * redDelta, green: highlightColor.green - percent * greenDelta, blue: highlightColor.blue - percent * blueDelta, alpha: 1)
        
        // 标题颜色变化
        
        let toRight = showingIndex == index // true 向右 false 向左
        
        leftLabel.textColor = toRight ? hightToNormalColor : normalToHightColor
        rightLabel.textColor = toRight ? normalToHightColor : hightToNormalColor
        
        // 滑块位置的变化
        if leftRect.origin.y == rightRect.origin.y { // 不换行
            // 位置变化
            let x = (rightRect.origin.x - leftRect.origin.x) * percent + leftRect.origin.x
            let y = leftRect.maxY + kSliderVPadding
            let width = (rightRect.width - leftRect.width) * percent + leftRect.width
            let sliderRect = CGRect(x: x, y: y, width: width, height: kSliderHeight)
            slider.frame = sliderRect
            
            if isHorizon { // menu水平显示的时候需要滑动到最中间
                // title 滑动到中间
                var offsetX: CGFloat = 0
                var pointX: CGFloat = 0
                if toRight {// 右滑
                    offsetX =  rightLabel.frame.midX - self.ysWidth / 2
                    if percent == 0 {
                        oldMenuScrollViewContentX = leftLabel.frame.midX - self.ysWidth / 2
                    }
                    pointX = (offsetX - oldMenuScrollViewContentX) * percent + oldMenuScrollViewContentX
                } else { // 左滑
                    offsetX = leftLabel.frame.midX - self.ysWidth / 2
                    if percent == 0 {
                        oldMenuScrollViewContentX = rightLabel.frame.midX - self.ysWidth / 2
                    }
                    pointX = oldMenuScrollViewContentX - (oldMenuScrollViewContentX - offsetX) * (1-percent)
                }
                
                // 超过了最小值
                if pointX < 0 {
                    pointX = 0
                }
                // 超过了最大值
                if pointX > (menuScrollView.contentSize.width - menuScrollView.ysWidth){
                    pointX = (menuScrollView.contentSize.width - menuScrollView.ysWidth)
                }
                // 赋值
                menuScrollView.setContentOffset(CGPoint(x: pointX, y: 0), animated: false)
            }
        } else { // 需要换行显示的情况下
            // bilibili 的换行策略是在换行的临界处滑了就先让滑块先换行
            var tempRect = toRight ? rightRect : leftRect
            
            if index == (titleArray?.count)! - 2 {
                tempRect = rightRect
            }
            
            // 停止滑动的时候没有达到要换行的情况(回到未换行的状态)
            if showingIndex == index && percent == 0 {
                tempRect = leftRect
            }
            
            // 赋值新的位置
            let x = tempRect.origin.x
            let y = tempRect.maxY + kSliderVPadding
            let width = tempRect.width
            let slidingRect = CGRect(x: x, y: y, width: width, height: kSliderHeight)
            slider.frame = slidingRect
        }
    }
}












    
