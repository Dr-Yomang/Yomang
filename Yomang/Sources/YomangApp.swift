//
//  YomangApp.swift
//  Yomang
//
//  Created by 제나 on 2023/07/03.
//

import SwiftUI
import Firebase

@main
struct YomangApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        }
    }
}
