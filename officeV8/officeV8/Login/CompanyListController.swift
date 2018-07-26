//
//  CompanyListController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/24.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit

protocol companyListDelegate: NSObjectProtocol {
    func getCompany(dic: NSDictionary)
}
class CompanyListController: UITableViewController,scanDelegate {
    
    var companyList = Array<NSDictionary>()
    var lastPath = Int()
    weak var delegate: companyListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back.png"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "barcode.png"), style: .plain, target: self, action: #selector(barcode))
        
        self.title = "选择单位"
        self.tableView.tableFooterView = UIView()
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        lastPath = 0
        companyList = General.user.array(forKey: General.companyList) as! [NSDictionary]
        
        let ip = (UIApplication.shared.delegate as! AppDelegate).userInfo.companyIP
        for i in 0 ..< companyList.count {
            if companyList[i]["egAddress"] as! String == ip {
                lastPath = i
                tableView.reloadData()
            }
        }
    }

    @objc func back() {
        if delegate != nil {
            delegate?.getCompany(dic: companyList[lastPath])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func barcode() {
        let scanController = ScanController()
        scanController.delegate = self
        self.navigationController?.pushViewController(scanController, animated: true)
    }
    
    func scan(scan: String) {
        if !scan.isEmpty {
            let str = scan.replacingOccurrences(of: "'", with: "\"")
            if let data = str.data(using: String.Encoding.utf8) {
                do {
                    var dic = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)])as? [String:AnyObject]
                    var index = true
                    for i in 0 ..< companyList.count {
                        if dic!["egAddress"] as! String == companyList[i]["egAddress"] as! String {
                            index = false
                        }
                    }
                    if index {
                        dic!["account"] = "" as AnyObject
                        dic!["password"] = "" as AnyObject
                        companyList.append(dic! as NSDictionary)
                        tableView.reloadData()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = companyList[indexPath.row]["egName"] as? String
        if indexPath.row == lastPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        lastPath = indexPath.row
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
