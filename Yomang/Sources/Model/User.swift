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
//    MARK: - cloud functions가 deploy되면 구조가 바뀝니다
//    var partnerToken: String?
//    var userToken: String
}
