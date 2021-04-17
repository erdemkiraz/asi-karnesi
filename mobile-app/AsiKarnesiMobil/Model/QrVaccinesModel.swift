//
//  QrVaccinesModel.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import Foundation
import Combine

struct QrVaccinesModel: Decodable {
    var vaccinations : [DetailedQrVaccinesModel]
    var status: Int
}

struct DetailedQrVaccinesModel: Decodable, Hashable {
    var date, name, vaccine_point, valid_until: String
    var dose, vaccination_id, vaccine_id: Int
}
