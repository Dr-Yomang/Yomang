//
//  YomangData.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import FirebaseFirestoreSwift
import Firebase

struct YomangData: Decodable, Identifiable, Hashable {
    @DocumentID var id: String?
    let uploadedDate: Date// 등록한 시간
    let senderUid: String // 등록한 유저
    let receiverUid: String

    // 요망이미지
    var imageUrl: String
    var emoji: [String]?
}
