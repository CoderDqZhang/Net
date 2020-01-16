//
//  ImageViewManager.swift
//  Net
//
//  Created by Zhang on 2020/1/16.
//

import UIKit
import YYKit

let ROOTSERVERIMAGEURL = ""
let PLACEHOLDERIMAGE:UIImage? = UIImage.init(named: "")

let kImageViewManagerCache = "kImageViewManagerCache"


class ImageViewManager: NSObject {
    
    private static let _sharedInstance = ImageViewManager()
    var dataCache:YYCache!
    
    class func getSharedInstance() -> ImageViewManager {
        return _sharedInstance
    }
    
    private override init() {
        dataCache = YYCache.init(name: kImageViewManagerCache)
    } // 私有化init方法
    
    func requestImageUrl(_ url:String)->String{
        return url.contains("http") ? url : "\(ROOTSERVERIMAGEURL)\(url)"
    }
    
    func requestPlacholderImage(_ image:UIImage?, _ size:CGSize?) ->UIImage?{
        if size == nil && image == nil {
            return PLACEHOLDERIMAGE
        }
        let placholderSize = size == nil ? CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height) : size
        var temp_placholderImage = image == nil ? PLACEHOLDERIMAGE : image
        let placholderImageKey = "\(String(describing: placholderSize?.width))w\(String(describing: placholderSize?.height))h"
        let placholderImageDic = self.getPlacholderImage()
        if (placholderImageDic!).object(forKey: placholderImageKey) == nil {
            temp_placholderImage = temp_placholderImage?.byResize(to: placholderSize!, contentMode: UIView.ContentMode.scaleAspectFill)
            return temp_placholderImage
        }
        return ((placholderImageDic!).object(forKey: placholderImageKey) as! UIImage)
    }
    
    
    func savePlacholderImage(point:NSMutableDictionary){
        self.dataCache.setObject(point, forKey: kImageViewManagerCache)
    }
    
    func getPlacholderImage() ->NSMutableDictionary?{
        if (ImageViewManager.getSharedInstance().dataCache.containsObject(forKey: kImageViewManagerCache)) {
            let item = (self.dataCache.object(forKey: kImageViewManagerCache))!
            return item as? NSMutableDictionary
        }
        return nil
    }
    
    func loadImage(_ url:String, imageView:UIImageView?, placeholderImage:UIImage?, completedBlock:YYWebImageCompletionBlock?){
        
        let placeholder = self.requestPlacholderImage(placeholderImage, imageView?.size)
        imageView!.setImageWith(URL.init(string: ImageViewManager.getSharedInstance().requestImageUrl(url)),
                                placeholder: placeholder,
                                options: [.setImageWithFadeAnimation,
                                          .progressiveBlur,
                                          .showNetworkActivity,
                                          .avoidSetImage],
                                manager: nil,
                                progress: { (start, total) in
                                    
        },
                                transform: { (image, url) -> UIImage? in
                                    if imageView?.size == nil {
                                        return image
                                    }
                                    return image.byResize(to: imageView!.size, contentMode: UIView.ContentMode.scaleAspectFill)
        }) { (image, url, type, stage, error) in
            completedBlock!(image, url, type, stage, error)
        }
    }
}
