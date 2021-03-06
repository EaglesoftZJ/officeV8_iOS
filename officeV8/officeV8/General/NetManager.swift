//
//  NetManager.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/24.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
import Alamofire

class NetManager: NSObject {
    
    class func eg_ajax(URL urlString: String, parameters param: [String: Any]? = nil, callBack: @escaping (_ responseObject:Any?)->(), failBack: @escaping (_ responseObject:Any?)->()) {
        let companyIP:String = AppDelegate().userInfo.companyIP + urlString
        Alamofire.request(companyIP, method: .post, parameters: param).responseJSON { (response) in
            guard let result = response.result.value else {
                failBack("服务器连接失败")
                return
            }
            callBack(result)
        }
    }
    
    class func login_ajax(user username: String, pass password: String, callBack: @escaping (_ responseObject: NSDictionary?)->(), failBack: @escaping (_ responseObject: String?)->()) {
        let user_md5:String = ("ealgesoft_zaq1xsw2_cft6vgy7_"+username).md5()
        let pass_md5:String = ("ealgesoft_zaq1xsw2_cft6vgy7_"+password).md5()
        
        self.eg_ajax(URL: "/rest/phone/JcYhglManage/login", parameters: ["zh": user_md5, "mm": pass_md5], callBack: { (res) in
            if res != nil {
                let dic = res as! NSDictionary
                if dic["statusCode"] as! Int == 2 {
                    callBack(dic["data"] as? NSDictionary)
                } else {
                    failBack(dic["errorReason"] as? String)
                }
            }
        }) { (err) in
            failBack("服务器连接错误")
        }
    }
    
    class func saveInfo_ajax(yx: String, sj: String, dh: String, xnw: String, callBack: @escaping (_ responseObject: String?)->(), failBack: @escaping (_ responseObject: String?)->()) {
        let companyIP:String = AppDelegate().userInfo.companyIP + "/rest/JcYhglManage/modifyUserInfo"
        let info:NSDictionary = General.user.object(forKey: General().info) as! NSDictionary
        let token = (info["tokenObj"] as! NSDictionary)["token"] as! String
        Alamofire.request(companyIP, method: .post, parameters: ["email": yx, "phone": sj, "tel": dh, "xnw": xnw], encoding: JSONEncoding.default, headers: ["X-Auth-Token": token]).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (response) in
            guard let result = response.result.value else {
                failBack("error")
                return
            }
            let dic = result as! NSDictionary
            if dic["statusCode"] as! Int == 2 {
                callBack("成功")
            } else {
                failBack(dic["errorReason"] as? String)
            }
        }
    }
}

extension String {
    func md5() ->String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
        
    }
}
