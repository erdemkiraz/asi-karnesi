//
//  FriendsVaccinesModel.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 8.04.2021.
//

import Foundation
import Combine

struct FriendsVaccineModel: Decodable {
    var friends : [FriendsDetailedVaccineModel]
}

struct FriendsDetailedVaccineModel: Decodable, Hashable {
    var name, id : String
    var age: Int
    var vaccines: [FriendsVaccinesDetailModel]
}

struct FriendsVaccinesDetailModel: Decodable, Hashable {
    var date, name, vaccine_point, valid_until: String
    var dose, vaccination_id, vaccine_id: Int
}
