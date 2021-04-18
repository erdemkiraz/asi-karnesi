//
//  FriendsVaccinesModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import Foundation
import Combine

struct FriendsVaccineModel: Decodable {
    var friends : [FriendsDetailedVaccineModel]
    var status: Int
}

struct FriendsDetailedVaccineModel: Decodable, Hashable {
    var name, country_name, google_id, with_friends_since : String
    var id: Int
    var vaccines: [FriendsVaccinesDetailModel]
}

struct FriendsVaccinesDetailModel: Decodable, Hashable {
    var date, name, vaccine_point, valid_until: String
    var dose, vaccination_id, vaccine_id: Int
}
