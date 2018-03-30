//
//  String+SandboxPath.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/7.
//  Copyright © 2017年 SLZeng. All rights reserved.
//  获取沙盒路径

import UIKit

extension String
{
    /// 快速生成缓存路径
    func cachesDir() -> String
    {
        // 1.获取缓存目录的路径
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (cachesPath as NSString).appendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成文档路径
    func docDir() -> String
    {
        // 1.获取缓存目录的路径
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (docPath as NSString).appendingPathComponent(name)
        
        return filePath
    }
    /// 快速生成临时路径
    func tmpDir() -> String
    {
        // 1.获取缓存目录的路径
        let tmpPath = NSTemporaryDirectory()
        
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (tmpPath as NSString).appendingPathComponent(name)
        
        return filePath
    }
}
