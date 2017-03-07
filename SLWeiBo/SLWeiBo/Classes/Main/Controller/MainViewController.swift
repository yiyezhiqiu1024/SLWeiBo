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
        addChildViewController("HomeTableViewController", title: "首页", imageNamed: "tabbar_home")
        // 2.消息
        addChildViewController("MessageTableViewController", title: "消息", imageNamed: "tabbar_message_center")
        // 3.发微博
        addChildViewController("ComposeViewController", title: nil , imageNamed: "")
        // 4.发现
        addChildViewController("DiscoverTableViewController", title: "发现", imageNamed: "tabbar_discover")
        // 5.我
        addChildViewController("ProfileTableViewController", title: "我", imageNamed: "tabbar_profile")
    }
    
    
    /**
     使用命名空间创建子控制器
     
     - parameter childControllerName: 子控制器名称
     - parameter title:               标题
     - parameter imageNamed:          图片名称
     */
    private func addChildViewController(childControllerName: String?, title: String?, imageNamed: String?) {
        
        /*
         guard 条件表达式 else {
         //            需要执行的语句
         //            只有条件为假才会执行{}中的内容
         return
         }
         guard可以有效的解决可选绑定容易形成{}嵌套问题
         */
        
        // 1.动态获取命名空间
        // 由于字典/数组中只能存储对象, 所以通过一个key从字典中获取值取出来是一个AnyObject类型, 并且如果key写错或者没有对应的值, 那么就取不到值, 所以返回值可能有值也可能没值, 所以最终的类型是AnyObject?
        guard let nameSpace =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else
        {
            myLog("获取命名空间失败")
            return
        }
        
        /*
         Swift中新增了一个叫做命名空间的概念
         作用: 避免重复
         不用项目中的命名空间是不一样的, 默认情况下命名空间的名称就是当前项目的名称
         正是因为Swift可以通过命名空间来解决重名的问题, 所以在做Swift开发时尽量使用cocoapods来集成三方框架, 这样可以有效的避免类名重复
         正是因为Swift中有命名空间, 所以通过一个字符串来创建一个类和OC中也不太一样了, OC中可以直接通过类名创建一个类, 而Swift中如果想通过类名来创建一个类必须加上命名空间
         */
        
        guard let childCtrName = childControllerName else
        {
            myLog("获取子控制器名称失败")
            return
        }
        
        // 2.根据字符串获取对应的Class
        let childVCClass: AnyClass? = NSClassFromString(nameSpace + "." + childCtrName)
        
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        // 3.将对应的AnyObject转成控制器的类型
        guard let childVCType = childVCClass as? UIViewController.Type else
        {
            myLog("获取对应控制器的类型")
            return
        }
        
        // 4.通过Class创建对象
        let childCtr = childVCType.init()
        
        // 5.设置子控制器的属性
        childCtr.title = title
        
        guard let name = imageNamed else
        {
            myLog("图片名不能传nil")
            return
        }
        
        if name != ""
        {
            childCtr.tabBarItem.image = UIImage(named: name)
            childCtr.tabBarItem.selectedImage = UIImage(named: name + "_highlighted")
            
        }
        
        // 6.包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childCtr)
        addChildViewController(childNav)

    }
}