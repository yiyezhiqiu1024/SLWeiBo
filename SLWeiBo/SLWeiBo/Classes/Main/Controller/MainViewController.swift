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
    // MARK: - 系统回调函数
    //==========================================================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添所有子控制器
        addChildViewControllers()
    }

}

//==========================================================================================================
// MARK: - 自定义函数
//==========================================================================================================

extension MainViewController
{
    /**
     添加所有子控制器
     */
    func addChildViewControllers() {
        // 1.首页
        addChildViewController(HomeTableViewController(), title: "首页", imageNamed: "tabbar_home")
        // 2.消息
        addChildViewController(MessageTableViewController(), title: "消息", imageNamed: "tabbar_message_center")
        // 3.发微博
        addChildViewController(ComposeViewController(), title: nil , imageNamed: "")
        // 4.发现
        addChildViewController(DiscoverTableViewController(), title: "发现", imageNamed: "tabbar_discover")
        // 5.我
        addChildViewController(ProfileTableViewController(), title: "我", imageNamed: "tabbar_profile")
    }
    
    /**
     自定义创建子控制器
     
     - parameter childController: 子控制器
     - parameter title:           标题
     - parameter imageNamed:      图片名
     */
    func addChildViewController(childController: UIViewController, title: String?, imageNamed: String?) {
        
        childController.title = title
        
        guard let name = imageNamed else
        {
            print("图片名不能传nil")
            return
        }
        
        if name != ""
        {
            childController.tabBarItem.image = UIImage(named: name)
            childController.tabBarItem.selectedImage = UIImage(named: name + "_highlighted")
            
        }
        
        let navCtr = UINavigationController(rootViewController: childController)
        addChildViewController(navCtr)
    }
}