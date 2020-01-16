//
//  ZDQNetworkConfig.swift
//  Net
//
//  Created by Zhang on 2020/1/15.
//

import UIKit
import Alamofire


var isOPenLog = false

class ZDQNetworkConfig: NSObject {
    
    let configuration = URLSessionConfiguration.default
    
    private static let _sharedInstance = ZDQNetworkConfig()
    
    class func getSharedInstance() -> ZDQNetworkConfig {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
    
    func setNetWorkConfig(){
        configuration.timeoutIntervalForRequest = 30
        _ = Alamofire.SessionManager(configuration: configuration)
        
    }
    
    func setResponseSerializer(responseSerializer:ZDQNetWorkResponseSerializer){
        
    }
    
    func setRequestSerializer(requestSerializer:ZDQNetworkRequestSerializer){
        
    }
    
    func setRequestTimeOutInterval(value:Int){
        
    }
    
    func openNetWorkActivityIndicator(isOpen:Bool){
        
    }
    
    func setSecurityPolicyWithCerPath(cerPath:String, validatesDomainName:Bool){
        
    }
}

