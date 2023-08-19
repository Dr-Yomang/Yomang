//
//  USer.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable {
    
    @DocumentID var id: String? // firebase document id
    var username: String?
    var email: String
    var partnerId: String?

    // 공유했던 지난 요망이들
    var history: [YomangData]?
}
