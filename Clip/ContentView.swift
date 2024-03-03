//
//  ContentView.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isShowingAccountPage: Bool = false
    @StateObject private var dataManager = DataManager.shared
    @State private var searchText: String = ""
    @State private var selectedItem: Item?
    @State private var isShowingDataForm: Bool = false
    
    var body: some View {
        List {
            ForEach(filteredItems) { item in
                DataRowItemView(item: item)
                    .onTapGesture{
                        selectedItem = item
                    }
                    .contextMenu {
                        Button(action: {
                            // MARK: - COPY TO CLIPBOARD
                            UIPasteboard.general.string = item.textValue
                        }) {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                        
                        Button(action: {
                            shareItem(item)
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {
                            selectedItem = item
                            isShowingDataForm = true
                        }) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            selectedItem = item
                            isShowingDataForm = true
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                    }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("All Clips")
        .sheet(isPresented: $isShowingDataForm) {
            AddAndUpdateDataView(itemToUpdate: selectedItem, category:selectedItem?.category)
                .environmentObject(dataManager) // Inject DataManager as an environment object
        }
        .sheet(isPresented: $isShowingAccountPage) {
            Text("ayobamiu@gmail")
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    selectedItem = nil
                    isShowingDataForm = true
                }){
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .searchable(text: $searchText)
        Section(header: Text("\(filteredItems.count) items")) {
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
            offsets.map { filteredItems[$0] }.forEach { item in
                dataManager.deleteItem(item: item) // Use DataManager to delete items
            }
        }
    }
    
    private func shareItem(_ item: Item) {
        guard let textValue = item.textValue, let title = item.title else {
            // Handle the case where either the textValue or title is missing
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [title, textValue], applicationActivities: nil)
        
        // Get the relevant window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            // If your app is running on iPad, you'll need to use a popover presentation
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = topWindow
                popoverController.sourceRect = CGRect(x: topWindow.bounds.midX, y: topWindow.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            // Present the activity view controller
            topWindow.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
#if canImport(UIKit) && !os(tvOS)
        NavigationView {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.previewContext())
        }
#else
        Text("Preview not available on this platform")
#endif
    }
}
