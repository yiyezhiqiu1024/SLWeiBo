//
//  OAuthViewController.swift
//  DS11WB
//
//  Created by xiaomage on 16/4/6.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://github.com/CoderSLZeng/SLWeiBo")!))
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

