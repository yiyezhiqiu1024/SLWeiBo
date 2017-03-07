//
//  HomeTableViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/6.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    // MARK:- 自定义变量属性
    var isPresented : Bool = false
    
    // MARK: - 懒加载属性
    /// 标题按钮
    private lazy var titleBtn : TitleButton = TitleButton()

    
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
        myLog("")
    }
    
    @objc private func titleBtnClick(button: TitleButton)
    {
        // 1.改变按钮的状态
        titleBtn.selected = !titleBtn.selected
        
        // 2.创建弹出的控制器
        let popoverVc = PopoverViewController()
        
        // 3.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .Custom
        
        // 4.设置转场的代理
        popoverVc.transitioningDelegate = self
        
        // 5.弹出控制器
        presentViewController(popoverVc, animated: true, completion: nil)
    }
}

// MARK: - 自定义转场代理的方法
extension HomeTableViewController : UIViewControllerTransitioningDelegate {
    // 目的:改变弹出View的尺寸
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return SLPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // 目的:自定义弹出的动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    // 目的:自定义消失的动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


// MARK:- 弹出和消失动画代理的方法
extension HomeTableViewController : UIViewControllerAnimatedTransitioning {
    /// 动画执行的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /// 获取`转场的上下文`:可以通过转场上下文获取弹出的View和消失的View
    // UITransitionContextFromViewKey : 获取消失的View
    // UITransitionContextToViewKey : 获取弹出的View
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    /// 自定义弹出动画
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取弹出的View
        let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 2.将弹出的View添加到containerView中
        transitionContext.containerView()?.addSubview(presentedView)
        
        // 3.执行动画
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            presentedView.transform = CGAffineTransformIdentity
        }) { (_) -> Void in
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    /// 自定义消失动画
    private func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        // 1.获取消失的View
        let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 2.执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            dismissView?.transform = CGAffineTransformMakeScale(1.0, 0.00001)
        }) { (_) -> Void in
            dismissView?.removeFromSuperview()
            // 必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
