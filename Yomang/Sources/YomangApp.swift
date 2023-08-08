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
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YomangApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 링크 통해서 앱 진입 시 여기 변수에 매개변수로 상대 매칭 링크가 들어옵니다
    // YomanglabYomang://share?value="사용자코드" 포맷으로 링크 만들어서 앱 켜면 됨
    @State var matchingID: String?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack(spacing: 20) {
                    NavigationLink("login view") {
                        LoginView(matchingID: $matchingID).onOpenURL { url in
                            if url.scheme! == "YomanglabYomang" && url.host! == "share" {
                                if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
                                    for query in components.queryItems! {
                                        // 링크에 상대 매칭코드 없으면 nil, 아니면 링크에서 얻어온 매칭코드 값 넣기
                                        matchingID = query.value ?? nil
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink("setting view", destination: SettingView())
                
                }
            }
        }
    }
}
