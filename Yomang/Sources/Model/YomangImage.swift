//
//  YomangImg.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import Foundation

struct YomangImage: Decodable {
    // 개인 정보
    // let timestamp: Timestamp
    let uploadDate: Date// 등록한 시간
    let makerId: String // 등록한 유저

    // 요망이미지
    var imageUrl: String
    var emoji: [String]? = [String]()

        // BETA
    let text: String? // 변수 네이밍 확인
}
