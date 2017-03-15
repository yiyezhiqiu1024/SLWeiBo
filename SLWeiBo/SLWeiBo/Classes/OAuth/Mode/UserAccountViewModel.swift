//
//  UserAccountViewModel.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/11.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    
    // MARK:- 将类设计成单例
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    // MARK:- 定义属性
    /// 账户
    var account : UserAccount?
    
    // MARK:- 计算属性
    /// 获取沙盒路径
    var accountPath : String {
        return "accout.plist".docDir()
    }
    
    /// 是否已经登录
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        // 取出过期日期 : 当前日期
        guard let expiresDate = account?.expires_date else {
            return false
        }
        // 降序比较，判断是否过期，过期 = 未登录，没过期 = 已登录
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    
    // MARK:- 重写init()函数
    init () {
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
    }
}
