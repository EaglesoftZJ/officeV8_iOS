//
//  TabbarController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/22.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTabbarColor(General().tabbarColor)
        
        addChildController(WebController(), title: "工作台", imageName: "web")
        addChildController(SettingController(), title: "设置", imageName: "setting")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = General().tabbarColor
        }
    }
    
    func getTabbarColor(_ color: UIColor) {
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = color
        UITabBar.appearance().isTranslucent = false
    }
    
    func addChildController(_ vc: UIViewController, title aTitle:String, imageName aImageName: String) {
        vc.tabBarItem.image = UIImage.init(named: aImageName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage.init(named: aImageName + "_HL")?.withRenderingMode(.alwaysOriginal)
        let navi:NaviController = NaviController(rootViewController: vc)
        vc.title = aTitle
        addChildViewController(navi)
    }
}
