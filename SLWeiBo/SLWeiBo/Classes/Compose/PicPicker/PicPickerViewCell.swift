//
//  PicPickerViewCell.swift
//  DS11WB
//
//  Created by xiaomage on 16/4/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {

    // MARK:- 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    // MARK:- 定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                addPhotoBtn.setBackgroundImage(image, forState: .Normal)
                addPhotoBtn.userInteractionEnabled = false
            } else {
                addPhotoBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                addPhotoBtn.userInteractionEnabled = true
            }
        }
    }
    
    // MARK:- 事件监听
    @IBAction func addPhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerAddPhotoNote, object: nil)
    }

}
