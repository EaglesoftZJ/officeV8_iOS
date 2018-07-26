//
//  WebController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/22.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge
import MBProgressHUD

class WebController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    let wkWebView = WKWebView()
    var bridge = WebViewJavascriptBridge()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createWKweb()
    }
    
    func createWKweb() {
        wkWebView.frame = General.haveBar()
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        view.addSubview(wkWebView)
        
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "iOS")
        
        let htmlPath = "http://127.0.0.1:8086/m/main"
        view.showToast()
        wkWebView.load(URLRequest.init(url:URL.init(string: htmlPath)!))
        
        WebViewJavascriptBridge.enableLogging()
        bridge = WebViewJavascriptBridge.init(forWebView: wkWebView)
        bridge.setWebViewDelegate(self)
        bridge.disableJavscriptAlertBoxSafetyTimeout()
        bridge.registerHandler("moa.zh") { (data, responseCallback) in
            responseCallback!(General.user.object(forKey: General().info))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideToast()
        bridge.registerHandler("moa.isMain") { (data, responseCallback) in
            let isMain:Bool = (data as! String == "isMain") ? true : false
            self.tabBarController?.tabBar.isHidden = !isMain
            self.wkWebView.frame = isMain ? General.haveBar() : General.noBar()
            responseCallback!(nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.hideToast()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = General().tabbarColor
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
