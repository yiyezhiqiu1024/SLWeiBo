//
//  TitleButton.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    //    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
    //        return CGRectZero
    //    }
    //    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
    //        return CGRectZero
    //    }
    
    // 通过纯代码创建时调用
    // 在Swift中如果重写父类的方法, 必须在方法前面加上override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // 通过XIB/SB创建时调用
    required init?(coder aDecoder: NSCoder) {
        // 系统对initWithCoder的默认实现是报一个致命错误
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    fileprivate func setupUI()
    {
        setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControl.State())
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControl.State.selected)
        
        setTitleColor(UIColor.darkGray, for: UIControl.State())
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        // ?? 用于判断前面的参数是否是nil, 如果是nil就返回??后面的数据, 如果不是nil那么??后面的语句不执行
        super.setTitle((title ?? "") + "  ", for: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*
         // offsetInPlace 方法用于设置控件的偏移位
         titleLabel?.frame.offsetInPlace(dx: -imageView!.frame.width * 0.5, dy: 0)
         imageView?.frame.offsetInPlace(dx: titleLabel!.frame.width * 0.5, dy: 0)
         */
        
        // 和OC不太一样, Swift语法允许我们直接修改一个对象的结构体属性的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
    }

}
