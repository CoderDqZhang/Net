//
//  UMengManager.swift
//  Net
//
//  Created by Zhang on 2020/1/16.
//

import UIKit

enum UMPlatform:Int {
    case weibo = 0
    case weichat = 1
    case qq = 2
}

typealias UMengManagerShareResponse = (_ data:UMSocialShareResponse) ->Void
typealias UMengManagerShareError = (_ error:Error) ->Void
typealias UMengManagerUserInfoResponse = (_ data:UMSocialUserInfoResponse, _ type:UMPlatform) ->Void

class UMengManager: NSObject {
    
    var umengManagerShareResponse:UMengManagerShareResponse!
    var umengManagerUserInfoResponse:UMengManagerUserInfoResponse!
    var umengManagerShareError:UMengManagerShareError!
    
    private static let _sharedInstance = UMengManager()
    
    class func getSharedInstance() -> UMengManager {
        return _sharedInstance
    }
    
    private override init() {} // 私有化init方法
    
    
    /// 初始化友盟t
    /// - Parameters:
    ///   - application:
    ///   - launchOptions:
    func setUpUMengManger(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        UMConfigure.initWithAppkey(UMAPPKEY, channel: "App Store")
        UMConfigure.setEncryptEnabled(true)
        UMengManager.getSharedInstance().configUSharePlatforms()
        UMengManager.getSharedInstance().confitUShareSettings()
        
    }
    
    func confitUShareSettings(){
        
    }
    
    
    /// 设置平台
    func configUSharePlatforms(){
        //微信
        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: WECHATAPPID, appSecret: WECHATSECRET, redirectURL: "")
        //微信
        UMSocialManager.default()?.setPlaform(.wechatTimeLine, appKey: WECHATAPPID, appSecret: WECHATSECRET, redirectURL: "")
        //QQ
        UMSocialManager.default()?.setPlaform(.QQ, appKey: QQAPPID, appSecret: QQSECRET, redirectURL: "")
        //QQ空间
        UMSocialManager.default()?.setPlaform(.qzone, appKey: QQAPPID, appSecret: QQSECRET, redirectURL: "")
        //新浪
        UMSocialManager.default()?.setPlaform(.sina, appKey: SINAAPPID, appSecret: SINASECRET, redirectURL: WeiboRedirectUrl)
    }
    
    func loginWithPlatform(type:UMSocialPlatformType,controller:UIViewController, platform:UMPlatform){
        UMSocialManager.default()?.getUserInfo(with: type, currentViewController: controller, completion: { (result, error) in
            if error != nil {
                self.umengManagerShareError(error!)
            }else{
                if result is UMSocialUserInfoResponse {
                    if self.umengManagerUserInfoResponse != nil {
                        let resp = result as! UMSocialUserInfoResponse
                        self.umengManagerUserInfoResponse(resp,platform)
                    }
                }
            }
        })
    }
    
    //文字加多媒体
    func sharePlatformImageTitle(type:UMSocialPlatformType,
                                 title:String,
                                 descr:String,
                                 thumImage:UIImage,
                                 controller:UIViewController,
                                 completion:UMSocialRequestCompletionHandler){
        let object = UMSocialMessageObject.init()
        object.title = title
        object.text = descr
        let shareObject = UMShareImageObject.shareObject(withTitle: title, descr: descr, thumImage: thumImage)
        shareObject?.title = title
        shareObject?.descr = descr
        shareObject?.thumbImage = thumImage
        shareObject?.shareImage = thumImage
        object.shareObject = shareObject
        UMSocialManager.default()?.share(to: type, messageObject: object, currentViewController: controller, completion: { (dic, error) in
            if error != nil {
                self.umengManagerShareError(error!)
            }else{
                if (dic is UMSocialShareResponse) {
                    let resp = dic as! UMSocialShareResponse
                    if self.umengManagerShareResponse != nil {
                        self.umengManagerShareResponse(resp)
                    }
                }
            }
        })
    }
    
    //单纯分享图片
    func sharePlatformImage(type:UMSocialPlatformType,thumImage:UIImage,image_url:String, controller:UIViewController,completion:UMSocialRequestCompletionHandler){
        let object = UMSocialMessageObject.init()
        let shareObject = UMShareImageObject.init()
        shareObject.thumbImage = thumImage
        shareObject.shareImage = image_url
        object.shareObject = shareObject
        UMSocialManager.default()?.share(to: type, messageObject: object, currentViewController: controller, completion: { (dic, error) in
            if error != nil {
                self.umengManagerShareError(error!)
            }else{
                if (dic is UMSocialShareResponse) {
                    let resp = dic as! UMSocialShareResponse
                    if self.umengManagerShareResponse != nil {
                        self.umengManagerShareResponse(resp)
                    }
                }
            }
        })
    }
    
    //分享网页链接
    func sharePlatformWeb(type:UMSocialPlatformType, title:String,descr:String,thumImage:UIImage, web_url:String, controller:UIViewController,completion:UMSocialRequestCompletionHandler) {
        let object = UMSocialMessageObject.init()
        let webObject = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: thumImage)
        webObject?.webpageUrl = web_url
        object.shareObject = webObject
        UMSocialManager.default()?.share(to: type, messageObject: object, currentViewController: controller, completion: { (dic, error) in
            if error != nil {
                self.umengManagerShareError(error!)
            }else{
                if (dic is UMSocialShareResponse) {
                    let resp = dic as! UMSocialShareResponse
                    if self.umengManagerShareResponse != nil {
                        self.umengManagerShareResponse(resp)
                    }
                }
            }
        })
    }
}

