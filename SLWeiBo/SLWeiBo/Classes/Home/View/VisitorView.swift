//
//  VisitorView.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //==========================================================================================================
    // MARK: - 控件的属性
    //==========================================================================================================
    /// 转盘
    @IBOutlet weak var rotationView: UIImageView!
    /// 图标
    @IBOutlet weak var iconView: UIImageView!
    /// 提示标签栏
    @IBOutlet weak var tipLabel: UILabel!
    
    /**
     提供快速通过xib创建的类方法
     */
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
    }

}

//==========================================================================================================
// MARK: - 自定义函数
//==========================================================================================================
extension VisitorView
{
    /**
     设置访客视图上的数据
     
     - parameter iconName: 需要显示的图标
     - parameter title:    需要显示提示标签栏
     */
    func setupVisitorViewInfo(iconName : String?, title : String) {
        // 1.设置标题
        tipLabel.text = title
        
        // 2.判断是否是首页
        guard let name = iconName else
        {
            // 没有设置图标, 首页
            // 执行转盘动画
            addRotationAnimation()
            
            return
        }
        
        // 3.设置其他数据
        // 不是首页
        rotationView.hidden = true
        
        iconView.image = UIImage(named: name)
    }
    
    private func addRotationAnimation() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        
        // 注意: 默认情况下只要视图消失, 系统就会自动移除动画
        // 只要设置removedOnCompletion为false, 系统就不会移除动画
        rotationAnim.removedOnCompletion = false
        
        // 3.将动画添加到layer中
        rotationView.layer.addAnimation(rotationAnim, forKey: nil)
    }

}