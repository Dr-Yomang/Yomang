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
    let historyCollection = Firestore.firestore().collection("HistoryDebugCollection")
    let userCollection = Firestore.firestore().collection("UserDebugCollection")
    @Published var data = [YomangData]()
    @Published var connectWithPartner = false
    @Published var partner: User?
    @Published var partnerImageUrl: String?
    
    init() {
        capturePartnerConnection()
    }
    
    func capturePartnerConnection() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        if user.partnerId == nil {
            userCollection.document(uid).addSnapshotListener { snapshot, _ in
                guard let pid = user.partnerId else { return }
                guard let document = snapshot else { return }
                guard let userData = document.data() else { return }
                if userData["partnerId"] as! String == pid {
//                    //    MARK: - cloud functions가 deploy되면 구조가 바뀝니다
//                    collection.document(pid).getDocument { snapshot, _ in
//                        guard let snapshot = snapshot else { return }
//                        guard let partner = try? snapshot.data(as: User.self) else { return }
//                        collection.document(uid).updateData(["partnerToken": partner.userToken])
//                        collection.document(pid).updateData(["partnerToken": user.userToken])
//                    }
                    self.connectWithPartner = true
                    self.fetchYourYomang()
                    self.fetchPartnerData()
                }
            }
        } else {
            self.connectWithPartner = true
            fetchYourYomang()
            self.fetchPartnerData()
        }
    }
    
    func fetchPartnerData() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let pid = user.partnerId else { return }
        self.userCollection.document(pid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let partner = try? snapshot.data(as: User.self) else { return }
            self.partner = partner
        }
    }
    
    func fetchYourYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let pid = user.partnerId else { return }
        self.historyCollection.whereField("senderUid", isEqualTo: pid).getDocuments { snapshot, _ in
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
        self.historyCollection.document(yomangId).updateData(["emoji": appendEmoji])
        self.fetchYourYomang()
    }
}
