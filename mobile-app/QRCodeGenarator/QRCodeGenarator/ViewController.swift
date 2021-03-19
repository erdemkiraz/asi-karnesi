//
//  ViewController.swift
//  QRCodeGenarator
//
//  Created by Elif Basak  Yildirim on 3.03.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField! //ismini alıyorum
    
    @IBOutlet weak var qrimageView: UIImageView! //QR ın uretildiği alan
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func generateAction(_ sender: Any) { //generate tıklanıncanolan kısım
        
        let myName = nameText.text //girilen ismi ve date'i combine ediyor
        if let name = myName{
            let combinedString = "\(name)\n\(Date())"
            qrimageView.image = generateQRCode(Name: combinedString)
        }
    }
    func generateQRCode(Name:String)-> UIImage?{ //QR generate eden fonksiyon, CIFilter sınıfını kullandık, key value pairlerini ayarlayarak CIfilter nesnesine parametreleri atayabiliyoruz ve  CIQRCodeGenerator kullanarak QR generate ettik.
        let name_data = Name.data(using:String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(name_data, forKey:"inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by:transform){
                return UIImage(ciImage:output)
            }
        }
        return nil
    }
}

