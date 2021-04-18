//
//  DetailedFriendView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

struct DetailedFriendView: View {
    
    var data : FriendsDetailedVaccineModel
    @ObservedObject var viewModel : FriendsViewModel
    @State var name = ""
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(self.data.vaccines, id: \.self){data in
                            NavigationLink(destination: FriendDetailVaccine(data: data, viewModel: viewModel)) {
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
        .onAppear(perform: {
            self.name = self.data.name
        })
        .navigationTitle(self.name)
    }
}

