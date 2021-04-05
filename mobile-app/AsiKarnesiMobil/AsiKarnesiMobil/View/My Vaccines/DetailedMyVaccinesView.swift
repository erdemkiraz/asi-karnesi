//
//  DetailedMyVaccinesView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct DetailedMyVaccinesView: View {
    
    var data : DetailedVaccineModel
    
    @State var show = false
    
    var body: some View {
        ZStack{
            DetailedVaccinesRow(name: data.name, vaccinePoint: data.vaccine_point, date: data.date, dose: data.dose, expiresIn: data.expires_in)
            VStack{
                Spacer()
                Button {
                    self.show = true
                } label: {
                    Text("Aşı İzinlerini Düzenle")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(Color.green.cornerRadius(15))
                        .padding(.bottom, 15)
                }

            }
            .padding(.bottom, 15)
        }
        .navigationTitle("Aşı Bilgisi")
        .sheet(isPresented: $show){
            VaccinePermitsView()
        }
    }
}

struct VaccinePermitsView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            HStack{
                Text("Aşı İzinleri")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                Spacer()
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .foregroundColor(Color.primary)
                }

            }
            .padding(.horizontal,15)
            .padding(.vertical,10)
            
            
            
            Spacer()
        }
    }
}
