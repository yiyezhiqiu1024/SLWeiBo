//
//  UIButton+Extension.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

extension UIButton
{
    // convenience : 便利,使用convenience修饰的构造函数叫做便利构造函数
    // 遍历构造函数通常用在对系统的类进行构造函数的扩充时使用
    /*
     遍历构造函数的特点
     1.遍历构造函数通常都是写在extension里面
     2.遍历构造函数init前面需要加载convenience
     3.在遍历构造函数中需要明确的调用self.init()
     */
    convenience init(imageName: String, backgroundImageName: String)
    {
        
        self.init()
        
        if imageName != "" {
            // 1.设置前景图片
            setImage(UIImage(named: imageName), for: UIControl.State())
            setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        if backgroundImageName != "" {
            // 2.设置背景图片
            setBackgroundImage(UIImage(named: backgroundImageName), for: UIControl.State())
            setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: .highlighted)
        }
        
        
        // 3.调整按钮尺寸
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        
        setTitle(title, for: UIControl.State())
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
