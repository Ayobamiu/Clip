//
//  ClipApp.swift
//  Clip
//
//  Created by Usman Ayobami on 7/27/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct ClipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // register app delegate for Firebase setup
    @StateObject private var dataManager = DataManager.shared // Use StateObject instead of State
    
    var body: some Scene {
        WindowGroup {
            FoldersView()
                .environmentObject(dataManager) // Pass the DataManager as an environment object
        }
    }
}

