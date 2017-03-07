//
//  QRCodeViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    // MARK: - 控件属性
    /// 底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 容器视图高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置默认选中
        customTabbar.selectedItem = customTabbar.items?.first
        
        // 2.添加监听, 监听底部工具条点击
        customTabbar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 开启冲击波动画
        startAnimation()
    }
    
}

// MARK: - 监听事件处理
extension QRCodeViewController
{
    @IBAction func photoBtnClick(sender: AnyObject) {
    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - 设置UI界面
extension QRCodeViewController
{
    /// 开启冲击波动画
    private func startAnimation()
    {
        // 1.设置冲击波底部和容器视图顶部对齐
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        // 2.执行扫描动画
        UIView.animateWithDuration(2.0) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }
        
    }
}

// MARK: - UITabBar代理
extension QRCodeViewController: UITabBarDelegate
{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //        myLog(item.tag)
        // 根据当前选中的按钮重新设置二维码容器高度
        containerHeightCons.constant = (item.tag == 1) ? 150 : 300
        view.layoutIfNeeded()
        
        // 移除动画
        scanLineView.layer.removeAllAnimations()
        
        // 重新开启动画
        startAnimation()
    }
}