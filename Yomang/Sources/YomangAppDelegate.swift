//
//  YomangAppDelegate.swift
//  Yomang
//
//  Created by NemoSquare on 8/28/23.
//

import Foundation
import FirebaseDynamicLinks
import UIKit

class YomangAppDelegate: UIResponder, UIApplicationDelegate {
    
    // 앱이 Running 상태일때 DynamicLink 수신
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("리시빙")
        sleep(500)
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
                if let urlString = dynamiclink?.url?.absoluteString {
                    print(urlString)
                }
                print("false")
            }

      return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey
                           .sourceApplication] as? String,
                         annotation: "")
    }
    
    // 앱이 Running 상태가 아닐 때 수신
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          // 다이나믹 링크 핸들링
          if let urlString = dynamicLink.url?.absoluteString {
                          print(urlString)
                          return true
                      }
      }
        print("false")
        return false
    }
}
