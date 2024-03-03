//
//  RenameCategoryView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/18/23.
//

import SwiftUI


struct RenameCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataManager: DataManager
    @State private var newName: String = ""
    var category: Category

    var body: some View {
        VStack {
            TextField("New Category Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Rename") {
                dataManager.updateCategory(category: category, newName: newName)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .navigationBarTitle("Rename Category")
    }
}

//struct RenameCategoryView: View {
//    @EnvironmentObject private var dataManager: DataManager
//    @Environment(\.presentationMode) var presentationMode
//    @State private var newName = ""
//    var category: Category
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Rename Category")) {
//                    TextField("New Name", text: $newName)
//                }
//            }
//            .navigationTitle("Rename Category")
//            .navigationBarItems(trailing: Button("Save") {
//                if !newName.isEmpty {
//                    dataManager.updateCategory(category: category, newName: newName)
//                    presentationMode.wrappedValue.dismiss()
//                }
//            })
//        }
//    }
//}

//struct RenameCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        RenameCategoryView()
//        
//    }
//}
