//
//  StatusViewModel.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class StatusViewModel {
    // MARK:- 定义属性
    var status : Status?
    
    // MARK:- 对数据处理的属性
    /// 处理过的微博来源
    var sourceText : String?
    /// 处理过的微博创建时间
    var createAtText : String?
    /// 处理过的用户认证图标
    var verifiedImage : UIImage?
    /// 处理过的用户会员图标
    var vipImage : UIImage?
    
    // MARK:- 自定义构造函数
    init(status : Status) {
        self.status = status
        
        // 1.对来源处理
        if let source = status.source where source != "" {
            // 1.1.获取起始位置和截取的长度
            let startIndex = (source as NSString).rangeOfString(">").location + 1
            let length = (source as NSString).rangeOfString("</").location - startIndex
            
            // 1.2.截取字符串
            sourceText = (source as NSString).substringWithRange(NSRange(location: startIndex, length: length))
        }
        
        // 2.处理时间
        if let createAt = status.created_at {
            createAtText = NSDate.createDateString(createAt)
        }
        
        // 3.处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4.处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
    }

}