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
    private lazy var composeButton: UIButton = {
        () -> UIButton
        in
        // 1.创建按钮
        let btn = UIButton()
        // 2.设置前景图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        // 3.设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        // 4.监听按钮点击
        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        // 4.调整按钮尺寸
        btn.sizeToFit()
        
        return btn
    }()

    //==========================================================================================================
    // MARK: - 系统回调函数
    //==========================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添所有子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        
        // 保存按钮尺寸
        let rect = composeButton.frame
        // 计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        // 设置按钮的位置
//        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
        composeButton.frame = CGRectOffset(rect, 2 * width, 0)
        
    }
    
}

//==========================================================================================================
// MARK: - 监听事件处理
//==========================================================================================================
extension MainViewController
{
    /*
     public : 最大权限, 可以在当前framework和其他framework中访问
     internal : 默认的权限, 可以在当前framework中随意访问
     private : 私有权限, 只能在当前文件中访问
     以上权限可以修饰属性/方法/类
     
     在企业开发中建议严格的控制权限, 不想让别人访问的东西一定要private
     */
    // 如果给按钮的监听方法加上private就会报错, 报错原因是因为监听事件是由运行循环触发的, 而如果该方法是私有的只能在当前类中访问
    // 而相同的情况在OC中是没有问题, 因为OC是动态派发的
    // 而Swift不一样, Swift中所有的东西都在是编译时确定的
    // 如果想让Swift中的方法也支持动态派发, 可以在方法前面加上 @objc
    // 加上 @objc就代表告诉系统需要动态派发
    /**
     点击发微博按钮
     
     - parameter btn: 发按钮
     */
    @objc private func composeBtnClick(btn: UIButton)
    {
        myLog(btn)
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
    private func addChildViewControllers() {
        
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