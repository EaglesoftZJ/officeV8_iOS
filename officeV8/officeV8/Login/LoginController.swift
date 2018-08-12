//
//  LoginController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/22.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
import Masonry

class LoginController: UIViewController, UITextFieldDelegate,companyListDelegate {

    let backgroundImgView = UIImageView()
    let loginBtn = UIButton()
    let userField = UITextField()
    let pwdField = UITextField()
    let companyBtn = UIButton()
    let companyLabel = UILabel()
    var company = NSDictionary()
    let checkRemind = UIButton()
    var isChecked = false
    
    let appStyle = General()
    var app = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        
        app = UIApplication.shared.delegate as! AppDelegate
        
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        companyBtn.addTarget(self, action: #selector(chooseCompany), for: .touchUpInside)
        
        getIpAndName()
    }
    
    @objc func loginAction() {
        let userDefault = UserDefaults.standard
        
        let user = userField.text?.count
        let pass = pwdField.text?.count
        
        if user == 0 {
            self.alertUser("用户名不能为空")
            return
        }
        if pass == 0 {
            self.alertUser("密码不能为空")
            return
        }
        
        view.showToast()
        
        NetManager.login_ajax(user: userField.text!, pass: pwdField.text!, callBack: { (res) in
            
            self.view.hideToast()
            
            General.user.set(true, forKey: General().isLogin)
            userDefault.set(res, forKey: self.appStyle.info)
            
            let dic = ["egName": self.app.userInfo.companyName, "egAddress": self.app.userInfo.companyIP, "account": self.userField.text!, "password": self.pwdField.text!, "check": self.isChecked] as [String : Any]
            userDefault.set(dic, forKey: General.chooseCompany)
            
            self.getAccountAndPassword(dic: dic as NSDictionary)
            
            var arr = userDefault.array(forKey: General.companyList)
            let arrLen:Int = (arr?.count)!
            var index = -1
            for i in 0 ..< arrLen {
                let ip = (arr![i] as! NSDictionary)["egAddress"] as! String
                if ip == self.app.userInfo.companyIP {
                    index = i
                }
            }
            if index == -1 {
                arr?.append(dic)
            } else {
                arr![index] = dic
            }
            userDefault.set(arr, forKey: General.companyList)
            
            self.appStyle.noti.post(name: self.appStyle.switchRootController, object: nil, userInfo: ["vc": "Main"])
        }) { (err) in
            self.view.hideToast()
            self.alertUser(err!)
        }
    }
    
    @objc func chooseCompany() {
        let companyListController = CompanyListController()
        companyListController.delegate = self
        let navi:NaviController = NaviController(rootViewController: companyListController)
        self.present(navi, animated: true, completion: nil)
    }
    
    func getCompany(dic: NSDictionary) {
        companyLabel.text = dic["egName"] as? String
        userField.text = dic["account"] as? String
        pwdField.text = dic["password"] as? String
        
        company = dic
        
        getAccountAndPassword(dic: dic)
    }
    func getAccountAndPassword(dic: NSDictionary) {
        app.userInfo.companyIP = dic["egAddress"] as! String
        app.userInfo.companyName = dic["egName"] as! String
        app.userInfo.account = dic["account"] as! String
        app.userInfo.password = dic["password"] as! String
    }
    
    func getIpAndName() {
        companyLabel.text = app.userInfo.companyName
        userField.text = app.userInfo.account
        pwdField.text = app.userInfo.password
        
        let dic = General.user.dictionary(forKey: General.chooseCompany)
        isChecked = dic!["check"] as! Bool
        checkRemind.isSelected = isChecked
        checkRemind.setImage(isChecked ? UIImage.init(named: "记住") : UIImage.init(named: "不记住"), for: .normal)
        if isChecked {
            loginAction()
        }
    }

    @objc func checkAutoLogin(button:UIButton){
        button.isSelected = !button.isSelected
        isChecked = button.isSelected ? true : false
        button.setImage(button.isSelected ? UIImage.init(named: "记住") : UIImage.init(named: "不记住"), for: .normal)
    }
    
