//
//  NewfeatureViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/11.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
//import SnapKit

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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxImageCount
    }
    
    // 告诉系统当前行显示什么内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! SLCollectionViewCell
        
        cell.index = indexPath.item
        // 以下代码, 主要为了避免重用问题
        cell.startButton.isHidden = true
        return cell
    }
}

// MARK: - UICollectionView代理
extension NewfeatureViewController:UICollectionViewDelegate {
    // 当一个cell完全显示之后就会调用
    // 注意: 该方法传递给我们的是上一页的索引
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // 1.获取当前展现在眼前的cell对应的索引
        let path = collectionView.indexPathsForVisibleItems.last!
        
        // 2.根据索引获取当前展现在眼前cell
        let cell = collectionView.cellForItem(at: path) as! SLCollectionViewCell
        
        // 3.判断是否是最后一页
        if path.item == maxImageCount - 1
        {
            cell.startButton.isHidden = false
            // 禁用按钮交互
            // usingSpringWithDamping 的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显。
            // initialSpringVelocity 则表示初始的速度，数值越大一开始移动越快, 值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
            cell.startButton.isUserInteractionEnabled = false
            cell.startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                cell.startButton.transform = CGAffineTransform.identity
                }, completion: { (_) -> Void in
                    cell.startButton.isUserInteractionEnabled = true
            })
        }
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
    /// 背景大图容器
    fileprivate lazy var iconView = UIImageView()
    /// 进入微博按钮
    fileprivate lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControlState())
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(SLCollectionViewCell.startBtnClick), for: UIControlEvents.touchUpInside)
        btn.sizeToFit()
        return btn
    }()

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
    
    // MARK: - 设置UI界面
    fileprivate func setupUI()
    {
        // 添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 背景大图容器位置
//        iconView.snp_makeConstraints { (make) -> Void in
//            make.edges.equalTo(0)
//        }
//        // 进入微博按钮位置
//        startButton.snp_makeConstraints { (make) -> Void in
//            make.centerX.equalTo(contentView)
//            make.bottom.equalTo(contentView.snp_bottom).offset(-160)
//        }
    }
    
    // MARK: - 处理事件监听
    /**
     点击开始按钮
     */
    @objc fileprivate func startBtnClick()
    {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SLRootViewControllerChange), object: self, userInfo: nil)
    }
    
}

// MARK: - 自定义流水布局
class SLFlowLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepare() {
        super.prepare()
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.isPagingEnabled = true
    }
}

