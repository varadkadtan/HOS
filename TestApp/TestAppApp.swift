//
//  TestAppApp.swift
//  TestApp
//
//  Created by admin on 21/04/24.
//

import SwiftUI
import Firebase

@main
struct YourApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
