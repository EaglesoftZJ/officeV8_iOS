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
import MJRefresh

class WebController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    let wkWebView = WKWebView()
    var bridge = WebViewJavascriptBridge()
    var tabbarFrame = CGRect()
    let app = UIApplication.shared.delegate as! AppDelegate
    var isMain = Bool()
    var isReload = false
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = General.haveBar()
        view.backgroundColor = .white
        self.automaticallyAdjustsScrollViewInsets = false
        tabbarFrame = (self.tabBarController?.tabBar.frame)!
        
        createWKweb()
    }
    
    func createWKweb() {
//        wkWebView.frame = General.haveBar()
        wkWebView.frame = view.bounds
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        
        header.setRefreshingTarget(self, refreshingAction: #selector(webRefresh))
        wkWebView.scrollView.mj_header = header
        
//        let htmlPath = "http://192.168.31.197:8086/m/main"
        let htmlPath = app.userInfo.companyIP + "/mobile.html?isFrom=0"
        wkWebView.load(URLRequest.init(url:URL.init(string: htmlPath)!))
        
        WebViewJavascriptBridge.enableLogging()
        bridge = WebViewJavascriptBridge.init(forWebView: wkWebView)
        bridge.setWebViewDelegate(self)
        bridge.disableJavscriptAlertBoxSafetyTimeout()

        bridge.registerHandler("moa.zh") { (data, responseCallback) in
            responseCallback!(General.user.object(forKey: General().info))
        }
        
        bridge.registerHandler("moa.fj") { (data, responseCallback) in
            let fjlj = self.app.userInfo.companyIP + (data as! String).replacingOccurrences(of: "", with: "\"")
            let fj = FjController()
            fj.fjlj = fjlj
            self.navigationController?.pushViewController(fj, animated: true)
            self.hidesBottomBarWhenPushed = true
            responseCallback!(nil)
        }
        
        bridge.registerHandler("moa.tokenOut") { (data, responseCallback) in
            General.user.set(false, forKey: General().isLogin)
            let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
            let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = .clear
            }
            General().noti.post(name: General().switchRootController, object: nil, userInfo: ["vc": "Login"])
            responseCallback!(nil)
        }
        
        bridge.registerHandler("moa.isMain") { (data, responseCallback) in
            self.isMain = (data as! String == "isMain") ? true : false
            self.tabBarController?.tabBar.isHidden = !self.isMain
            self.tabBarController?.tabBar.frame = self.isMain ? self.tabbarFrame : .zero;
            //            self.wkWebView.frame = isMain ? General.haveBar() : General.noBar()
            self.view.frame = self.isMain ? General.haveBar() : General.noBar()
            self.wkWebView.frame = self.view.bounds
            self.wkWebView.scrollView.bounces = self.isMain
            self.wkWebView.scrollView.bouncesZoom = self.isMain
            responseCallback!(nil)
        }
        
        view.addSubview(wkWebView)
        
        view.showToast()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideToast()
    }
    
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.hideToast()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        self.alertUser(message) {
            completionHandler()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let tel = navigationAction.request.url?.scheme
        if tel == "tel" {
            DispatchQueue.main.async {
                UIApplication.shared.openURL(navigationAction.request.url!)
                decisionHandler(WKNavigationActionPolicy.cancel)
            }
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    @objc func webRefresh() {
        let htmlPath = app.userInfo.companyIP + "/mobile.html?isFrom=0"
        wkWebView.load(URLRequest.init(url:URL.init(string: htmlPath)!))
        wkWebView.scrollView.mj_header.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController?.isNavigationBarHidden != true {
            wkWebView.frame = General.noBar()
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.navigationController?.isNavigationBarHidden != false {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}
