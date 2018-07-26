//
//  Toast.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/25.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

private var HUDKey = "HUDKey"

public extension UIView {
    
    var hud : MBProgressHUD?
    {
        get{
            return objc_getAssociatedObject(self, &HUDKey) as? MBProgressHUD
        }
        set{
            objc_setAssociatedObject(self, &HUDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showToast() {
        let HUD = MBProgressHUD.showAdded(to: self, animated: true)
        HUD.label.text = "加载中..."
        HUD.isUserInteractionEnabled = true
        HUD.margin = 10
        HUD.offset.y = 50
        HUD.removeFromSuperViewOnHide = true
        hud = HUD
    }
    
    func hideToast(){
        if let hud = hud {
            hud.hide(animated: true)
        }
    }
}
