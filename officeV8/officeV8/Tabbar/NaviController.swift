//
//  NaviController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/24.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit

class NaviController: UINavigationController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = General().tabbarColor
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back.png"), style: .plain, target: self, action: #selector(back))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func back() {
        super.popViewController(animated: true)
    }
}
