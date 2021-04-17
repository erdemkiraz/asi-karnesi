//
//  SelectVaccinesView.swift
//  AsiKarnesiMobil
//
//  Created by  Elif Basak  Yildirim on 8.04.2021.
//

import SwiftUI

struct SelectVaccinesView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var myVaccinesViewModel : MyVaccinesViewModel
    @ObservedObject var viewModel : QrGenerateViewModel
    
    @State var selectedVaccines = []
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Aşı Seçme")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                    Spacer()
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26, weight: .bold, design: .default))
                            .foregroundColor(Color.primary)
                    }
                }
                .padding(.horizontal,15)
                .padding(.vertical,10)

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(self.myVaccinesViewModel.vaccineModel, id: \.self){ data in
                            SelectedRow(viewModel: viewModel, selectedVaccines: $selectedVaccines, name: data.name, id: data.vaccination_id)
                            
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.top, 25)
                }
                
                Spacer()
            }
            VStack{
                Spacer()
                Button {
                    self.viewModel.selectedVaccines = self.selectedVaccines
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Kaydet")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 25)
                        .background(Color.purple.cornerRadius(15))
                        .padding(.bottom, 15)
                }

            }
        }
    }
}

struct SelectedRow: View {
    @ObservedObject var viewModel : QrGenerateViewModel
    
    @Binding var selectedVaccines : Array<Any>
    
    @State var selected = false
    
    var name : String
    var id : Int
    
    /// Hangi aşıların seçildiğini veya kaldırıldığını anlamak için olan fonksyion.
    func find(value searchValue: Int, in array: [Any]) -> Int?{
        for (index, value) in array.enumerated(){
            if value as! Int == searchValue {
                return index
            }
        }
        return nil
    }
    
    var body: some View{
        VStack(alignment: .leading){
            
            Button {
                if find(value: id, in: self.selectedVaccines ) == nil {
                    self.selectedVaccines.append(id)
                    self.selected = true
                } else {
                    let index = find(value: id, in: self.selectedVaccines)
                    self.selectedVaccines.remove(at: index!)
                    self.selected = false
                }
                
                
            } label: {
                HStack{
                    Text(name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                    Spacer()
                    
                    Image(systemName: self.selected ? "circle.fill" : "circle")
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .foregroundColor(Color.primary)
                }
                
            }
            Divider()
        }
        .frame(maxWidth: UIScreen.main.bounds.width, alignment: .leading)
    }
}
