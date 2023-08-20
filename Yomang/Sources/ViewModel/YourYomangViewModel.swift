//
//  YourYomangViewModel.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class YourYomangViewModel: ObservableObject {
    let collection = Firestore.firestore().collection("HistoryDebugCollection")
    
    @Published var data = [YomangData]()
    @Published var connectWithPartner = false
    
    init() {
        fetchYourYomang()
    }
    
    func fetchYourYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        if user.partnerId != nil {
            self.connectWithPartner = true
        }
        self.collection.whereField("senderUid", isEqualTo: user.partnerId!).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            self.data = data.sorted(by: { $0.uploadedDate > $1.uploadedDate })
        }
    }
    
    func reactToYourYomang(yomangId: String, originEmoji: [String], emojiName: String) {
        guard let user = AuthViewModel.shared.user else { return }
        guard user.partnerId != nil else { return }
        var appendEmoji = originEmoji
        appendEmoji.append(emojiName)
        self.collection.document(yomangId).updateData(["emoji": appendEmoji])
    }
}
