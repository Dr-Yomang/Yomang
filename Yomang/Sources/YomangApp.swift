//
//  YomangApp.swift
//  Yomang
//
//  Created by 제나 on 2023/07/03.
//

import SwiftUI
import Firebase
import FirebaseDynamicLinks

@main
struct YomangApp: App {
    @State private var matchingIdFromUrl: String?
    @State private var deepLink: DeepLinkURLViewModel.DeepLink?
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
                  print("Incoming URL parameter is: \(url)")
                  // 2
                  let linkHandled = DynamicLinks.dynamicLinks()
                    .handleUniversalLink(url) { dynamicLink, error in
                      guard error == nil else {
                        fatalError("Error handling the incoming dynamic link.")
                      }
                      // 3
                      if let dynamicLink = dynamicLink {
                        // Handle Dynamic Link
                        self.handleDynamicLink(dynamicLink)
                      }
                    }
                  // 4
                  if linkHandled {
                    print("Link Handled")
                  } else {
                    print("No Link Handled")
                  }
                }
            
//                .onOpenURL { url in
//                    if url.scheme! == "YomanglabYomang" && url.host! == "share" {
//                        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
//                            for query in components.queryItems! {
//                                // 링크에 상대 매칭코드 없으면 nil, 아니면 링크에서 얻어온 매칭코드 값 넣기
//                                matchingIdFromUrl = query.value ?? nil
//                            }
//                        }
//                    }
//                }
        }
    }
    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }

        print("Your incoming link parameter is \(url.absoluteString)")
        // 1
        guard
          dynamicLink.matchType == .unique ||
          dynamicLink.matchType == .default
        else {
          return
        }
        // 2
        let deepLinkURLViewModel = DeepLinkURLViewModel()
        guard let deepLink = deepLinkURLViewModel.parseComponents(from: url) else {
          return
        }
        self.deepLink = deepLink
        print("Deep link: \(deepLink)")
        // 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          self.deepLink = nil
        }
    }
}
