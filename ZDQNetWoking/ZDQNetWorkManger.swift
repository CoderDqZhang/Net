//
//  BaseNetWorke.swift
//  LiangPiao
//
//  Created by Zhang on 28/10/2016.
//  Copyright © 2016 Zhang. All rights reserved.
//

import UIKit
import Alamofire

enum HttpRequestType {
    case post
    case get
    case delete
    case put
}

//判断网络状态
enum ZDQNetworStatus {
    case ZDQNetworkUnknown
    case ZDQNetworkNotReachable
    case ZDQNetworkReachableeViaWWAN
    case ZDQNetworkReachableViaWiFi
}

enum ZDQNetworkRequestSerializer {
    case ZDQRequestSerializerJSON
    case ZDQRequestSerializerForm
}

enum ZDQNetWorkResponseSerializer {
    case ZDQResponseSerializerJSON
    case ZDQResponseSerializerHTTP
    case ZDQResponseSerializerString
}

typealias ZDQHttpRequestSucess = (_ sucess:AnyObject) ->Void
typealias ZDQHttpRequestFailed = (_ fail:Error) ->Void
typealias ZDQHttpRequestCache = (_ cache:AnyObject?) ->Void
typealias ZDQHttpProgress = (_ progress:Progress) ->Progress
typealias ZDQHttpNetStatusBlock = (_ status:ZDQNetworStatus) ->ZDQNetworStatus


class ZDQNetWorkManager : SessionManager {
    
    private static let _sharedInstance = ZDQNetWorkManager()
    var sessionManager:SessionManager!
    
    class func getSharedInstance() -> ZDQNetWorkManager {
        return _sharedInstance
    }
    
