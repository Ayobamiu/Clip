//
//  CategoriesView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/17/23.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var isShowingAddCategorySheet = false
    @State private var selectedCategory: Category?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.fetchAllCategories(), id: \.self) { category in
                    NavigationLink(destination: CategoryPageView(category: category)) {
                        Text(category.name ?? "")
                    }
                }
                .onDelete(perform: deleteCategories)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddCategorySheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddCategorySheet) {
                AddCategoryView()
                    .environmentObject(dataManager)
            }
        }
    }
    
    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let category = dataManager.fetchAllCategories()[index]
                dataManager.deleteCategory(category: category)
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

