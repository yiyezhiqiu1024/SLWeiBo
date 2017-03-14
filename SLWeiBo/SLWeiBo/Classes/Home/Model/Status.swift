//
//  Status.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/13.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    /// 微博创建时间
    var created_at : String?
    {
        didSet {
            // 1.nil值校验
            guard let created_at = created_at else {
                return
            }
            
            // 2.对时间处理
            createAtText = NSDate.createDateString(created_at)
        }

    }
    /// 微博来源
    var source : String?
    {
        didSet {
            // 1.nil值校验
            guard let source = source where source != "" else {
                return
            }
            
            // 2.对来源的字符串进行处理
            // 2.1.获取起始位置和截取的长度
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            // 2.2.截取字符串
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
    }
    
    /// 微博的正文
    var text : String?
    /// 微博的ID
    var mid : Int = 0
    
    // MARK:- 对数据处理的属性
    /// 处理过的微博来源
    var sourceText : String?
    /// 处理过的微博创建时间
    var createAtText : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
