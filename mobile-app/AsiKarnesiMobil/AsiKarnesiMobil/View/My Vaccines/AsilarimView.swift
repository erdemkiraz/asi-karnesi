//
//  AsilarimView.swift
//  AsiKarnesiMobil
//
//  Created by Elif Başak Yıldırım on 5.04.2021.
//

import SwiftUI

struct AsilarimView: View {
    
    @ObservedObject var homeViewModel : HomeViewModel
    @ObservedObject var viewModel : AsilarimViewModel
    
    var body: some View {
        ZStack{
            //NavigationLink("", destination: DetailedMyVaccinesView(), isActive: $viewModel.showDetails)
            VStack{
                List(self.viewModel.vaccineModel){data in
                    VStack{
                        NavigationLink(destination: DetailedMyVaccinesView(data: data)) {
                            Text(data.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Aşılarım")
    }
}

struct AsilarimView_Previews: PreviewProvider {
    static var previews: some View {
        AsilarimView(homeViewModel: HomeViewModel(), viewModel: AsilarimViewModel())
    }
}
