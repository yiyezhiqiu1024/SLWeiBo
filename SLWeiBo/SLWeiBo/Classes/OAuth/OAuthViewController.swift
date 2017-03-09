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
        print("fillItemClick")
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
}
