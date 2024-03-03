//
//  AddCategoryView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/17/23.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var dataManager: DataManager
    @State private var categoryName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("Enter Category Name", text: $categoryName)
                }
            }
            .navigationTitle("Add Category")
            .navigationBarItems(leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing:
                Button(action: {
                    addCategory()
                }) {
                    Text("Done")
                }
                .disabled(categoryName.isEmpty)
            )
        }
    }
    
    private func addCategory() {
        guard !categoryName.isEmpty else {
            return
        }
        
        withAnimation {
            dataManager.createCategory(name: categoryName)
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
            .environmentObject(DataManager.shared)
    }
}
