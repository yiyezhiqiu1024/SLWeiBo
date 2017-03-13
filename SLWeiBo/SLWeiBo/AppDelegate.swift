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

    var defaultViewController : UIViewController? {
        let isLogin = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /// 设置全局外观
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
        
        myLog(isNewVersion())
        
        return true
    }
    
    /// 检查是否有新版本
    private func isNewVersion() -> Bool
    {
        // 1.从info.plist中获取当前软件的版本号  2.0
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // 2.从沙盒中获取以前的软件版本号   1.0
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sanboxVersion = (userDefaults.objectForKey("CFBundleShortVersionString") as? String) ?? "0.0"
        
        // 3.利用"当前的"和"沙盒的"进行比较
        // 如果当前的 > 沙盒的, 有新版本
        // 1.0 0.0
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 有新版本
            // 4.存储当前的软件版本号到沙盒中 1.0
            userDefaults.setObject(currentVersion, forKey: "CFBundleShortVersionString")
            userDefaults.synchronize() // iOS7以前需要这样做, iOS7以后不需要了
            return true
        }
        
        // 5.返回结果 true false
        return false
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/**
 自定义打印函数
 
 - parameter message:    给外界提供的消息参数
 - parameter fileName:   文件名
 - parameter methodName: 函数名
 - parameter lineNumber: 行号
 */
func myLog<T>(message: T, fileName: String = #file, funcName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\((fileName as NSString).lastPathComponent) [\(lineNumber)] \(funcName):\(message)")
    #endif
}
