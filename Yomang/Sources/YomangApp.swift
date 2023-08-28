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
    @State private var matchingIdFromUrl: String?
    @UIApplicationDelegateAdaptor(YomangAppDelegate.self) var delegate

    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(teamID).pos.academy.Yomang")
        } catch {
            print(error.localizedDescription)
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView(matchingIdFromUrl: $matchingIdFromUrl)
                .environmentObject(AuthViewModel.shared)
                .onOpenURL { url in
                    if url.scheme! == "YomanglabYomang" && url.host! == "share" {
                        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
                            for query in components.queryItems! {
                                // 링크에 상대 매칭코드 없으면 nil, 아니면 링크에서 얻어온 매칭코드 값 넣기
                                matchingIdFromUrl = query.value ?? nil
                            }
                        }
                    }
                }
        }
    }
}
