//
//  HYLabel.swift
//  HYLabel
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit

enum TapHandlerType : Int {
    case noneHandle = 0
    case userHandle = 1
    case topicHandle = 2
    case linkHandle = 3
}

open class HYLabel: UILabel {
    
    // MARK:- 属性
    // 重写系统的属性
    override open var text : String? {
        didSet {
            prepareText()
        }
    }
    
    override open var attributedText: NSAttributedString? {
        didSet {
            prepareText()
        }
    }
    
    override open var font: UIFont! {
        didSet {
            prepareText()
        }
    }
    
    override open var textColor: UIColor! {
        didSet {
            prepareText()
        }
    }
    
    open var matchTextColor : UIColor = UIColor(red: 87 / 255.0, green: 196 / 255.0, blue: 251 / 255.0, alpha: 1.0) {
        didSet {
            prepareText()
        }
    }
    
    // 懒加载属性
    fileprivate lazy var textStorage : NSTextStorage = NSTextStorage() // NSMutableAttributeString的子类
    fileprivate lazy var layoutManager : NSLayoutManager = NSLayoutManager() // 布局管理者
    fileprivate lazy var textContainer : NSTextContainer = NSTextContainer() // 容器,需要设置容器的大小
    
    // 用于记录下标值
    fileprivate lazy var linkRanges : [NSRange] = [NSRange]()
    fileprivate lazy var userRanges : [NSRange] = [NSRange]()
    fileprivate lazy var topicRanges : [NSRange] = [NSRange]()
    
    // 用于记录用户选中的range
    fileprivate var selectedRange : NSRange?
    
    // 用户记录点击还是松开
    fileprivate var isSelected : Bool = false
    
    // 闭包属性,用于回调
    fileprivate var tapHandlerType : TapHandlerType = TapHandlerType.noneHandle
    
    public typealias HYTapHandler = (HYLabel, String, NSRange) -> Void
    open var linkTapHandler : HYTapHandler?
    open var topicTapHandler : HYTapHandler?
    open var userTapHandler : HYTapHandler?
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    
    // MARK:- 布局子控件
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置容器的大小为Label的尺寸
        textContainer.size = frame.size
    }
    
    // MARK:- 重写drawTextInRect方法
    override open func drawText(in rect: CGRect) {
        // 1.绘制背景
        if selectedRange != nil {
            // 2.0.确定颜色
            let selectedColor = isSelected ? UIColor(white: 0.7, alpha: 0.2) : UIColor.clear
            
            // 2.1.设置颜色
            textStorage.addAttribute(NSAttributedString.Key.backgroundColor, value: selectedColor, range: selectedRange!)
            
            // 2.2.绘制背景
            layoutManager.drawBackground(forGlyphRange: selectedRange!, at: CGPoint(x: 0, y: 0))
        }
        
        // 2.绘制字形
        // 需要绘制的范围
        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
}

extension HYLabel {
    /// 准备文本系统
    fileprivate func prepareTextSystem() {
        // 0.准备文本
        prepareText()
        
        // 1.将布局添加到storeage中
        textStorage.addLayoutManager(layoutManager)
        
        // 2.将容器添加到布局中
        layoutManager.addTextContainer(textContainer)
        
        // 3.让label可以和用户交互
        isUserInteractionEnabled = true
        
        // 4.设置间距为0
        textContainer.lineFragmentPadding = 0
    }
    
    /// 准备文本
    fileprivate func prepareText() {
        // 1.准备字符串
        var attrString : NSAttributedString?
        if attributedText != nil {
            attrString = attributedText
        } else if text != nil {
            attrString = NSAttributedString(string: text!)
        } else {
            attrString = NSAttributedString(string: "")
        }
        
        selectedRange = nil
        
        // 2.设置换行模型
        let attrStringM = addLineBreak(attrString!)
        
        attrStringM.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attrStringM.length))
        
        // 3.设置textStorage的内容
        textStorage.setAttributedString(attrStringM)
        
        // 4.匹配URL
        if let linkRanges = getLinkRanges() {
            self.linkRanges = linkRanges
            for range in linkRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor, range: range)
            }
        }
        
        // 5.匹配@用户
        if let userRanges = getRanges("@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*") {
            self.userRanges = userRanges
            for range in userRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor, range: range)
            }
        }
        
        
        // 6.匹配话题##
        if let topicRanges = getRanges("#.*?#") {
            self.topicRanges = topicRanges
            for range in topicRanges {
                textStorage.addAttribute(NSAttributedString.Key.foregroundColor, value: matchTextColor, range: range)
            }
        }
        
        setNeedsDisplay()
    }
}


