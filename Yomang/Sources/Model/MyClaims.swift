//
//  MyClaims.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import Foundation
import SwiftJWT

// MARK: - Apple 서버에서 응답받는 모델
struct MyClaims: Claims {
    let iss: String
    let iat: Int
    let exp: Int
    let aud: String
    let sub: String
}
