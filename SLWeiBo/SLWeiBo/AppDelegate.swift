//
//  AppDelegate.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - 系统回调函数
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /// 设置全局外观
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        // 2.注册通知, 监听根控制器的改变
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.switchRootViewController(_:)), name: NSNotification.Name(rawValue: SLRootViewControllerChange), object: nil)
        
        // 3.创建keywindow
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - 自定义函数
extension AppDelegate
{
    /// 检查是否有新版本
    fileprivate func isNewVersion() -> Bool
    {
        // 1.从info.plist中获取当前软件的版本号  2.0
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        // 2.从沙盒中获取以前的软件版本号   1.0
        let userDefaults = UserDefaults.standard
        let sanboxVersion = (userDefaults.object(forKey: "CFBundleShortVersionString") as? String) ?? "0.0"
        // 3.利用"当前的"和"沙盒的"进行比较
        // 如果当前的 > 沙盒的, 有新版本
        // 1.0 0.0
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending
        {
            // 有新版本
            // 4.存储当前的软件版本号到沙盒中 1.0
            userDefaults.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        // 5.返回结果 true false
        return false
    }
    
    /// 根据一个Storyboard的名称创建一个控制器
    fileprivate func createViewController(_ viewControllerName: String) -> UIViewController
    {
        let sb = UIStoryboard(name: viewControllerName, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /// 返回默认控制器
    fileprivate func defaultViewController() -> UIViewController
    {
        
        if UserAccountViewModel.shareIntance.isLogin
        {
            return isNewVersion() ? createViewController("Newfeature") : WelcomeViewController()
        }
        
        return createViewController("Main")
    }
    
    /// 切换根控制器器
    @objc fileprivate func switchRootViewController(_ notify: Notification)
    {
        if let _ = notify.userInfo
        {
            // 切换到欢迎界面
            window?.rootViewController = WelcomeViewController()
            return
        }
        
        // 切换到首页
        window?.rootViewController = createViewController("Main")
    }

}

/**
 自定义打印函数
 
 - parameter message:    给外界提供的消息参数
 - parameter fileName:   文件名
 - parameter methodName: 函数名
 - parameter lineNumber: 行号
 */
func myLog<T>(_ message: T, fileName: String = #file, funcName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\((fileName as NSString).lastPathComponent) [\(lineNumber)] \(funcName):\(message)")
    #endif
}
