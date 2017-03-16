//
//  ComposeViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // MARK:- 控件属性
    @IBOutlet weak var textView: ComposeTextView!
    
    // MARK:- 懒加载属性
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏
        setupNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
}


// MARK:- 设置UI界面
extension ComposeViewController {
    private func setupNavigationBar() {
        // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
}


// MARK:- 事件监听函数
extension ComposeViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        myLog("sendItemClick")
    }
}

// MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
