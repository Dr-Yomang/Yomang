//
//  Constants.swift
//  Yomang
//
//  Created by 제나 on 2023/07/04.
//

import SwiftUI
import Foundation
import FirebaseFirestore

struct Constants {
    static let reactionBarHeight: CGFloat = 72
    static let widgetPadding: CGFloat = 20    
    static let yomangPadding: CGFloat = 48

    static var widgetSize: CGSize {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 430, height: 932): // 14 pro max
            return CGSize(width: 364, height: 382)
        case CGSize(width: 428, height: 926): // iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max
            return CGSize(width: 364, height: 382)
        case CGSize(width: 414, height: 896): // iPhone 11 Pro Max, iPhone XS Max, iPhone 11, iPhone XR
            return CGSize(width: 360, height: 379)
        case CGSize(width: 414, height: 736): // iPhone 8 Plus, iPhone 7 Plus, iPhone 6S Plus
            return CGSize(width: 348, height: 357)
        case CGSize(width: 393, height: 852): // iPhone 14 Pro
            return CGSize(width: 338, height: 354)
        case CGSize(width: 390, height: 844): // iPhone 14, iPhone 13 Pro, iPhone 13, iPhone 12 Pro, iPhone 12
            return CGSize(width: 338, height: 354)
        case CGSize(width: 375, height: 812): // iPhone 11 Pro, iPhone XS, iPhone X, iPhone 13 mini, iPhone 12 mini,
            return CGSize(width: 329, height: 345)
        case CGSize(width: 375, height: 667): // iPhone SE (3rd & 2nd Gen), iPhone 8, iPhone 7, iPhone 6S
            return CGSize(width: 321, height: 324)
        case CGSize(width: 360, height: 780):
            return CGSize(width: 329, height: 345)
        case CGSize(width: 320, height: 568): // iPhone SE (1st Gen), iPod Touch (7th Gen)
            return CGSize(width: 292, height: 311)
        default:
            return CGSize(width: 338, height: 354)
        }
    }

    static var offsetSize: Double {
            switch UIScreen.main.bounds.size {
            case CGSize(width: 430, height: 932): // 14 pro max
                return 30.0
            case CGSize(width: 428, height: 926): // iPhone 14 Plus, iPhone 13 Pro Max, iPhone 12 Pro Max
                return 24.0
            case CGSize(width: 414, height: 896): // iPhone 11 Pro Max, iPhone XS Max, iPhone 11, iPhone XR
                return 24.0
            case CGSize(width: 414, height: 736): // iPhone 8 Plus, iPhone 7 Plus, iPhone 6S Plus
                return 10.0
            case CGSize(width: 393, height: 852): // iPhone 14 Pro
                return 30.0
            case CGSize(width: 390, height: 844): // iPhone 14, iPhone 13 Pro, iPhone 13, iPhone 12 Pro, iPhone 12
                return 24.0
            case CGSize(width: 375, height: 812): // iPhone 11 Pro, iPhone XS, iPhone X, iPhone 13 mini, iPhone 12 mini,
                return 22.0
            case CGSize(width: 375, height: 667): // iPhone SE (3rd & 2nd Gen), iPhone 8, iPhone 7, iPhone 6S
                return 10.0
            default:
                return 24.0
            }
    }

    // MARK: - Firebase collections
    static let userCollection = Firestore.firestore().collection("UserDebugCollection")
    static let historyCollection = Firestore.firestore().collection("HistoryDebugCollection")
    static let profileCollection = Firestore.firestore().collection("ProfileImageDebugCollection")
    
    // MARK: - UserDefaults
    static let appleClientSecret = "AppleClientSecret"
    static let authorizationCode = "AuthorizationCode"
}
