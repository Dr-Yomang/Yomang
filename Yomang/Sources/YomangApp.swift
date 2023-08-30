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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 앱이 켜졌을때
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        do {
            try Auth.auth().useUserAccessGroup("\(teamID).pos.academy.Yomang")
        } catch {
            print(error.localizedDescription)
        }
        
        // 메세징 델리게이트
        Messaging.messaging().delegate = self
        // 원격 알림 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("AppDelegate - received token from firebase")
        print("AppDelegate - Firebase registration token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 푸시메세지가 앱이 foreground에 있을 때 나옴
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        print("=== DEBUG: willPresent: userInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("=== DEBUG: didReceive: userInfo: ", userInfo)
        completionHandler()
    }
    
}
