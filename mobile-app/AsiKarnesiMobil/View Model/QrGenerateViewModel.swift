//
//  QrGenerateViewModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import Foundation
import CoreImage.CIFilterBuiltins
import UIKit

class QrGenerateViewModel: ObservableObject {
    
    @Published var selectedVaccines = []
    @Published var url = ""
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    /// QR POST
    func sendPostJSON(userID: String, completion: @escaping (Bool) -> Void){
        let params: [String: Any] = [
            "google_id": userID,
            "vaccination_ids": self.selectedVaccines
        ]
        guard let url = URL(string: "\(baseURL)/create-link") else {return}
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                let response = responseJSON
                let url = response["link"]
                self.url = url as! String
                completion(true)
            }
        }
        task.resume()
    }
    
    /// Generate QR
    func generateQRCode(from string: String) -> UIImage {
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}


