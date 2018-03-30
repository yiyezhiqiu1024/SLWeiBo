//
//  HomeViewCell.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/14.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage
//import HYLabel

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
    /// 转发微博的正文
    @IBOutlet weak var retweetedContentLabel: UILabel!
    /// 配图
    @IBOutlet weak var picView: PicCollectionView!
    /// 转发微博的背景
    @IBOutlet weak var retweetedBgView: UIView!
    /// 底部工具条
    @IBOutlet weak var bottomToolView: UIView!
    
    // MARK:- 约束的属性
    /// 正文的宽度约束
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    /// 配图的宽度约束
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    /// 配图的高度约束
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    /// 配图底部约束
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    /// 转发微博正文顶部约束
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            
            // 2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            // 4.昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            // 4.1设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            // 5.会员图标
            vipView.image = viewModel.vipImage
            
            // 6.设置时间的Label
            timeLabel.text = viewModel.createAtText
            
            // 7.设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
                        
            // 8.设置正文
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(viewModel.status?.text, font: contentLabel.font)
            
            // 9.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height

            // 10.将picURL数据传递给picView
            picView.picURLs = viewModel.picURLs
            
            // 11.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                // 1.设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName) :" + retweetedText
                    
                    // 2.设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                
                // 3.设置背景显示
                retweetedBgView.isHidden = false
            } else {
                // 1.设置转发微博的正文
                retweetedContentLabel.text = nil
                
                // 2.设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
                
                // 3.设置背景显示
                retweetedBgView.isHidden = true
            }
            
            // 12.计算cell的高度
            if viewModel.cellHeight == 0 {
                // 12.1.强制布局
                layoutIfNeeded()
                
                // 12.2.获取底部工具栏的最大Y值
                viewModel.cellHeight = bottomToolView.frame.maxY
            }
        }
    }

    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
//        setupHYLabel()
    }
    
}

// MARK:- 计算方法
extension HomeViewCell {
    
    /*
    fileprivate func setupHYLabel() {
        // 设置HYLabel的内容
        let customColor = UIColor(red: 0 / 255.0, green: 160 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        
        contentLabel.matchTextColor = customColor
        retweetedContentLabel.matchTextColor = customColor
        
        // 监听HYlabel内容的点击
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            myLog(user)
            myLog(range)
        }
        
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            myLog(link)
            myLog(range)
        }
        
        // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            myLog(topic)
            myLog(range)
        }
    }
    */
    
    fileprivate func calculatePicViewSize(_ count : Int) -> CGSize {
        // 1.没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        // 有配图需要改约束有值
        picViewBottomCons.constant = 10
        
        // 2.取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // 3.单张配图
        if count == 1 {
            // 1.取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            guard let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString) else
            {
                return CGSize.zero
            }
            
            // 2.设置一张图片是layout的itemSize
            layout.itemSize = CGSize(width: image.size.width, height: image.size.height)
            
            return CGSize(width: image.size.width, height: image.size.height)
        }
        
        // 4.计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 5.设置其他张图片时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 7.其他张配图
        // 7.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 7.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        
        // 7.3.计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
