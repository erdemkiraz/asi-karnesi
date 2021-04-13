//
//  VaccinesModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 7.04.2021.
//

import Foundation
import Combine

struct VaccineModel: Decodable {
    var my_vaccines: [DetailedVaccineModel]
}

struct DetailedVaccineModel: Decodable, Hashable {
    var date, name, vaccine_point, valid_until: String
    var dose, vaccination_id, vaccine_id: Int
}

struct DetailedVaccinePrivacyModel: Decodable, Hashable {
    var privacy_setting: Int
}