    func setView() {
        view.addSubview(backgroundImgView)
        view.addSubview(loginBtn)
        view.addSubview(userField)
        view.addSubview(pwdField)
        view.addSubview(companyLabel)
        view.addSubview(companyBtn)
        view.addSubview(checkRemind)
        
        backgroundImgView.image = UIImage.init(named: "backgroundImg.jpg")
        backgroundImgView.frame = view.frame;
        
        let userImgView = UIImageView(image: UIImage.init(named: "用户名.png"))
        userImgView.frame = CGRect(x:appStyle.kScaleW(w: 90),y:appStyle.kScaleH(h: 540),width:appStyle.kScaleW(w: 30),height:appStyle.kScaleH(h: 30))
        view.addSubview(userImgView)
        
        userField.frame = CGRect(x:appStyle.kScaleW(w: 145),y:appStyle.kScaleH(h: 500),width:appStyle.kScaleW(w: 515),height:appStyle.kScaleH(h: 108))
        userField.placeholder = "用户名"
        userField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        userField.keyboardType = .default
        
        let pwdImgView = UIImageView(image: UIImage.init(named: "密码.png"))
        pwdImgView.frame = CGRect(x:appStyle.kScaleW(w: 90),y:appStyle.kScaleH(h: 648),width:appStyle.kScaleW(w: 30),height:appStyle.kScaleH(h: 30))
        view.addSubview(pwdImgView)
        
        pwdField.frame = CGRect(x:appStyle.kScaleW(w: 145),y:appStyle.kScaleH(h: 608),width:appStyle.kScaleW(w: 515),height:appStyle.kScaleH(h: 108))
        pwdField.placeholder = "密码"
        pwdField.isSecureTextEntry = true
        pwdField.clearButtonMode = UITextFieldViewMode.whileEditing
        pwdField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        
        let companyImgview = UIImageView(image: UIImage.init(named: "选择公司"))
        companyImgview.frame = CGRect(x:appStyle.kScaleW(w: 90),y:appStyle.kScaleH(h: 756),width:appStyle.kScaleW(w: 30),height:appStyle.kScaleH(h: 30))
        view.addSubview(companyImgview)
        
        companyLabel.textColor = UIColor.white
        companyLabel.font = UIFont.systemFont(ofSize: 16)
        companyLabel.frame = CGRect(x:appStyle.kScaleW(w: 145),y:appStyle.kScaleH(h: 716),width:appStyle.kScaleW(w: 465),height:appStyle.kScaleH(h: 108))
        
        companyBtn.setImage(UIImage.init(named: "选择"), for: .normal)
        companyBtn.frame = CGRect(x:appStyle.kScaleW(w: 610),y:appStyle.kScaleH(h: 756),width:appStyle.kScaleW(w: 30),height:appStyle.kScaleH(h: 30))
        
        createLine(h: 608)
        createLine(h: 716)
        createLine(h: 824)
        
        checkRemind.frame = CGRect(x:appStyle.kScaleW(w: 50),y:appStyle.kScaleH(h: 864),width:appStyle.kScaleW(w: 280),height:appStyle.kScaleH(h: 30))
        checkRemind.setImage(UIImage.init(named: "不记住"), for: .normal)
        checkRemind.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        checkRemind.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        checkRemind.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        checkRemind.setTitle("自动登录", for: .normal)
        checkRemind.setTitleColor(UIColor.white, for: .normal)
        checkRemind.addTarget(self, action: #selector(checkAutoLogin(button:)), for: .touchUpInside)
        
        loginBtn.mas_makeConstraints { (make:MASConstraintMaker!) in
            make.bottom.mas_equalTo()(view.mas_bottom)?.setOffset(appStyle.kScaleH(h: -255))
            make.left.mas_equalTo()(appStyle.kScaleW(w: 98))
            make.width.mas_equalTo()(appStyle.kScaleW(w: 553))
            make.height.mas_equalTo()(appStyle.kScaleH(h: 105))
        }
        loginBtn.setBackgroundImage(UIImage.init(named: "loginBackground"), for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    func createLine(h:CGFloat) {
        let line = UIView(frame:CGRect(x:appStyle.kScaleW(w: 90),y:appStyle.kScaleH(h: h),width:appStyle.kScaleW(w: 570),height:1))
        line.backgroundColor = UIColor.white
        view.addSubview(line)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
