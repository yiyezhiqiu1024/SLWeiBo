//
//  UIBarButtonItem+Extension.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 1.用于快速创建一个对象
    // 2.依赖于指定构造方法
    /**
     初始化一个UIBarButtonItem
     
     - parameter imageName: 图标名称
     - parameter target:    监听对象
     - parameter action:    监听行为
     */
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControl.State())
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        
        self.init(customView: btn)
    }
}
