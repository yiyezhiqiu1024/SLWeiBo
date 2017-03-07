//
//  HomeTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    //==========================================================================================================
    // MARK: - 懒加载属性
    //==========================================================================================================
    private lazy var titleBtn : TitleButton = TitleButton()

    //==========================================================================================================
    // MARK: - 系统回调函数
    //==========================================================================================================

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断用户是否登录
        if !isLogin
        {
            // 设置访客视图
            visitorView.setupVisitorViewInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.设置导航条
        setupNavigationBar()
        
    }
    
}

//==========================================================================================================
// MARK: - 设置UI界面
//==========================================================================================================
extension HomeTableViewController
{
    /**
     设置导航条
     */
    func setupNavigationBar()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        // 2.添加标题按钮
        titleBtn.setTitle("CoderSLZeng", forState: .Normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
}

//==========================================================================================================
// MARK: - 监听事件处理
//==========================================================================================================
extension HomeTableViewController
{
    @objc private func leftBtnClick()
    {
        myLog("")
    }
    @objc private func rightBtnClick()
    {
        myLog("")
    }
    
    @objc private func titleBtnClick(button: TitleButton)
    {
        titleBtn.selected = !titleBtn.selected
    }
}
