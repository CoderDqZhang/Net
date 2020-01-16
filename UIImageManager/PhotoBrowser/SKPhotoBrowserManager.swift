//
//  SKPhotoBrowserManager.swift
//  Net
//
//  Created by Zhang on 2020/1/16.
//
import UIKit
import SKPhotoBrowser

class SKPhotoBrowserManager: NSObject {
    
    class func setUp() {
        SKPhotoBrowserManager.config()
    }
    
    class func setUpBrowserWithImages(images:[UIImage]) -> SKPhotoBrowser{
        var skImages = [SKPhoto]()
        for image in images{
            let photo = SKPhoto.photoWithImage(image)
            skImages.append(photo)
        }
        let browser = SKPhotoBrowser(photos: skImages)
        return browser
    }
    
    class func setUpBrowserWithStrUrl(urls:[String], holder:[UIImage?]?) -> SKPhotoBrowser{
        var images = [SKPhoto]()
        for i in 0...urls.count - 1{
            let photo = SKPhoto.photoWithImageURL(urls[i], holder: holder[i])
            images.append(photo)
        }
        let browser = SKPhotoBrowser(photos: images)
        return browser
    }
    
    class func showBrowser(browser:SKPhotoBrowser, selectPageIndex:Int?){
        browser.initializePageIndex(selectPageIndex == nil ? 0: selectPageIndex!)
        UIApplication.shared.windows[0].viewController?.present(browser, animated: true, completion: {
            
        })
    }
    
    class func config(){
        SKPhotoBrowserOptions.displayStatusbar = false                              // all tool bar will be hidden
        SKPhotoBrowserOptions.displayCounterLabel = false                         // counter label will be hidden
        SKPhotoBrowserOptions.displayBackAndForwardButton = false                 // back / forward button will be hidden
        SKPhotoBrowserOptions.displayAction = false                               // action button will be hidden
        SKPhotoBrowserOptions.displayHorizontalScrollIndicator = false            // horizontal scroll bar will be hidden
        SKPhotoBrowserOptions.displayVerticalScrollIndicator = false              // vertical scroll bar will be hidden
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
    }
}

