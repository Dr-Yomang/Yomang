//
//  YomangImg.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import Foundation

struct YomangImg {
    // 개인 정보
    //let timestamp: Timestamp <- Date 형을 사용해야 함
    let uploadDate: Date// 등록한 시간
    let userId: String // 등록한 유저

    // 요망이미지
    var imageUrl: String
    var emoji: [String]? = [String]()

        // BETA
    let text: String? // 변수 네이밍 확인
}
