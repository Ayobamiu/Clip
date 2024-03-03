//
//  AddAndUpdateDataView.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI

struct AddAndUpdateDataView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var dataManager: DataManager // Inject DataManager
    
    @State private var title: String = ""
    @State private var textValue: String = ""
    @State private var isValueHidden: Bool = false
    var itemToUpdate: Item? // Optional Item parameter for updating data
    var category: Category? // Optional Category parameter for categorizing data

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                        .onAppear {
                            // Set the title to the existing item's title if available
                            title = itemToUpdate?.title ?? ""
                        }
                }
                Section(header: Text("Content")) {
                    TextEditor(text: $textValue)
                        .frame(height: 100)
                        .onAppear {
                            // Set the textValue to the existing item's textValue if available
                            textValue = itemToUpdate?.textValue ?? ""
                        }
                }
                Toggle("Hide Value", isOn: $isValueHidden)
                    .onAppear {
                        // Set isValueHidden to the existing item's isValueHidden if available
                        isValueHidden = itemToUpdate?.isValueHidden ?? false
                    }
            }
            .listRowSeparator(.hidden)
            .navigationTitle(itemToUpdate == nil ? "Add Data" : "Edit Data")
            .navigationBarItems(trailing: Button(action: {
                if let itemToUpdate = itemToUpdate {
                    updateItem(item: itemToUpdate)
                } else {
                    addItem()
                }
            }) {
                Text(itemToUpdate == nil ? "Done" : "Update")
            })
        }
    }
    
    private func addItem() {
        withAnimation {
            guard !textValue.isEmpty, !title.isEmpty else {
                return
            }
            
            dataManager.addNewItem(title: title, textValue: textValue, isValueHidden: isValueHidden, category: category)
            // Add the new item to recent items
            dataManager.updateRecentItems()
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func updateItem(item: Item) {
        withAnimation {
            guard !textValue.isEmpty, !title.isEmpty else {
                return
            }
            dataManager.updateItem(item: item, title: title, textValue: textValue, isValueHidden: isValueHidden,category: category)
            dataManager.updateRecentItems(newItem:item)
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct AddAndUpdateDataView_Previews: PreviewProvider {
    static var previews: some View {
        AddAndUpdateDataView()
    }
}
