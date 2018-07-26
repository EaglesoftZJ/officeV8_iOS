//
//  General.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/24.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import Foundation
import UIKit

open class General {
    
    // 颜色
    let tabbarColor = UIColor.hexadecimalColor(hexadecimal: "#3C5F96")
    
    // 是否登录
    let isLogin = "isLogin"
    // 登陆后的个人信息
    let info = "info"
    // 公司列表
    static let companyList = "companyList"
    static let chooseCompany = "chooseCompany"
    // noti
    let noti = NotificationCenter.default
    let switchRootController = Notification.Name(rawValue:"rootViewController")
    // UserDefaults
    static let user = UserDefaults.standard
    //屏幕长宽 750X1334
    static let kScreenWidth = UIScreen.main.bounds.size.width
    static let kScreenHeight = UIScreen.main.bounds.size.height
    
    open func kScaleW(w:CGFloat) -> CGFloat {
        return w*General.kScreenWidth/750.0
    }
    open func kScaleH(h:CGFloat) -> CGFloat {
        return h*General.kScreenHeight/1334.0
    }
    
    // 高度
    class func isIPhoneX() -> Bool {
        if kScreenHeight == 812 {
            return true
        }
        return false
    }
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static let navigationBarHeight:CGFloat = 44.0
    static let bottomAreaHeight: CGFloat = isIPhoneX() ? 34.0 : 0
    static let tabbarHeight:CGFloat = isIPhoneX() ? 83.0 : 49.0
    
    class func noBar() -> CGRect {
        return CGRect(x: 0, y: statusBarHeight, width: kScreenWidth, height: (kScreenHeight - bottomAreaHeight - statusBarHeight))
    }
    
    class func haveBar() -> CGRect {
        return CGRect(x: 0, y: statusBarHeight, width: kScreenWidth, height: (kScreenHeight - tabbarHeight - statusBarHeight))
    }
    
    class func haveAllBar() -> CGRect {
        return CGRect(x: 0, y: 0, width: kScreenWidth, height: (kScreenHeight - tabbarHeight - navigationBarHeight - statusBarHeight))
    }
}
