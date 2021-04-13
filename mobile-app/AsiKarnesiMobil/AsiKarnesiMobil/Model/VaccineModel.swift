//
//  VaccineModel.swift
//  AsiKarnesiMobil
//
//  Created by Kerem Cesme on 5.04.2021.
//

import Foundation
import Combine
import UIKit
import SwiftUI

struct VaccineModel: Decodable {

    //var id = UUID()
    var my_vaccines: [DetailedVaccineModel]
    

    /*enum CodingKeys: String, CodingKey {
        case my_vaccines = "my_vaccines"

    }*/
}

struct DetailedVaccineModel: Decodable, Hashable {
    //var id = UUID().uuidString
    
    var date: String
    var dose: Int
    var name: String
    var vaccination_id: Int
    var vaccine_id: Int
    var vaccine_point: String
    var valid_until: String
}

struct VaccinePrivaacyModel: Decodable {
    
    var privacy_setting: Int
}
