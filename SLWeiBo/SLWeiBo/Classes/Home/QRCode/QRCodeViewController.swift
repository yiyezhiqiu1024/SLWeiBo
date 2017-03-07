//
//  QRCodeViewController.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    @IBOutlet weak var customTabbar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置默认选中
        customTabbar.selectedItem = customTabbar.items?.first
    }

    @IBAction func photoBtnClick(sender: AnyObject) {
    }
    
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
