//
//  UserAccount.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/10.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    // MARK:- 属性
    /// 授权AccessToken
    var access_token : String?
    /// 过期时间-->秒
    var expires_in : NSTimeInterval = 0.0 {
        didSet
        {
           expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    var expires_date : NSDate?
    /// 用户ID
    var uid : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK:- 重写description属性
    override var description : String {
        let propertyKeys = ["access_token", "expires_date", "uid"]
        return dictionaryWithValuesForKeys(propertyKeys).description
    }
}