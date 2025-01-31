//
//  AlertController+Tools.swift
//  Net
//
//  Created by Zhang on 2020/1/16.
//

import UIKit

import Foundation
import UIKit

typealias CancelAction = () -> Void
typealias DoneAction = () -> Void

extension UIAlertController {
    
    convenience init(message: String?) {
        self.init(title: nil, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    }
    
    class func showAlertControl(_ controller:UIViewController,style:UIAlertController.Style,title:String?,message:String?, cancel:String?, doneTitle:String?, cancelAction: @escaping CancelAction, doneAction:@escaping DoneAction){
        var alertControl = UIAlertController()
        if title == nil {
           alertControl = UIAlertController(title: nil, message: message, preferredStyle: style)
        }else if message == nil{
            alertControl = UIAlertController(title: title, message: nil, preferredStyle: style)

        }else{
            alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        
        if cancel != nil {
            let leftAction = UIAlertAction(title: cancel, style: .default) { (action) in
                cancelAction()
            }
            alertControl.addAction(leftAction)
        }
        if doneTitle != nil {
            let rightAction = UIAlertAction(title: doneTitle, style: .default) { (action) in
                doneAction()
            }
            alertControl.addAction(rightAction)
        }
        controller.present(alertControl, animated: true) {
            
        }
    }
}

