//
//  ScannedDetailedVacinesView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import SwiftUI

struct ScannedDetailedVacinesView: View {
    
    var data : DetailedQrVaccinesModel
    
    var body: some View {
        ZStack{
            VStack{
                DetailedVaccinesRow(date: data.date, dose: data.dose, name: data.name, vaccination_id: data.vaccination_id, vaccine_id: data.vaccine_id, vaccine_point: data.vaccine_point, valid_until: data.valid_until)
            }
        }
        .navigationTitle("Aşı Bilgisi")
    }
}

