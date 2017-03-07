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
        
        // 1.根据JSON文件创建控制器
        // 1.1读取JSON数据
        guard let jsonPath =  NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else
        {
            myLog("获取到对应的文件路径失败, JSON文件不存在")
            return
        }
        
        // 1.2.读取json文件中的内容
        guard let jsonData = NSData(contentsOfFile: jsonPath) else
        {
            myLog("加载二进制数据，获取到json文件中数据失败")
            return
        }
        
        // 1.3将JSON数据转换为对象(数组字典)
        do
        {
            /*
             Swift和OC不太一样, OC中一般情况如果发生错误会给传入的指针赋值, 而在Swift中使用的是异常处理机制
             如果在调用系统某一个方法时,该方法最后有一个throws.说明该方法会抛出异常.如果一个方法会抛出异常,那么需要对该异常进行处理
             在swift中提供三种处理异常的方式
             方式一:try方式 程序员手动捕捉异常
             do {
             try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
             } catch {
             // error异常的对象
             print(error)
             }
             
             方式二:try?方式(常用方式) 系统帮助我们处理异常,如果该方法出现了异常,则该方法返回nil.如果没有异常,则返回对应的对象
             guard let anyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) else {
             return
             }
             
             方式三:try!方法(不建议,非常危险) 直接告诉系统,该方法没有异常.注意:如果该方法出现了异常,那么程序会报错(崩溃)
             let anyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
             */

            let anyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
            
            guard let dictArray = anyObject as? [[String : AnyObject]] else
            {
                return
            }
            
            // 1.4遍历数组字典取出每一个字典
            for dict in dictArray
            {
                // 1.5根据遍历到的字典创建控制器
                let vcName = dict["vcName"] as? String
                let title = dict["title"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName, title: title, imageNamed: imageName)
            }
        }catch
        {
            // 只要try对应的方法发生了异常, 就会执行catch{}中的代码
            // 2.根据字符串创建控制器
            // 2.1首页
            addChildViewController("HomeTableViewController", title: "首页", imageNamed: "tabbar_home")
            // 2.2消息
            addChildViewController("MessageTableViewController", title: "消息", imageNamed: "tabbar_message_center")
            // 2.3发微博
            addChildViewController("ComposeViewController", title: nil , imageNamed: "")
            // 2.4发现
            addChildViewController("DiscoverTableViewController", title: "发现", imageNamed: "tabbar_discover")
            // 2.5我
            addChildViewController("ProfileTableViewController", title: "我", imageNamed: "tabbar_profile")
        }
        
       
    }
    
    
    /**
     使用命名空间创建子控制器
     
     - parameter childControllerName: 子控制器名称
     - parameter title:               标题
     - parameter imageNamed:          图片名称
     */
    private func addChildViewController(childControllerName: String?, title: String?, imageNamed: String?) {
        
        
        
        // 1.动态获取命名空间
        guard let nameSpace =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else
        {
            myLog("获取命名空间失败")
            return
        }
        
        guard let childCtrName = childControllerName else
        {
            myLog("获取子控制器名称失败")
            return
        }
        
        // 2.根据字符串获取对应的Class
        let childVCClass: AnyClass? = NSClassFromString(nameSpace + "." + childCtrName)
        
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