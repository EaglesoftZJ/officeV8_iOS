//
//  AppDelegate.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/21.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let general = General()
    let userInfo = UserInfo()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Thread.sleep(forTimeInterval: 1.0)
        
        getCompanyList()
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        general.noti.addObserver(self, selector: #selector(switchRootViewController), name: general.switchRootController, object: nil)
        
        return true
    }

    func defaultViewController() -> UIViewController {
        if General.user.bool(forKey: general.isLogin) == true {
            return TabbarController()
        } else {
            return LoginController()
        }
    }
    
    @objc func switchRootViewController(_ n: Notification) {
        let dict:Dictionary = n.userInfo!
        if dict["vc"] as! String == "Main" {
            window?.rootViewController = TabbarController()
        } else if dict["vc"] as! String == "Login" {
            window?.rootViewController = LoginController()
        } else {
            window?.rootViewController = defaultViewController()
        }
    }
    
    func getCompanyList() {
        if General.user.array(forKey: General.companyList) == nil || General.user.object(forKey: General.chooseCompany) == nil {
            let company = ["egName": userInfo.companyName, "egAddress": userInfo.companyIP, "account": userInfo.account, "password": userInfo.password]
            General.user.set([company], forKey: General.companyList)
            General.user.set(company, forKey: General.chooseCompany)
        }
        if General.user.object(forKey: General.chooseCompany) != nil {
            let dic = (General.user.object(forKey: General.chooseCompany) as! NSDictionary)
            userInfo.companyIP = dic["egAddress"] as! String
            userInfo.companyName = dic["egName"] as! String
            userInfo.account = dic["account"] as! String
            userInfo.password = dic["password"] as! String
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

