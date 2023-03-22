//
//  HomeTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeTableViewController: BaseTableViewController {
    
    // MARK: - 懒加载属性
    /// 标题按钮
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    /*
      注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
      两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
     */
    /// 转场动画
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator { [weak self] (presented) in
        self?.titleBtn.isSelected = presented
    }
    
    /// 微博视图模型
    fileprivate lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    
    /// 更新微博提示框
    fileprivate lazy var tipLabel : UILabel = UILabel()
    /// 自定义渐变的转场动画
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()

    
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
        
        // 3.设置预估高度值
        tableView.estimatedRowHeight = 200
        
        // 4.设置头部刷新控件
        setupRefreshHeaderView()
        
        // 5.设置底部刷新控件
        setupRefreshFooterView()
        
        // 6.设置更新微博提示框
        setupTipLabel()
        
        // 6.监听通知
        setupNatifications()
    }
    
}

// MARK: - 设置UI界面
extension HomeTableViewController
{
    /**
     设置导航条
     */
    fileprivate func setupNavigationBar()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        // 2.添加标题按钮
        // 获取用户名称
        let title = UserAccountViewModel.shareIntance.account?.screen_name ?? "CoderSLZeng"
        titleBtn.setTitle(title + " ", for: UIControl.State())
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    /**
     设置头部刷新控件
     */
    fileprivate func setupRefreshHeaderView() {
        // 1.创建headerView
        let refreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadNewStatuses))
        
        // 2.设置header的属性
        refreshHeader?.setTitle("下拉刷新", for: .idle)
        refreshHeader?.setTitle("释放更新", for: .pulling)
        refreshHeader?.setTitle("加载中...", for: .refreshing)
        
        // 3.设置tableView的header
        tableView.mj_header = refreshHeader
        
        // 4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    /**
     设置底部刷新控件
     */
    fileprivate func setupRefreshFooterView() {
         tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadMoreStatuses))
    }
    
    /**
     设置更新微博提示框
     */
    fileprivate func setupTipLabel() {
        // 1.添加父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        // 2.设置边框尺寸
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        
        // 3.设置属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    fileprivate func setupNatifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.showPhotoBrowser(_:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }

}

// MARK: - 监听事件处理
extension HomeTableViewController
{
    @objc fileprivate func leftBtnClick()
    {
        myLog("")
    }
    @objc fileprivate func rightBtnClick()
    {
        // 1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.弹出二维码控制器
        present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func titleBtnClick(_ button: TitleButton)
    {
        // 1.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 2.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        
        // 3.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        // 4.设置展示出来的尺寸
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        // 5.弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(_ note : Notification) {
        // 0.取出数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = note.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        // 1.创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath: indexPath, picURLs: picURLs)
        
        // 2.设置modal样式
        photoBrowserVc.modalPresentationStyle = .custom
        
        // 3.设置转场的代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        // 4.设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        
        // 5.以modal的形式弹出控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }
    
    /// 加载最新的数据
    @objc fileprivate func loadNewStatuses() {
        loadStatuses(true)
    }
    
    /// 加载更多的数据
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(false)
    }
    
}

// MARK:- 请求数据
extension HomeTableViewController {
    
    /// 加载微博数据
    fileprivate func loadStatuses(_ isNewData : Bool) {
        
        // 1.获取since_id/max_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        // 2.请求数据
        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error) -> () in
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
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                
                tempViewModel.append(viewModel)
            }
            
            // 4.将数据放入到成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels += tempViewModel
            }
            
            // 5.缓存图片
            self.cacheImages(tempViewModel)
        }
    }
    
    /**
     缓存图片
     */
    fileprivate func cacheImages(_ viewModels : [StatusViewModel]) {
        // 0.创建group
        let group = DispatchGroup()
        
        // 1.缓存图片
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs {
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                    group.leave()
                })
            }
        }
        
        // 2.刷新表格
        group.notify(queue: DispatchQueue.main) { () -> Void in
            self.tableView.reloadData()
            
            // 停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示更新微博提示框
            self.showTipLabel(viewModels.count)
        }
    }
    
    /// 显示更新微博提示的框
    fileprivate func showTipLabel(_ count : Int) {
        // 1.设置属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有更新的微博" : "更新了\(count) 条形微博"
        
        // 2.执行动画
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.tipLabel.frame.origin.y = 44
        }, completion: { (_) -> Void in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { () -> Void in
                self.tipLabel.frame.origin.y = 10
                }, completion: { (_) -> Void in
                    self.tipLabel.isHidden = true
            })
        }) 
    }
}



// MARK:- tableView的数据源方法
extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        
        // 2.给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1.获取模型对象
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}
