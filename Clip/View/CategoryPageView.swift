//
//  CategoryPageView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/17/23.
//

import SwiftUI

struct CategoryPageView: View {
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) private var presentationMode
    let category: Category
    
    @State private var isShowingAddItemSheet = false
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            ForEach(dataManager.fetchItems(for: category, with: searchText), id: \.self) { item in
                DataRowItemView(item: item)
                    .contextMenu {
                        Button(action: {
                            DataManager.shared.deleteItem(item: item)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(category.name ?? "")
        .navigationBarItems(trailing:
            Button(action: {
                isShowingAddItemSheet = true
            }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $isShowingAddItemSheet) {
                AddAndUpdateDataView(category: category)
                    .environmentObject(dataManager)
            }
        )
        .searchable(text: $searchText)
        
        Section(header: Text("\(dataManager.fetchItems(for: category, with: searchText).count) items")) {
            EmptyView() // Empty view as section body, header will show the count
        }
    }
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return dataManager.fetchAllItems()
        } else {
            return dataManager.filterItems(with: searchText)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let item = dataManager.fetchItems(for: category, with: searchText)[index]
                dataManager.deleteItem(item: item)
            }
        }
    }
}

struct CategoryPageView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPageView(category: Category())
    }
}
