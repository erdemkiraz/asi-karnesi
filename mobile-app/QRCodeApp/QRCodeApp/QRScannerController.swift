//
//  QRScannerViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 26.02.2021.
//

import UIKit
import AVFoundation//qr scanner controller frameworkü import ettik .QR kod video yakalama demek aslında

class QRScannerController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var topBar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //arka kamera ile video yakalama için olan kısım
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // cihazın nesnesi aldık ve AVCaptureDeviceInput verdik
            let input = try AVCaptureDeviceInput(device: captureDevice)
           //capture session nesnesini veri akışını koordine etmek için kullanılıyorum
            captureSession.addInput(input)
            
            // AVCaptureMetadataOutput  nesnesini initialize ettik
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // default dispatch queue yu kullanıyorum captureMetadataOutput u set ediyorum
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // video preview layerı initialize  ettik ve bunu viewPreviewın alt layeri olarak ekledik.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //en boy ayarlanması
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // video capture baslatıldı
            captureSession.startRunning()
            
            
            view.bringSubviewToFront(messageLabel)
            view.bringSubviewToFront(topBar)
            
            // Initialize QR Code Frame
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.gray.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            
            print(error)
            return
        }
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate { //meta data üzerinde işlem yapıp QR kodu çevircez
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       
        // Eger  metadataObjects arrayinde eleman yoksa
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "QR bulunamadı"
            return
        }
        
        // metadata nesnesini aldık
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            //Bulunan meta verileri, QR kod meta verilerine eşitse,label durumunu güncelleyip  ve boundları set ettik
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
}
