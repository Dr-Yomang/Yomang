//
//  Constants.swift
//  Yomang
//
//  Created by 제나 on 2023/07/04.
//

import SwiftUI

struct Constants {
    static let yomangHeight = 367
    static let reactionBarHeight = 72
    static var widgetSize: CGSize {
        switch UIScreen.main.bounds.size {
        case CGSize(width: 430, height: 932):
            return CGSize(width: 364, height: 382)
        case CGSize(width: 428, height: 926): // 12 Pro Max
            return CGSize(width: 364, height: 382)
        case CGSize(width: 414, height: 896): // 11 Pro Max or 11
            return CGSize(width: 360, height: 379)
        case CGSize(width: 414, height: 736): // 11 Pro Max or 11
            return CGSize(width: 348, height: 357)
        case CGSize(width: 393, height: 852):
            return CGSize(width: 338, height: 354)
        case CGSize(width: 390, height: 844): // 12
            return CGSize(width: 338, height: 354)
        case CGSize(width: 375, height: 812): // 12 Mini or 11 Pro
            return CGSize(width: 329, height: 345)
        case CGSize(width: 375, height: 667): // 8
            return CGSize(width: 321, height: 324)
        case CGSize(width: 360, height: 780):
            return CGSize(width: 329, height: 345)
        case CGSize(width: 320, height: 568): // SE
            return CGSize(width: 292, height: 311)
        default:
            return CGSize(width: 292, height: 311)
        }
    }
}