    private init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        sessionManager = Alamofire.SessionManager.init(configuration: configuration, delegate: self.delegate, serverTrustPolicyManager: nil)
    }
    
    /**
    *  GET请求,无缓存
    *
    *  @param URL        请求地址
    *  @param parameters 请求参数
    *  @param success    请求成功的回调
    *  @param failure    请求失败的回调
    *
    *  @return 返回的对象可取消请求,调用cancel方法
    */
    func GET(url:String,
                   parameter:AnyObject?,
                   sucess:@escaping ZDQHttpRequestSucess,
                   fail:@escaping ZDQHttpRequestFailed){
        self.httpRequest(.get, url: url, parameters: parameter, success: sucess, failure: fail)
    }
    
    /**
    *  GET请求,自动缓存
    *
    *  @param URL           请求地址
    *  @param parameters    请求参数
    *  @param responseCache 缓存数据的回调
    *  @param success       请求成功的回调
    *  @param failure       请求失败的回调
    *
    *  @return 返回的对象可取消请求,调用cancel方法
    */
    func GET(url:String,
                   parameter:AnyObject?,
                   responseCache:@escaping ZDQHttpRequestCache,
                   sucess:@escaping ZDQHttpRequestSucess,
                   fail:@escaping ZDQHttpRequestFailed){
        responseCache(ZDQNetWorkingCache.cacheKeyWithUrl(url: url, parameters: parameter) as AnyObject)
        self.httpRequest(.get, url: url, parameters: parameter, success: sucess, failure: fail)
        
    }
    
    /**
       *  POST请求,无缓存
       *
       *  @param URL        请求地址
       *  @param parameters 请求参数
       *  @param success    请求成功的回调
       *  @param failure    请求失败的回调
       *
       *  @return 返回的对象可取消请求,调用cancel方法
       */
    func POST(url:String,
                    parameter:AnyObject?,
                    sucess:@escaping ZDQHttpRequestSucess,
                    fail:@escaping ZDQHttpRequestFailed){
        self.httpRequest(.post, url: url, parameters: parameter, success: sucess, failure: fail)
    }
    
    
    /**
    *  POST请求,无缓存
    *
    *  @param URL        请求地址
    *  @param parameters 请求参数
    *  @param success    请求成功的回调
    *  @param failure    请求失败的回调
    *
    *  @return 返回的对象可取消请求,调用cancel方法
    */
    func POST(url:String,
                    parameter:AnyObject?,
                    responseCache:@escaping ZDQHttpRequestCache,
                    sucess:@escaping ZDQHttpRequestSucess,
                    fail:@escaping ZDQHttpRequestFailed){
        responseCache(ZDQNetWorkingCache.cacheKeyWithUrl(url: url, parameters: parameter) as AnyObject)
         self.httpRequest(.post, url: url, parameters: parameter, success: sucess, failure: fail)
    }
    
    
    /**
    *  上传文件
    *
    *  @param URL        请求地址
    *  @param parameters 请求参数
    *  @param name       文件对应服务器上的字段
    *  @param filePath   文件本地的沙盒路径
    *  @param progress   上传进度信息
    *  @param success    请求成功的回调
    *  @param failure    请求失败的回调
    *
    *  @return 返回的对象可取消请求,调用cancel方法
    */
    
    func uploadFileWithUrl(url:String,
                                 parameters:NSDictionary?,
                                 images:NSDictionary?,
                                 progress:ZDQHttpProgress,
                                 sucess:@escaping ZDQHttpRequestSucess,
                                 fail:@escaping ZDQHttpRequestFailed){
        self.httpUpload(url, parameters: parameters, images: images, success: sucess, failure: fail)
    }
    
    
    
    /**
    *  上传文件
    *
    *  @param URL        请求地址
    *  @param parameters 请求参数
    *  @param name       文件对应服务器上的字段
    *  @param filePath   文件本地的沙盒路径
    *  @param progress   上传进度信息
    *  @param success    请求成功的回调
    *  @param failure    请求失败的回调
    *
    *  @return 返回的对象可取消请求,调用cancel方法
    */
    
    class func uploadFileWithUrl(url:String,
                                 parameters:AnyObject?,
                                 name:String,
                                 images:[UIImage],
                                 fileNames:[String],
                                 imageScales:CGFloat,
                                 imageType:String,
                                 progress:ZDQHttpProgress,
                                 sucess:ZDQHttpRequestSucess,
                                 fail:ZDQHttpRequestFailed){
        
    }
    
    
    /**
    *  下载文件
    *
    *  @param URL      请求地址
    *  @param fileDir  文件存储目录(默认存储目录为Download)
    *  @param progress 文件下载的进度信息
    *  @param success  下载成功的回调(回调参数filePath:文件的路径)
    *  @param failure  下载失败的回调
    *
    *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
    */
    
    func downloadFileWithUrl(url:String,
                                 fileDir:String,
                                 progress:ZDQHttpProgress,
                                 sucess:ZDQHttpRequestSucess,
                                 fail:ZDQHttpRequestFailed){
//        Alamofire.download(url, method: .post, parameters: nil, encoding: .URLEncoding, headers: nil) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//
//        }
    }
    
    
    func httpUpload(_ url:String, parameters:NSDictionary?, images:NSDictionary?, success:@escaping ZDQHttpRequestSucess, failure:@escaping ZDQHttpRequestFailed){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
                if parameters != nil {
                    for i in 0...(parameters!).allValues.count - 1 {
                        multipartFormData.append((parameters!.allValues[i] as! String).data(using: String.Encoding.utf8, allowLossyConversion: true)!, withName: parameters!.allKeys[i] as! String)
                    }
                }
                
                if images != nil {
                    for j in 0...(images!).allValues.count - 1 {
                        multipartFormData.append(URL.init(fileURLWithPath: images?.allValues[j] as! String), withName: "file")
                    }
                }
                
            }, usingThreshold: 1, to: url, method: .post, headers: [
                "content-type": "multipart/form-data",
                "cache-control": "no-cache"
            ]) { (encodingResult) in
                print(encodingResult)
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString(completionHandler: { (response) in
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            success(response.result.value as AnyObject)
                        }
                    })
                case .failure(let encodingError):
                    print(encodingError)
                    failure(encodingError)
                }
            }
    }

    
    ///
    /// - parameter url:        输入URL
    /// - parameter parameters: 参数
    ///
    /// - returns: 一个信号
    func httpRequest(_ type:HttpRequestType,url:String, parameters:AnyObject?, success:@escaping ZDQHttpRequestSucess, failure:@escaping ZDQHttpRequestFailed) {
        
        var methods:HTTPMethod
        switch type {
            case .post:
                methods = HTTPMethod.post
            case .get:
                methods = HTTPMethod.get
            case .delete:
                methods = HTTPMethod.delete
            default:
                methods = HTTPMethod.put
        }
        
        sessionManager.request(url, method: methods , parameters: parameters as? [String: Any], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.error != nil{
                failure(response.error!)
            }else{
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    success(response.value as! NSDictionary)
                }else{
                    print("服务出错")
                    failure(response.error!)
                }
            }
        }
    }
    
    
    func jsonStringToDic(_ dictionary_temp:String) ->NSDictionary {
        let data = dictionary_temp.data(using: String.Encoding.utf8)! as NSData
        let dictionary_temp_temp = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return dictionary_temp_temp as! NSDictionary
        
    }
    
    func dataToDic(_ dictionary_temp:Data) ->NSDictionary{
        let dictionary_temp_temp = try? JSONSerialization.jsonObject(with: dictionary_temp as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
        if  dictionary_temp_temp is NSDictionary{
            return dictionary_temp_temp as! NSDictionary
        }
        return NSDictionary.init()
    }
    
    func header() ->HTTPHeaders{
//        let app_v = versionCheck()
//        let now = Date()
//        let timeInterval:TimeInterval = now.timeIntervalSince1970
//        let time = Int(timeInterval)
//        let imei = UIDevice.current.identifierForVendor
//        let os_v = UIDevice.current.systemVersion //iOS版本
//        let str = "api_v=\(app_v)&imei=\(String(describing: imei!))&os=ios&os_v=\(os_v)&time=\(time)"
//        let lock = NSString.aes128Encrypt(str, key:AESKey)
        let headers:HTTPHeaders?
        headers = HTTPHeaders.init()
//        headers = (["sign":lock,"token":UserDefaults.init().object(forKey: CACHEMANAUSERTOKEN) ?? "","api_v":"\(app_v)","time":"\(time)", "imei": "\(String(describing: imei!))","os":"ios","os_v":"\(os_v)"] as! HTTPHeaders)
        return headers!
    }
}

