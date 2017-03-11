//
//  OAuthViewController.swift
//  DS11WB
//
//  Created by xiaomage on 16/4/6.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
        loadPage()
    }
    
}


// MARK:- 设置UI界面
extension OAuthViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    /**
     加载网页
     */
    private func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"
        
        // 2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听处理
extension OAuthViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='\(WB_APP_UserId)';document.getElementById('passwd').value='\(WB_APP_Passwd)';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)

    }
}

// MARK: - UIWebView代理
extension OAuthViewController: UIWebViewDelegate
{
    /// webView开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
            SVProgressHUD.showInfoWithStatus("正在拼命加载网页...")
            SVProgressHUD.setDefaultMaskType(.Black)
    }
    
    /// webView网页加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        
    }
    
    /// webView加载网页失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 1.获取加载网页的NSURL
        guard let url = request.URL else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        
        // 3.判断该字符串中是否包含code
        guard urlString.containsString("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.componentsSeparatedByString("code=").last!
        
        // 5.加载accessToken
        loadAccessToken(code)
        
        return false
    }
}


// MARK:- 请求数据
extension OAuthViewController {
    /// 加载AccessToken
    private func loadAccessToken(code : String) {
        NetworkTools.shareInstance.loadAccessToken(code) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                myLog(error)
                return
            }
            
            // 2.拿到结果
            guard let accountDict = result else {
                myLog("没有获取授权后的数据")
                return
            }
            
            // 3.将字典转成模型对象
            let account = UserAccount(dict: accountDict)
            
            // 4.请求用户信息
            self.loadUserInfo(account)
        }
    }
    
    
    /// 请求用户信息
    private func loadUserInfo(account : UserAccount) {
        // 1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        
        // 2.获取uid
        guard let uid = account.uid else {
            return
        }
        
        // 3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                myLog(error)
                return
            }
            
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将account对象保存
            // 4.1.获取沙盒路径
            let accountPath = "accout.plist".docDir()
            myLog(accountPath)
            
            // 4.2.保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
        }
    }
}

