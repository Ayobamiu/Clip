//
//  DataManager.swift
//  Clip
//
//  Created by Usman Ayobami on 8/5/23.
//

import Foundation
import CoreData
import UIKit
import Firebase
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

class DataManager: ObservableObject {
    static let shared = DataManager()
    @Published var recentItems: [Item] = []
    let viewContext = PersistenceController.shared.container.viewContext
    
    
    // Add a method to update recent items when a new item is added or updated
    func updateRecentItems(newItem: Item? = nil) {
        let newItem = newItem ?? fetchAllItems().first
        
        if let newItem = newItem {
            recentItems.removeAll(where: { $0 == newItem }) // Remove any existing occurrence
            recentItems.insert(newItem, at: 0)
            
            // Ensure that recentItems doesn't exceed a certain count (e.g., 10)
            if recentItems.count > 10 {
                recentItems.removeLast()
            }
        }
    }
    
    
    func deleteItem(item: Item) {
        viewContext.delete(item)
        saveContext()
    }
    
    func filterItems(with searchText: String) -> [Item] {
        if searchText.isEmpty {
            return fetchAllItems()
        } else {
            return fetchItems(with: searchText)
        }
    }
    
    func addNewItem(title: String, textValue: String, isValueHidden: Bool, category: Category?) {
        guard !textValue.isEmpty, !title.isEmpty else {
            return
        }
        
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.textValue = textValue
        newItem.isValueHidden = isValueHidden
        newItem.title = title
        newItem.category = category
        
        saveContext()
    }
    
    func updateItem(item: Item, title: String, textValue: String, isValueHidden: Bool,category: Category?) {
        guard !textValue.isEmpty, !title.isEmpty else {
            return
        }
        
        item.timestamp = Date()
        item.textValue = textValue
        item.isValueHidden = isValueHidden
        item.title = title
        item.category = category
        
        saveContext()
    }
    
    func fetchAllItems() -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    
    func fetchItems(for category: Category? = nil, with searchText: String) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var predicates: [NSPredicate] = []
        
        if let category = category {
            let categoryPredicate = NSPredicate(format: "category == %@", category)
            predicates.append(categoryPredicate)
        }
        
        if !searchText.isEmpty {
            let searchTextPredicate = NSPredicate(format: "title CONTAINS[c] %@ OR textValue CONTAINS[c] %@", searchText, searchText)
            predicates.append(searchTextPredicate)
        }
        
        if !predicates.isEmpty {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
        }
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
    // MARK: - CATETORY METHODS
    func createCategory(name: String) {
        let newCategory = Category(context: viewContext)
        newCategory.name = name
        saveContext()
    }
    
    
    func updateCategory(category: Category, newName: String) {
        category.name = newName
        saveContext()
    }
    
    func deleteCategory(category: Category) {
        if let items = category.items {
            // Find all items with the given category and remove the category association
            for item in items {
                if let item = item as? Item {
                    item.category = nil
                }
            }
        }
        
        viewContext.delete(category)
        saveContext()
    }
    
    func renameCategory(category: Category, newName: String) {
        updateCategory(category: category, newName: newName)
        
        if let items = category.items {
            // Find all items with the given category and update the category association
            for item in items {
                if let item = item as? Item {
                    // Update associated items with the new category name
                    item.category?.name = newName
                }
            }
        }
        
        saveContext()
    }
    
    
    
    
    func fetchAllCategories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }
    
    func showRenameCategoryAlert(category: Category) {
        let alertController = UIAlertController(title: "Rename Category", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = category.name
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            if let newName = alertController.textFields?.first?.text {
                self.renameCategory(category: category, newName: newName)
            }
        })
        
        // Present the alert on the top window scene
        if let topWindowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            if let topWindow = topWindowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                topWindow.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    //MARK: - USER METHODS
    
    
}

