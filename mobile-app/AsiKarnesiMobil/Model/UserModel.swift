//
//  UserModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirime on 15.04.2021.
//

import Foundation
import Combine

struct UserModel: Decodable {
    var info : UserDetailedModel
    var status : Int
}

struct UserDetailedModel: Decodable, Hashable {
    var name, country_name, google_id : String
    var id: Int
    var age : Int?
    var vaccines: [UserVaccines]
}


struct UserVaccines: Decodable, Hashable {
    var date, name, vaccine_point, valid_until: String
    var dose, vaccination_id, vaccine_id: Int
}

