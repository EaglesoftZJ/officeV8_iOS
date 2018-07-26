//
//  Alerts.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/25.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    public func alertUser(_ message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        controller.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    public func alertUser(_ message: String, tapYes: @escaping ()->()) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        controller.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: { (alertView) -> () in
            tapYes()
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    public func confirmAlertUser(_ message: String, action: String, tapYes: @escaping ()->(), tapNo: (()->())? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        controller.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: { (alertView) -> () in
            tapYes()
        }))
        controller.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertView) -> () in
            tapNo?()
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    public func confirmAlertUserDanger(_ message: String, action: String, tapYes: @escaping ()->(), tapNo: (()->())? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        controller.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.destructive, handler: { (alertView) -> () in
            tapYes()
        }))
        controller.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (alertView) -> () in
            tapNo?()
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    public func confirmDangerSheetUser(_ action: String, tapYes: @escaping ()->(), tapNo: (()->())?) {
        showActionSheet(nil, buttons: [], cancelButton: "取消", destructButton: action, sourceView: UIView(), sourceRect: CGRect.zero) { (index) -> () in
            if index == -2 {
                tapYes()
            } else {
                tapNo?()
            }
        }
    }
    
    public func showActionSheet(_ title: String?, buttons: [String], cancelButton: String?, destructButton: String?, sourceView: UIView, sourceRect: CGRect, tapClosure: @escaping (_ index: Int) -> ()) {
        
        let controller = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if cancelButton != nil {
            controller.addAction(UIAlertAction(title: cancelButton, style: UIAlertActionStyle.cancel, handler: { (alertView) -> () in
                tapClosure(-1)
            }))
        }
        
        if destructButton != nil {
            controller.addAction(UIAlertAction(title: destructButton, style: UIAlertActionStyle.destructive, handler: { (alertView) -> () in
                tapClosure(-2)
            }))
        }
        
        for b in 0..<buttons.count {
            controller.addAction(UIAlertAction(title: buttons[b], style: UIAlertActionStyle.default, handler: { (alertView) -> () in
                tapClosure(b)
            }))
        }
        
        self.present(controller, animated: true, completion: nil)
    }
    
}

