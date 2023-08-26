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
        capturePartnerConnection()
    }
    
    func capturePartnerConnection() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        let collection = Firestore.firestore().collection("UserDebugCollection")
        if user.partnerId == nil {
            collection.document(uid).addSnapshotListener { snapshot, _ in
                guard let pid = user.partnerId else { return }
                guard let document = snapshot else { return }
                guard let userData = document.data() else { return }
                if userData["partnerId"] as! String == pid {
                    self.connectWithPartner = true
                    self.fetchYourYomang()
                }
            }
        } else {
            self.connectWithPartner = true
            fetchYourYomang()
        }
    }
    
    func fetchYourYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let partnerUid = user.partnerId else { return }
        self.collection.whereField("senderUid", isEqualTo: partnerUid).getDocuments { snapshot, _ in
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
        self.fetchYourYomang()
    }
}
