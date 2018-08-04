//
//  FjController.swift
//  officeV8
//
//  Created by dingjinming on 2018/8/1.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class FjController: UIViewController,WKNavigationDelegate {

    let wkWebView = WKWebView()
    var fjlj = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "附件"
        
        view.backgroundColor = .white
        wkWebView.frame = view.frame
        view.showToast()
        down(fileName: fjlj)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        view.hideToast()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        view.hideToast()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.hideToast()
        self.alertUser(error.localizedDescription)
    }
    
    func down(fileName: String) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let paths = fileName.components(separatedBy: "/").last!.components(separatedBy: "?")
        let fileTip:String = paths.last!
        let file:String = paths[paths.count - 2]
        let fileURL = documentsURL.appendingPathComponent("fj/\(fileTip + file)")
        
        let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/fj"
        let fjPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/fj/\(fileTip + file)"
        if isFileExist(fileName: fjPath) {
            let urlStr = URL.init(fileURLWithPath: fjPath)
            self.wkWebView.loadFileURL(urlStr, allowingReadAccessTo: URL.init(fileURLWithPath: basePath))
            self.view.addSubview(self.wkWebView)
        } else {
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            Alamofire.download(fileName, to: destination).downloadProgress { (progress) in
                if progress.completedUnitCount == progress.totalUnitCount {}
                }.responseData { (response) in
                    DispatchQueue.main.async {
                        if let path = response.destinationURL?.path {
                            let urlStr = URL.init(fileURLWithPath:path)
                            self.wkWebView.loadFileURL(urlStr, allowingReadAccessTo: URL.init(fileURLWithPath: basePath))
                            self.view.addSubview(self.wkWebView)
                        }
                    }
                }
        }
    }
    
    func isFileExist(fileName: String) -> Bool {
        let fileManager:FileManager = FileManager.default
        let result:Bool = fileManager.fileExists(atPath: fileName)
        return result
    }

}
