//
//  AppleTokenResponse.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import Foundation
// MARK: - response model from Apple server
struct AppleTokenResponse: Codable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: Int?
    var refreshToken: String?
    var idToken: String?

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
