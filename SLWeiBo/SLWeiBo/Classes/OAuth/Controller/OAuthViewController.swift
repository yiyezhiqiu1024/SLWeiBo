//
//  OAuthViewController.swift
//  DS11WB
//
//  Created by Anthony on 17/3/10.
//  Copyright © 2017年 SLZeng. All rights reserved.
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
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    /**
     加载网页
     */
    fileprivate func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"
        
        // 2.创建对应NSURL
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = URLRequest(url: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听处理
extension OAuthViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='\(WB_APP_UserId)';document.getElementById('passwd').value='\(WB_APP_Passwd)';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)

    }
}

// MARK: - UIWebView代理
extension OAuthViewController: UIWebViewDelegate
{
    /// webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
            SVProgressHUD.showInfo(withStatus: "正在拼命加载网页...")
            SVProgressHUD.setDefaultMaskType(.black)
    }
    
    /// webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        
    }
    
    /// webView加载网页失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        // 1.获取加载网页的NSURL
        guard let url = request.url else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString as NSString
        
        
        // 3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        
        // 4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        
        // 5.加载accessToken
        loadAccessToken(code)
        
        return false
    }
}


// MARK:- 请求数据
extension OAuthViewController {
    /// 加载AccessToken
    fileprivate func loadAccessToken(_ code : String) {
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
    fileprivate func loadUserInfo(_ account : UserAccount) {
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
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath)
            
            // 5.将account对象设置到单例对象中
            UserAccountViewModel.shareIntance.account = account
            
            // 6.退出当前控制器
            self.dismiss(animated: true, completion: { () -> Void in
                 NotificationCenter.default.post(name: Notification.Name(rawValue: SLRootViewControllerChange), object: self, userInfo: ["message": true])
            })

        }
    }
}

