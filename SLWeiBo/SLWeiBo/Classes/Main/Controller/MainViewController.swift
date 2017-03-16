//
//  MainViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    //==========================================================================================================
    // MARK: - 懒加载属性
    //==========================================================================================================
    /// 发微博按钮
    private lazy var composeButton: UIButton = UIButton(imageName:"tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")

    //==========================================================================================================
    // MARK: - 系统回调函数
    //==========================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置发微博按钮
        setupComposeButton()
    }
}

//==========================================================================================================
// MARK: - 自定义函数
//==========================================================================================================
extension MainViewController
{
    /**
     设置发微博按钮
     */
    func setupComposeButton()
    {
        // 1.添加按钮
        tabBar.addSubview(composeButton)
        
        // 2.设置按钮的位置
        composeButton.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
        // 3.监听按钮点击
        composeButton.addTarget(self, action: #selector(MainViewController.composeBtnClick(_:)), forControlEvents:.TouchUpInside)
    }
    
}

//==========================================================================================================
// MARK: - 监听事件处理
//==========================================================================================================
extension MainViewController
{
    /**
     点击发布微博按钮
     
     - parameter btn: 发布按钮
     */
    @objc private func composeBtnClick(btn: UIButton)
    {
        // 1.创建发布控制器
        guard let composeVC = UIStoryboard(name: "Compose", bundle: nil).instantiateInitialViewController() else
        {
            myLog("获取发布控制器失败")
            return
        }
        // 2.包装导航控制器
        let composeNav = UINavigationController(rootViewController: composeVC)
        
        // 3.弹出控制器
        presentViewController(composeNav, animated: true, completion: nil)
    }
}