//
//  ZDQNetWorkingCache.swift
//  Net
//
//  Created by Zhang on 2020/1/15.
//

import UIKit
import YYKit

let kZDQNetWorkResponseCache = "kZDQNetWorkResponseCache"

class ZDQNetWorkingCache: NSObject {
    
    private static let _sharedInstance = ZDQNetWorkingCache()
    var dataCache:YYCache!
    class func getSharedInstance() -> ZDQNetWorkingCache {
        return _sharedInstance
    }
    
    private override init() {
        dataCache = YYCache.init(name: kZDQNetWorkResponseCache)
    } // 私有化init方法
    
    class func setHttpCache(httpData:AnyObject, url:String, parameters:AnyObject?){
        let cacheKey = ZDQNetWorkingCache.cacheKeyWithUrl(url: url, parameters: parameters)
        ZDQNetWorkingCache.getSharedInstance().dataCache.setObject(httpData as? NSCoding, forKey: cacheKey, with: nil)
    }
    
    class func httpCacheForUrl(url:String, parameters:AnyObject) ->AnyObject?{
        let cacheKey = ZDQNetWorkingCache.cacheKeyWithUrl(url: url, parameters: parameters)
        return ZDQNetWorkingCache.getSharedInstance().dataCache.object(forKey: cacheKey)
    }
    
    class func getALlHttpCacheSize() ->Int{
        return ZDQNetWorkingCache.getSharedInstance().dataCache.diskCache.totalCost()
    }
    
    class func removeALlHttpCache(){
        ZDQNetWorkingCache.getSharedInstance().dataCache.diskCache.removeAllObjects()
    }
    
    class func cacheKeyWithUrl(url:String, parameters:AnyObject?) ->String{
        if parameters == nil {
            return url
        }
        var str = ""
        for dic in (parameters as! NSDictionary).allKeys {
            str = "\(str)\(dic)\((parameters as! NSDictionary).object(forKey: dic)!)"
        }
        return "\(url)\(str)"
    }
}
