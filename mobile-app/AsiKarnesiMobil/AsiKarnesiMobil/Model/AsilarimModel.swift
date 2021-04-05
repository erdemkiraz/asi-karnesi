//
//  AsilarimModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import Foundation
import Combine
import UIKit
import SwiftUI

//struct VaccineModel: Decodable, Identifiable {
//
//    var id = UUID()
//    var my_vaccines: String
//
//    enum CodingKeys: String, CodingKey {
//        case my_vaccines = "my_vaccines"
//
//    }
//}

struct DetailedVaccineModel: Codable, Identifiable {
    public var id : Int
    public var name: String
    public var date: String
    public var dose: String
    public var vaccine_point: String
    public var expires_in: String
}

/*struct AsilarimModel: Codable, Identifiable {
    
    public var id : Int
    public var name: String
    public var date: String
    public var dose: String
    public var vaccine_point: String
    public var expires_in: String
    
    
}*/
