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
        
        // 2.添加登录后的导航条按钮
        /*
         let leftBtn = UIButton()
         leftBtn.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
         leftBtn.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: UIControlState.Highlighted)
         leftBtn.sizeToFit()
         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
         
         let rigthBtn = UIButton()
         rigthBtn.setImage(UIImage(named: "navigationbar_pop"), forState: UIControlState.Normal)
         rigthBtn.setImage(UIImage(named: "navigationbar_pop_highlighted"), forState: UIControlState.Highlighted)
         rigthBtn.sizeToFit()
         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rigthBtn)
         */
        /*
         navigationItem.leftBarButtonItem = createBarButtonItem("navigationbar_friendattention")
         navigationItem.rightBarButtonItem = createBarButtonItem("navigationbar_pop")
         */
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
    }
    
    
    /*
     /// 创建UIBarButtonItem
     private func createBarButtonItem(imageName: String) -> UIBarButtonItem
     {
     let btn = UIButton()
     btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
     btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
     btn.sizeToFit()
     return UIBarButtonItem(customView: btn)
     }
     */

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
}
