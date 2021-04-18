//
//  ScannedVaccinesView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 17.04.2021.
//

import SwiftUI

struct ScannedVaccinesView: View {
    
    @ObservedObject var viewModel : ScannerViewModel
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        
                        /// ViewModel içerisindeki GET ile aldığımız datayı vaccineModel dizisinden çekiyoruz ve data isimli değişkene koyuyoruz.
                        ForEach(self.viewModel.data, id: \.self){ data in
                            /// DetailedMyVaccinesView seçilen row'un değerlerini almak için data değişkenine bağlıyoruz.
                            NavigationLink(destination: ScannedDetailedVacinesView(data: data)) {
                                VStack(alignment: .leading){
                                    Text(data.name)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.primary)
                                    Divider()
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                            }
                        }
                        
                        
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 25)
                }
            }
        }
        .navigationBarTitle("Detaylar")
    }
}
