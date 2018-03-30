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
    /// 微博来源
    var source : String?
    /// 微博的正文
    var text : String?
    /// 微博的ID
    var mid : Int = 0
    /// 微博的用户
    var user : User?
    /// 微博的配图
    var pic_urls : [[String : String]]?
    /// 微博对应的转发的微博
    var retweeted_status : Status?
    
    
    // MARK:- 自定义构造函数
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : Any] {
            user = User(dict: userDict)
        }
        
        // 2.将转发微博字典转成转发微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : Any] {
            retweeted_status = Status(dict: retweetedStatusDict)
        }

    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
