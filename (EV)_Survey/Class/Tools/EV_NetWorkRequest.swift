//
//  EV_NetWorkRequest.swift
//  (EV)_Survey
//
//  Created by 杨昱航 on 2017/8/21.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

import UIKit

class EV_NetWorkRequest: NSObject {
    enum EVRequestType {
        /*! \ Get 无论有无Body  Response */
        /*! \ Get 无论有无Body  Request */
        /*! \ Post 无论有无Body  Request */
        /*! \ Post 无Body  Response */
        case Get_All_Response,Get_All_Request,Post_All_Request,Post_NoBody_Response
    }
    
    class func requestToolwithUrl(url:String,body:Dictionary<String, Any>?,completionBlock:@escaping (_ dic:Dictionary<String, Any>,_ isSucess:Bool) -> (),type:EVRequestType){
        
        let manager = AFHTTPRequestOperationManager.init()
        
        
        if type == .Get_All_Response {
            manager.responseSerializer = AFHTTPResponseSerializer.init()
            manager.get(url, parameters: body, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) in

                //json 字符串转换为data
                guard let data = try? JSONSerialization.data(withJSONObject: responseObject!, options: .prettyPrinted) else {return}
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any] {
                    completionBlock(json,true)
                }
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                print("失败====\(error.debugDescription)")
            })
        }
        if type == .Get_All_Request {
            manager.requestSerializer = AFHTTPRequestSerializer.init()
            manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/plain","text/html","application/json"]) as! Set<AnyHashable>
            
            manager.get(url, parameters: body, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) in

                let json = responseObject as? Dictionary<String, Any>
                completionBlock(json!,true)
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                print("失败====\(error.debugDescription)")
            })
        }
        if type == .Post_All_Request {
            manager.requestSerializer = AFJSONRequestSerializer.init()
            manager.responseSerializer.acceptableContentTypes = NSSet.init(array: ["text/plain","text/html","application/json"]) as! Set<AnyHashable>
            manager.post(url, parameters: body, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) in

                let json = responseObject as? Dictionary<String, Any>
                completionBlock(json!,true)

            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                print("失败====\(error.debugDescription)")
            })
        }
        if type == .Post_NoBody_Response {
            manager.responseSerializer = AFHTTPResponseSerializer.init()
            
            
            manager.post(url, parameters: body, success: { (operation:AFHTTPRequestOperation?, responseObject:Any?) in
                
                //json 字符串转换为data
                //guard let data = try? JSONSerialization.data(withJSONObject: responseObject!, options: .prettyPrinted) else {return}
                
                if let json = try? JSONSerialization.jsonObject(with: responseObject as! Data, options: .allowFragments) as! [String:Any] {
                    completionBlock(json,true)
                }
                
            }, failure: { (operation:AFHTTPRequestOperation?, error:Error?) in
                print("失败====\(error.debugDescription)")
            })
        }
    }
    
    //获取上传图片的key和token
    class func getServiceKeyWithFileName(fileName:String,completionBlock:@escaping (_ dic:Dictionary<String, Any>,_ isSucess:Bool) -> ()){
        let url = "http://www.caishangqing.com/api/user/qiniuuploadaccess"
        EV_NetWorkRequest.requestToolwithUrl(url: url, body: ["key":fileName], completionBlock: completionBlock, type: .Post_All_Request)
    }
    
    //获取行政区域
    class func getAreaList(completionBlock:@escaping (_ dic:Dictionary<String, Any>,_ isSucess:Bool) -> ()){
        let url = "http://www.caishangqing.com/api/arealist?"
        EV_NetWorkRequest.requestToolwithUrl(url: url, body: nil, completionBlock: completionBlock, type: .Get_All_Request)
    }
    
    //提交表单
    class func postInfoWithBody(body:[String:Any],completionBlock:@escaping (_ dic:Dictionary<String, Any>,_ isSucess:Bool) -> ()){
        let url = "http://www.caishangqing.com/api/list/add"
        EV_NetWorkRequest.requestToolwithUrl(url: url, body: body, completionBlock: completionBlock, type: .Post_All_Request)
    }
}
