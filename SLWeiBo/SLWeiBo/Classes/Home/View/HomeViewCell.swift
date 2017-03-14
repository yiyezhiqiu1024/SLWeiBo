//
//  HomeViewCell.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    // MARK:- 控件属性
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 认证图标
    @IBOutlet weak var verifiedView: UIImageView!
    
    /// 昵称
    @IBOutlet weak var screenNameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var vipView: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 配图
    @IBOutlet weak var picView: PicCollectionView!
    
    // MARK:- 约束的属性
    /// 正文的宽度约束
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    /// 配图的宽度约束
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    /// 配图的高度约束
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // 2.设置头像
            iconView.sd_setImageWithURL(viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            // 4.昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            // 4.1设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.blackColor() : UIColor.orangeColor()
            
            // 5.会员图标
            vipView.image = viewModel.vipImage
            
            // 6.设置时间的Label
            timeLabel.text = viewModel.createAtText
            
            // 7.设置来源
            guard let source = viewModel.sourceText else
            {
                return
            }
            sourceLabel.text = "来自" + source
            
            // 8.设置正文
            contentLabel.text = viewModel.status?.text
            
            // 9.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height

            // 10.将picURL数据传递给picView
            picView.picURLs = viewModel.picURLs
        }
    }

    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
    }
    
}

// MARK:- 计算方法
extension HomeViewCell {
    private func calculatePicViewSize(count : Int) -> CGSize {
        // 1.没有配图
        if count == 0 {
            return CGSizeZero
        }
        
        // 2.取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 3.单张配图
        if count == 1 {
            // 1.取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            guard let image = SDWebImageManager.sharedManager().imageCache?.imageFromDiskCacheForKey(urlString) else
            {
                return CGSizeZero
            }
            
            // 2.设置一张图片是layout的itemSize
            layout.itemSize = CGSize(width: image.size.width, height: image.size.height)
            
            return CGSize(width: image.size.width, height: image.size.height)
        }
        
        // 4.计算出来imageViewWH
        let imageViewWH = (UIScreen.mainScreen().bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 5.设置其他张图片时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 7.其他张配图
        // 7.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 7.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 7.3.计算picView的宽度
        let picViewW = UIScreen.mainScreen().bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
