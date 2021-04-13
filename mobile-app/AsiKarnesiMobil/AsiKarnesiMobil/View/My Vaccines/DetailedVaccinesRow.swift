//
//  DetailedVaccinesRow.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI

struct DetailedVaccinesRow: View {
    
    var customBlue = Color.init(red: 144.0/255.0, green: 163.0/255.0, blue: 184.0/255.0)
    
    var date: String
    var dose: Int
    var name: String
    var vaccination_id: Int
    var vaccine_id: Int
    var vaccine_point: String
    var valid_until: String
    
    var body: some View {
        VStack(alignment: .leading, spacing:  15){
            VStack(alignment: .leading, spacing:0){
                Text("Aşı İsmi")
                    .foregroundColor(customBlue)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text(name)
                    .font(.system(size: 26, weight: .bold, design: .default))
            }
            Divider()
            VStack(alignment: .leading, spacing:0){
                Text("Aşı Merkezi")
                    .foregroundColor(customBlue)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text(vaccine_point)
                    .font(.system(size: 26, weight: .bold, design: .default))
            }
            Divider()
            VStack(alignment: .leading, spacing:0){
                Text("Aşı Tarihi")
                    .foregroundColor(customBlue)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text(date)
                    .font(.system(size: 26, weight: .bold, design: .default))
            }
            Divider()
            VStack(alignment: .leading, spacing:0){
                Text("Aşı Dozu")
                    .foregroundColor(customBlue)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text("\(dose)")
                    .font(.system(size: 26, weight: .bold, design: .default))
            }
            Divider()
            VStack(alignment: .leading, spacing:0){
                Text("Aşı Geçerlilik Süresi")
                    .foregroundColor(customBlue)
                    .font(.system(size: 14, weight: .regular, design: .default))
                Text("\(valid_until)")
                    .font(.system(size: 26, weight: .bold, design: .default))
            }
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
        .padding(.horizontal, 15)
        .padding(.top, 20)
    }
}

