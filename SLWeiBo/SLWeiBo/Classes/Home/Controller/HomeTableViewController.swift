//
//  HomeTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewController: BaseTableViewController {
    
    // MARK: - 懒加载属性
    /// 标题按钮
    private lazy var titleBtn : TitleButton = TitleButton()
    /*
      注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
      两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
     */
    /// 转场动画
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self] (presented) in
        self?.titleBtn.selected = presented
    }
    
    /// 微博视图模型
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()

    
    // MARK: - 系统回调函数
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断用户是否登录
        if !isLogin
        {
            // 设置访客视图
            visitorView.setupVisitorViewInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.设置导航条
        setupNavigationBar()
        
        // 3.请求数据
        loadStatuses()
        
        // 4.设置预估高度值
        tableView.estimatedRowHeight = 200
        
    }
    
}

// MARK: - 设置UI界面
extension HomeTableViewController
{
    /**
     设置导航条
     */
    func setupNavigationBar()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        // 2.添加标题按钮
        titleBtn.setTitle("CoderSLZeng", forState: .Normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK: - 监听事件处理
extension HomeTableViewController
{
    @objc private func leftBtnClick()
    {
        myLog("")
    }
    @objc private func rightBtnClick()
    {
        // 1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.弹出二维码控制器
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @objc private func titleBtnClick(button: TitleButton)
    {
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 2.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        // 4.设置展示出来的尺寸
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        // 5.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

// MARK:- 请求数据
extension HomeTableViewController {
    /// 加载微博数据
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                myLog(error)
                return
            }
            
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            
            // 3.遍历微博对应的字典
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
            }
            
            // 4.缓存图片
            self.cacheImages(self.viewModels)
        }
    }
    
    /**
     缓存图片
     */
    private func cacheImages(viewModels : [StatusViewModel]) {
        // 0.创建group
        let group = dispatch_group_create()
        
        // 1.缓存图片
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs {
                dispatch_group_enter(group)
              SDWebImageManager.sharedManager().loadImageWithURL(picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                SDWebImageManager.sharedManager()
                dispatch_group_leave(group)
            })
            }
        }
        
        // 2.刷新表格
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
    }
}



// MARK:- tableView的数据源方法
extension HomeTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell") as! HomeViewCell
        
        // 2.给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
                
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.获取模型对象
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}