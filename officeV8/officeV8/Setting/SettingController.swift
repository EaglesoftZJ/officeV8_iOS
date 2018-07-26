//
//  SettingController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/22.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit

class SettingController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 9
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            cell.textLabel?.text = grxxKey[indexPath.row]
            cell.detailTextLabel?.text = grxxDetail[indexPath.row]
            cell.isUserInteractionEnabled = false
        } else {
            cell.textLabel?.text = "退出登录"
            cell.textLabel?.textColor = .red
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.confirmAlertUser("确定退出？", action: "确定", tapYes: {
                General.user.set(false, forKey: General().isLogin)
                let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
                let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = .clear
                }
                General().noti.post(name: General().switchRootController, object: nil, userInfo: ["vc": "Login"])
            })
        }
    }
    
    var info = NSDictionary()
    let table = UITableView()
    var grxxArr = Array<Dictionary<String, String>>()
    var grxxKey = Array<String>()
    var grxxDetail = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        info = General.user.object(forKey: General().info) as! NSDictionary
        
        table.frame = General.haveAllBar()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        
        grxxKey = ["账号", "姓名", "单位", "部门", "职务", "上级领导", "邮箱", "手机", "电话"]
        grxxDetail = [info["zh"],info["xm"], info["dwmc"], info["bmmc"], info["zwmc"], info["sjldxm"], info["yx"], info["sj"], info["dh"]] as! [String]
        table.reloadData()
    }
    
    
}

