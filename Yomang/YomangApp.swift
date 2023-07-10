//
//  YomangApp.swift
//  Yomang
//
//  Created by 제나 on 2023/07/03.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YomangApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var matchingID: String? = nil
    
    var body: some Scene {
        WindowGroup {
            ContentView(matchingID: $matchingID).onOpenURL { url in
                if (url.scheme! == "YomanglabYomang" && url.host! == "share") {
                    if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
                        for query in components.queryItems! {
                            matchingID = query.value ?? nil
                            //YomanglabYomang://share?value="사용자코드" 포맷으로 링크 만들어서 던지면 됨
                        }
                    }
                }
            }
        }
    }
}
