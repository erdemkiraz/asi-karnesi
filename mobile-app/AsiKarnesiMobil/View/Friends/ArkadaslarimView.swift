//
//  ArkadaslarimView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 5.04.2021.
//

import SwiftUI

struct ArkadaslarimView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    @ObservedObject var viewModel : FriendsViewModel
    @ObservedObject var requestModel : FriendRequestViewModel
    
    @State var show = false
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        if self.viewModel.vaccineModel.isEmpty {
                            HStack{
                                Text("Hiç bir arkadaşın aşı bilgisini paylaşmıyor.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 11, weight: .medium, design: .default))
                            }
                            .frame(maxWidth: UIScreen.main.bounds.width, alignment: .center)
                        } else{
                            /// ViewModel içerisindeki GET ile aldığımız datayı vaccineModel dizisinden çekiyoruz ve data isimli değişkene koyuyoruz.
                            ForEach(self.viewModel.vaccineModel, id: \.self){ data in
                                
                                /// DetailedFriendView seçilen row'un değerlerini almak için data değişkenine bağlıyoruz.
                                NavigationLink(destination: DetailedFriendView(data: data, viewModel: viewModel)) {
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
                        
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 25)
                }
            }
        }
        /// Arkadaş Ekle butonu
        .navigationBarItems(trailing:
                                Button(action: {
                                    self.show = true
                                }, label: {
                                    Text("Arkadaş Ekle")
                                })
        )
        .navigationBarTitle("Arkadaşlar")
        .sheet(isPresented: $show){
            AddFriendsView(viewModel: requestModel)
        }
    }
}
