//
//  USer.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import Foundation

struct User: Decodable {
    // 개인 정보
    var uuid: String
    var username: String
    var userId: String
    var partnerId: String?

    // 파트너와 연결되어 있음
    var isConnected: Bool

    // 본인이 설정한 이미지
    var imageUrl: String

    // var history: [YomangImg]? << YomangImg Type이 Decodable 하지 않아서 오류 발생
    var history: Data?
}