//
//  FoldersView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/5/23.
//

import SwiftUI

struct FoldersView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var isShowingDataForm: Bool = false
    @State private var isShowingAddCategorySheet = false
    @State private var isShowingAccountSheet = false
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ContentView()) {
                    RowItemView(icon: "doc", title: "All Clips")
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: RecentClipsView()) {
                    RowItemView(icon: "clock", title: "Recent Clips")
                }
                .buttonStyle(PlainButtonStyle())
                
                Section() {
                    ForEach(dataManager.fetchAllCategories(), id: \.self) { category in
                        NavigationLink(destination: CategoryPageView(category: category)) {
                            RowItemView(icon: "folder", title:category.name ?? "Uncategorized")
                        }.swipeActions(edge: .leading) {
                            Button(action: {
                                // Show an alert to rename the category
                                dataManager.showRenameCategoryAlert(category: category)
                            }) {
                                Text("Edit")
                            }
                            .tint(.blue)
                        }
                    }.onDelete(perform: deleteCategories)
                    
                }
            }
            .navigationTitle("Clips")
            .navigationBarItems(trailing:
                                    Button(action: {
                isShowingDataForm = true
            }) {
                Image(systemName: "plus")
            }
                .sheet(isPresented: $isShowingDataForm) {
                    AddAndUpdateDataView()
                }
                .sheet(isPresented: $isShowingAddCategorySheet) {
                    AddCategoryView()
                        .environmentObject(dataManager)
                }
            )
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        isShowingAddCategorySheet = true
                    }) {
                        Image(systemName: "folder.badge.plus")
                    }
                }
                
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

struct FoldersView_Previews: PreviewProvider {
    static var previews: some View {
        FoldersView()
    }
}

