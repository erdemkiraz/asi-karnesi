//
//  FriendDetailVaccine.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

struct FriendDetailVaccine: View {
    
    var customBlue = Color.init(red: 144.0/255.0, green: 163.0/255.0, blue: 184.0/255.0)
    var data : FriendsVaccinesDetailModel
    @ObservedObject var viewModel : FriendsViewModel
    @State var name = ""
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing:  15){
                VStack(alignment: .leading, spacing:0){
                    Text("Aşı Merkezi")
                        .foregroundColor(customBlue)
                        .font(.system(size: 14, weight: .regular, design: .default))
                    Text(data.vaccine_point)
                        .font(.system(size: 26, weight: .bold, design: .default))
                }
                Divider()
                VStack(alignment: .leading, spacing:0){
                    Text("Aşı Tarihi")
                        .foregroundColor(customBlue)
                        .font(.system(size: 14, weight: .regular, design: .default))
                    Text(data.date)
                        .font(.system(size: 26, weight: .bold, design: .default))
                }
                Divider()
                VStack(alignment: .leading, spacing:0){
                    Text("Aşı Dozu")
                        .foregroundColor(customBlue)
                        .font(.system(size: 14, weight: .regular, design: .default))
                    Text("\(data.dose)")
                        .font(.system(size: 26, weight: .bold, design: .default))
                }
                Divider()
                VStack(alignment: .leading, spacing:0){
                    Text("Aşı Geçerlilik Süresi")
                        .foregroundColor(customBlue)
                        .font(.system(size: 14, weight: .regular, design: .default))
                    Text("\(data.valid_until)")
                        .font(.system(size: 26, weight: .bold, design: .default))
                }
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.top, 20)
            .onAppear(perform: {
                self.name = data.name
            })
        }
        .navigationTitle(self.name)
    }
}
