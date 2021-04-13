//
//  AsilarimView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI

struct AsilarimView: View {
    
    /// Gerekli ViewModel'leri bağlama
    @ObservedObject var homeViewModel : HomeViewModel
    @ObservedObject var viewModel : MyVaccinesViewModel
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        
                        /// ViewModel içerisindeki GET ile aldığımız datayı vaccineModel dizisinden çekiyoruz ve data isimli değişkene koyuyoruz.
                        ForEach(self.viewModel.vaccineModel, id: \.self){ data in
                            
                            /// DetailedMyVaccinesView seçilen row'un değerlerini almak için data değişkenine bağlıyoruz.
                            NavigationLink(destination: DetailedMyVaccinesView(data: data, viewModel: viewModel)) {
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
        .navigationBarTitle("Aşılarım")
    }
}

struct AsilarimView_Previews: PreviewProvider {
    static var previews: some View {
        AsilarimView(homeViewModel: HomeViewModel(), viewModel: MyVaccinesViewModel())
    }
}
