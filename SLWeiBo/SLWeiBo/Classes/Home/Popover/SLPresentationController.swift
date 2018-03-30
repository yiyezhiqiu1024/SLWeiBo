//
//  SLPresentationController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class SLPresentationController: UIPresentationController {
    // MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRect.zero
    
    // MARK: - 懒加载属性
    fileprivate lazy var coverView : UIView = UIView()
    
    // MARK: - 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 1.设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        
        // 2.添加蒙版
        setupCoverView()
    }
}

// MARK: - 设置UI界面相关
extension SLPresentationController {
    fileprivate func setupCoverView() {
        // 1.添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        
        // 2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(SLPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

// MARK: - 事件监听
extension SLPresentationController {
    @objc fileprivate func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
