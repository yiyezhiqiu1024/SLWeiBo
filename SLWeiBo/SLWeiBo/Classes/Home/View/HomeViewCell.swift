//
//  HomeViewCell.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {
    
    // MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
    
}
