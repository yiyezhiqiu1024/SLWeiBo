//
//  NetworkTools.swift
//  SLWeiBo
//
//  Created by Anthony on 17/3/10.
//  Copyright © 2017年 SLZeng. All rights reserved.
//  AFNetworking的封装
//

import AFNetworking

// 定义枚举类型
enum RequestType : String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools: AFHTTPSessionManager {
    // let是线程安全的
    static let shareInstance : NetworkTools = {
        let url = URL(string: "https://api.weibo.com/")
        let instance = NetworkTools(baseURL: url, sessionConfiguration: URLSessionConfiguration.default)
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
}

// MARK:- 封装请求方法
extension NetworkTools {
    func request(_ methodType : RequestType, urlString : String, parameters : [String : Any], finished : @escaping (_ result : Any?, _ error : NSError?) -> ()) {
        
        // 1.定义成功的回调闭包
        let successCallBack = { (task : URLSessionDataTask, result : Any?) -> Void in
            finished(result, nil)
        }
        
        // 2.定义失败的回调闭包
        _ = { (task : URLSessionDataTask?, error : NSError) -> Void in
            finished(nil, error)
        }
        
        // 3.发送网络请求
        if methodType == .GET {
            
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: nil)
            
//            get(urlString, parameters: parameters, progress: nil, success: successCallBack as? (URLSessionDataTask, Any?) -> Void, failure: (failureCallBack as? (URLSessionDataTask?, Error) -> Void))
            
            
        } else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: nil)
//            post(urlString, parameters: parameters, progress: nil, success: (successCallBack as? (URLSessionDataTask, Any?) -> Void as! (URLSessionDataTask, Any?) -> Void), failure: failureCallBack as? (URLSessionDataTask?, Error) -> Void)
        }
        
        







    }
}


// MARK:- 请求AccessToken
extension NetworkTools {
    func loadAccessToken(_ code : String, finished : @escaping (_ result : [String : Any]?, _ error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "oauth2/access_token"
        
        // 2.获取请求的参数
        let parameters : [String : Any] = ["client_id" : WB_App_Key, "client_secret" : WB_App_Secret, "grant_type" : "authorization_code", "redirect_uri" : WB_Redirect_URI, "code" : code]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result as? [String : Any], error)
        }
    }
}

// MARK:- 请求用户的信息
extension NetworkTools {
    func loadUserInfo(_ access_token : String, uid : String, finished : @escaping (_ result : [String : Any]?, _ error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "2/users/show.json"
        
        // 2.获取请求的参数
        let parameters : [String : Any] = ["access_token" : access_token, "uid" : uid]
        
        // 3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            finished(result as? [String : Any] , error)
        }
    }
}

// MARK:- 请求首页数据
extension NetworkTools {
    func loadStatuses(_ since_id : Int, max_id : Int, finished : @escaping (_ result : [[String : Any]]?, _ error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "2/statuses/home_timeline.json"
        
        // 2.获取请求的参数
        let parameters : [String : Any] = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        
        // 3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) -> () in
            
            // 1.获取字典的数据
            guard let resultDict = result as? [String : Any] else {
                finished(nil, error)
                return
            }
            
            // 2.将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : Any]], error)
        }
    }
}

// MARK:- 发送微博
extension NetworkTools {
    func sendStatus(_ statusText : String, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        // 1.获取请求的URLString
        let urlString = "2/statuses/update.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters as [String : Any]) { (result, error) -> () in
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
}


// MARK:- 发送微博并且携带照片
extension NetworkTools {
    func sendStatus(_ statusText : String, image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()) {
        // 1.获取请求的URLString
        let urlString = "2/statuses/upload.json"
        
        // 2.获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
        
        // 3.发送网络请求
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) -> Void in
            
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
            
            }, progress: nil, success: { (_, _) -> Void in
                isSuccess(true)
        }) { (_, error) -> Void in
            myLog(error)
        }
    }
}

