//
//  YomangData.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import FirebaseFirestoreSwift
import Firebase

struct YomangData: Decodable {
    @DocumentID var id: String?
    let uploadedDate: Date// 등록한 시간
    let uploadUser: User // 등록한 유저

    // 요망이미지
    var imageUrl: String
    var emoji: [String]?

    // BETA
    let text: String? // 변수 네이밍 확인
}
