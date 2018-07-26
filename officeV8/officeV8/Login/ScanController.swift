//
//  ScanController.swift
//  officeV8
//
//  Created by dingjinming on 2018/7/26.
//  Copyright © 2018年 egsoft. All rights reserved.
//

import UIKit
protocol scanDelegate: NSObjectProtocol {
    func scan(scan: String)
}
class ScanController: UIViewController,SGQRCodeManagerDelegate {
    
    var scanningView = SGQRCodeScanningView()
    weak var delegate: scanDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "扫描二维码"
        view.backgroundColor = .white
        
        scanningView = SGQRCodeScanningView.init(frame: view.frame, layer: view.layer)
        view.addSubview(scanningView)
        
        let manager = SGQRCodeManager.shared()
        manager?.currentVC = self
        let arr = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128]
        manager?.sg_setupSessionPreset(AVCaptureSession.Preset.hd1920x1080.rawValue, metadataObjectTypes: arr)
        manager?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scanningView.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanningView.removeTimer()
    }
    
    func qrCodeManager(_ QRCodeManager: SGQRCodeManager!, didOutputMetadataObjects metadataObjects: [Any]!) {
        if metadataObjects != nil && metadataObjects.count > 0 {
            QRCodeManager.sg_palySoundName("SGQRCode.bundle/sound.caf")
            QRCodeManager.sg_stopRunning()
            QRCodeManager.sg_videoPreviewLayerRemoveFromSuperlayer()
            
            let scanString:String = (metadataObjects[0] as AnyObject).stringValue
            if scanString.contains("egName") && scanString.contains("egAddress") {
                if delegate != nil {
                    delegate?.scan(scan: scanString)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.alertUser("未识别出扫描的二维码")
            }
        } else {
            self.alertUser("未识别出扫描的二维码")
        }
    }
    
    func qrCodeManagerDidCancel(withImagePickerController QRCodeManager: SGQRCodeManager!) {
        
    }
    
    func qrCodeManager(_ QRCodeManager: SGQRCodeManager!, didFinishPickingMediaWithResult result: String!) {
        
    }

}
