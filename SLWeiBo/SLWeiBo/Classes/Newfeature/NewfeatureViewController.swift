//
//  NewfeatureViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/11.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class NewfeatureViewController: UIViewController {
    // MARK: - 自定义属性
    /// 新特性界面总数
    let maxImageCount = 4
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

// MARK: - 数据源函数
extension NewfeatureViewController: UICollectionViewDataSource {
    // 告诉系统当前组有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxImageCount
    }
    
    // 告诉系统当前行显示什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newfeatureCell", forIndexPath: indexPath) as! SLCollectionViewCell
        
        cell.index = indexPath.item
        
        return cell
    }
}

// 注意: Swift中一个文件中是可以定义多个类
// MARK: - 自定义Cell
class SLCollectionViewCell: UICollectionViewCell {
    
    // MARK: - 自定义属性
    /// 保存图片索引
    var index: Int = 0
        {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(index + 1)")
        }
    }
    
    // MARK: - 懒加载
    /// 大图容器
    private lazy var iconView = UIImageView()

    // MARK: - 重写系统初始化函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 初始化UI
        setupUI()
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 添加子控件
        contentView.addSubview(iconView)
        
        // 布局子控件
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView": iconView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView": iconView])
        contentView.addConstraints(cons)
    }
    
}

// MARK: - 自定义流水布局
class SLFlowLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepareLayout() {
        super.prepareLayout()
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
}

