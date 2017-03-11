//
//  BaseTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // MARK: - 懒加载属性
    /// 访客视图
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    
    // MARK: - 自定义变量
    /// 定义标记记录用户登录状态
    var isLogin : Bool = false
    
    // MARK: - 系统回调函数
    
    override func loadView() {
        
        // 1.从沙盒中读取中归档的信息
        // 1.1.获取沙盒路径
        var accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        accountPath = (accountPath as NSString).stringByAppendingPathComponent("accout.plist")
        
        // 1.2.读取信息
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? UserAccount
        if let account = account {
            
            // 1.3.取出过期日期 : 当前日期
            if let expiresDate = account.expires_date {
                isLogin = expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
            }
        }
        
        // 判断用户是否登录, 如果没有登录就显示访客界面, 如果已经登录就显示tableview
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}


// MARK: - 设置UI界面
extension BaseTableViewController {
    
    /**
     设置访客视图
     */
    private func setupVisitorView() {
        view = visitorView
        // 监听访客视图中`注册`和`登录`按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), forControlEvents: .TouchUpInside)
    }
    
    /// 设置导航栏左右的Item
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
}


// MARK: - 监听事件处理
extension BaseTableViewController {
    /**
     点击注册按钮
     */
    @objc private func registerBtnClick() {
        myLog("registerBtnClick")
    }
    
    /**
     点击登录按钮
     */
    @objc private func loginBtnClick() {
        // 1.创建授权控制器
        let oauthVc = OAuthViewController()
        
        // 2.包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出控制器
        presentViewController(oauthNav, animated: true, completion: nil)
    }
}

