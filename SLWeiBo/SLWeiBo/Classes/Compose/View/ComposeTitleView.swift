//
//  ComposeTitleView.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/16.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
//import SnapKit

class ComposeTitleView: UIView {
    // MARK:- 懒加载属性
    fileprivate lazy var titleLabel : UILabel = UILabel()
    fileprivate lazy var screenNameLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension ComposeTitleView {
    fileprivate func setupUI() {
        // 1.将子控件添加到view中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        // 2.设置frame
//        titleLabel.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(self)
//            make.top.equalTo(self)
//        }
//        screenNameLabel.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(titleLabel.snp_centerX)
//            make.top.equalTo(titleLabel.snp_bottom).offset(3)
//        }
        
        // 3.设置空间的属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        // 4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    }
}
