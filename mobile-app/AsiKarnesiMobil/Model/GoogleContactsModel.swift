//
//  GoogleContactsModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import Foundation
import Combine

struct GoogleContactsModel: Decodable {
    var auth_url: String
    var status: Int
    var is_auth: Bool
    var friends: [DetailedGoogleContactsModel]
}
struct DetailedGoogleContactsModel: Decodable, Hashable {
    var email, name, phone: String
    var is_user: Bool
}
