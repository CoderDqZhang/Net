//
//  PhotosContainerView.swift
//  Net
//
//  Created by Zhang on 2020/1/16.
//

import UIKit
import SKPhotoBrowser

let PhotosContainerMin = 1
let PhotosContainerMax = 9
let PhotosContainerLineMax = 3
let PhotosContainerMarginLeft:CGFloat = 15
let PhotosContainerMarginRight:CGFloat = -15
let PhotosContainerMarginTop:CGFloat = 15
let PhotosContainerMarginBottom:CGFloat = -15
let PhotosContainerItemMarginLR:CGFloat = 10
let PhotosContainerItemMarginTB:CGFloat = 10

let tempWidth:CGFloat = CGFloat((UIScreen.main.bounds.size.width - CGFloat(PhotosContainerLineMax - 1) * PhotosContainerItemMarginLR))
let tempWidth1:CGFloat = tempWidth - PhotosContainerMarginLeft + PhotosContainerMarginRight
let PhotosContainerImageWidth:CGFloat = tempWidth1 / CGFloat(PhotosContainerLineMax)
//    )
let PhotosContainerImageHeight:CGFloat = PhotosContainerImageWidth

class PhotosContainerView: UIView {
    
    var tempPlacImage:NSMutableDictionary!
    var photoBrowser:SKPhotoBrowser!
    
    init(urls:[String]) {
        super.init(frame: CGRect.init(x: 0, y: 0, width:UIScreen.main.bounds.size.width , height: CGFloat(urls.count / PhotosContainerLineMax) * CGFloat(PhotosContainerImageHeight + PhotosContainerItemMarginTB) + PhotosContainerMarginTop - PhotosContainerMarginBottom))
        photoBrowser = SKPhotoBrowserManager.setUpBrowserWithStrUrl(urls: urls, holder: nil)
        for i in 0...urls.count - 1 {
            let imageView = UIImageView.init(frame: CGRect.init(x: PhotosContainerMarginLeft + CGFloat(i) * CGFloat(PhotosContainerImageWidth), y: PhotosContainerMarginTop + CGFloat(i) / CGFloat(PhotosContainerLineMax)  * PhotosContainerImageWidth, width: PhotosContainerImageWidth, height: PhotosContainerImageHeight))
            imageView.tag = i
            ImageViewManager.getSharedInstance().loadImage(urls[i], imageView: imageView, placeholderImage: nil) { (image, url, type, stage, error) in
                
            }
            imageView.newTapGesture { (config) in
                config.numberOfTouchesRequired = 1
                config.numberOfTapsRequired = 1
            }.whenTaped { (tap) in
                 self.photoBrowserClick(selectPageIndex:tap.view?.tag)
            }
            self.addSubview(imageView)
            
        }
    }
    
    func photoBrowserClick(selectPageIndex:Int?){
        SKPhotoBrowserManager.showBrowser(browser: self.photoBrowser, selectPageIndex: selectPageIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
