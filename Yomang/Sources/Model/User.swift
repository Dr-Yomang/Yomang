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
}