// MARK:- 字符串匹配封装
extension HYLabel {
    fileprivate func getRanges(_ pattern : String) -> [NSRange]? {
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        return getRangesFromResult(regex)
    }
    
    fileprivate func getLinkRanges() -> [NSRange]? {
        // 创建正则表达式
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        return getRangesFromResult(detector)
    }
    
    fileprivate func getRangesFromResult(_ regex : NSRegularExpression) -> [NSRange] {
        // 1.匹配结果
        let results = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        // 2.遍历结果
        var ranges = [NSRange]()
        for res in results {
            ranges.append(res.range)
        }
        
        return ranges
    }
}


// MARK:- 点击交互的封装
extension HYLabel {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 0.记录点击
        isSelected = true
        
        // 1.获取用户点击的点
        let selectedPoint = touches.first!.location(in: self)
        
        // 2.获取该点所在的字符串的range
        selectedRange = getSelectRange(selectedPoint)
        
        // 3.是否处理了事件
        if selectedRange == nil {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange == nil {
            super.touchesBegan(touches, with: event)
            return
        }
        
        // 0.记录松开
        isSelected = false
        
        // 2.重新绘制
        setNeedsDisplay()
        
        // 3.取出内容
        let contentText = (textStorage.string as NSString).substring(with: selectedRange!)
        
        // 3.回调
        switch tapHandlerType {
        case .linkHandle:
            if linkTapHandler != nil {
                linkTapHandler!(self, contentText, selectedRange!)
            }
        case .topicHandle:
            if topicTapHandler != nil {
                topicTapHandler!(self, contentText, selectedRange!)
            }
        case .userHandle:
            if userTapHandler != nil {
                userTapHandler!(self, contentText, selectedRange!)
            }
        default:
            break
        }
    }
    
    fileprivate func getSelectRange(_ selectedPoint : CGPoint) -> NSRange? {
        // 0.如果属性字符串为nil,则不需要判断
        if textStorage.length == 0 {
            return nil
        }
        
        // 1.获取选中点所在的下标值(index)
        let index = layoutManager.glyphIndex(for: selectedPoint, in: textContainer)
        
        // 2.判断下标在什么内
        // 2.1.判断是否是一个链接
        for linkRange in linkRanges {
            if index > linkRange.location && index < linkRange.location + linkRange.length {
                setNeedsDisplay()
                tapHandlerType = .linkHandle
                return linkRange
            }
        }
        
        // 2.2.判断是否是一个@用户
        for userRange in userRanges {
            if index > userRange.location && index < userRange.location + userRange.length {
                setNeedsDisplay()
                tapHandlerType = .userHandle
                return userRange
            }
        }
        
        // 2.3.判断是否是一个#话题#
        for topicRange in topicRanges {
            if index > topicRange.location && index < topicRange.location + topicRange.length {
                setNeedsDisplay()
                tapHandlerType = .topicHandle
                return topicRange
            }
        }
        
        return nil
    }
}

// MARK:- 补充
extension HYLabel {
    /// 如果用户没有设置lineBreak,则所有内容会绘制到同一行中,因此需要主动设置
    fileprivate func addLineBreak(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = convertFromNSAttributedStringKeyDictionary(attrStringM.attributes(at: 0, effectiveRange: &range))
        var paragraphStyle = attributes[convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle)] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle)] = paragraphStyle
            
            attrStringM.setAttributes(convertToOptionalNSAttributedStringKeyDictionary(attributes), range: range)
        }
        
        return attrStringM
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKeyDictionary(_ input: [NSAttributedString.Key: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
