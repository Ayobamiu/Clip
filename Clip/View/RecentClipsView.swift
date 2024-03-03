//
//  RecentClipsView.swift
//  Clip
//
//  Created by Usman Ayobami on 8/5/23.
//


import SwiftUI

struct RecentClipsView: View {
    @EnvironmentObject private var dataManager: DataManager // Inject DataManager
    @State private var isShowingDataForm: Bool = false
    @State private var searchText: String = ""
    
    
    var body: some View {
        List {
            ForEach(filteredItems) { item in
                DataRowItemView(item: item)
                    .onTapGesture {
                        isShowingDataForm = true
                    }
                    .contextMenu {
                        // ... Other context menu options here ...
                        Button(action: {
                            DataManager.shared.deleteItem(item: item)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Recent Clips")
        .navigationBarItems(trailing:
                                Button(action: {
            isShowingDataForm = true
        }) {
            Image(systemName: "plus")
        }
            .sheet(isPresented: $isShowingDataForm) {
                AddAndUpdateDataView()
            }
        )
        .searchable(text: $searchText)
        Section(header: Text("\(filteredItems.count) items")) {
            EmptyView() // Empty view as section body, header will show the count
        }
    }
    
    // ... Other code remains the same ...
    
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return DataManager.shared.recentItems
        } else {
            return DataManager.shared.fetchItems(with: searchText)
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { filteredItems[$0] }.forEach { item in
                DataManager.shared.deleteItem(item: item)
            }
        }
    }
}


struct RecentClipsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecentClipsView()
        }
    }
}
