//
//  EditController.swift
//  officeV8
//
//  Created by dingjinming on 2018/8/7.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
protocol editDelegate: NSObjectProtocol {
    func editXx(xxArr: [String])
}
class EditController: UIViewController {

    var xxArr = [String]()
    
    let yxField = UITextField()
    let sjField = UITextField()
    let dhField = UITextField()
    let xnwField = UITextField()
    
    let g = General()
    
    weak var delegate: editDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置"
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(save))
        
        setview()
        
    }
    
    @objc func save() {
        view.showToast()
        NetManager.saveInfo_ajax(yx: yxField.text!, sj: sjField.text!, dh: dhField.text!, xnw: xnwField.text!, callBack: { (str) in
            self.view.hideToast()
            if self.delegate != nil {
                self.delegate?.editXx(xxArr: [self.yxField.text!, self.sjField.text!, self.dhField.text!, self.xnwField.text!])
                self.navigationController?.popViewController(animated: true)
            }
        }) { (err) in
            self.view.hideToast()
            self.alertUser(err!)
        }
    }
    
    func setview() {
        let yxLabel = UILabel(frame: CGRect(x: g.kScaleW(w: 90), y: g.kScaleH(h: 100), width: g.kScaleW(w: 100), height: g.kScaleH(h: 30)))
        yxLabel.text = "邮箱"
        view.addSubview(yxLabel)
        let sjLabel = UILabel(frame: CGRect(x: g.kScaleW(w: 90), y: g.kScaleH(h: 200), width: g.kScaleW(w: 100), height: g.kScaleH(h: 30)))
        sjLabel.text = "手机"
        view.addSubview(sjLabel)
        let dhLabel = UILabel(frame: CGRect(x: g.kScaleW(w: 90), y: g.kScaleH(h: 300), width: g.kScaleW(w: 100), height: g.kScaleH(h: 30)))
        dhLabel.text = "电话"
        view.addSubview(dhLabel)
        let xnwLabel = UILabel(frame: CGRect(x: g.kScaleW(w: 90), y: g.kScaleH(h: 400), width: g.kScaleW(w: 100), height: g.kScaleH(h: 30)))
        xnwLabel.text = "虚拟网"
        view.addSubview(xnwLabel)
        
        yxField.frame = CGRect(x: g.kScaleW(w: 200), y: g.kScaleH(h: 80), width: g.kScaleW(w: 500), height: g.kScaleH(h: 70))
        yxField.borderAndPlaceholder(place: "请输入邮箱", text: xxArr[0])
        view.addSubview(yxField)
        
        sjField.frame = CGRect(x: g.kScaleW(w: 200), y: g.kScaleH(h: 180), width: g.kScaleW(w: 500), height: g.kScaleH(h: 70))
        sjField.borderAndPlaceholder(place: "请输入手机", text: xxArr[1])
        view.addSubview(sjField)
        
        dhField.frame = CGRect(x: g.kScaleW(w: 200), y: g.kScaleH(h: 280), width: g.kScaleW(w: 500), height: g.kScaleH(h: 70))
        view.addSubview(dhField)
        dhField.borderAndPlaceholder(place: "请输入电话", text: xxArr[2])
        xnwField.frame = CGRect(x: g.kScaleW(w: 200), y: g.kScaleH(h: 380), width: g.kScaleW(w: 500), height: g.kScaleH(h: 70))
        xnwField.borderAndPlaceholder(place: "请输入互联网", text: xxArr[3])
        view.addSubview(xnwField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
