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
            Constants.userCollection.document(uid).addSnapshotListener { snapshot, _ in
                guard let document = snapshot else { return }
                guard let userData = document.data() else { return }
                guard let pid = userData["partnerId"] as? String else { return }
                if pid == "null" { return }
                self.connectWithPartner = true
                AuthViewModel.shared.fetchUser {
                    self.fetchPartener()
                }
                // MARK: - cloud functions가 deploy되면 구조가 바뀝니다
//                    collection.document(pid).getDocument { snapshot, _ in
//                        guard let snapshot = snapshot else { return }
//                        guard let partner = try? snapshot.data(as: User.self) else { return }
//                        collection.document(uid).updateData(["partnerToken": partner.userToken])
//                        collection.document(pid).updateData(["partnerToken": user.userToken])
//                    }
            }
        } else {
            self.connectWithPartner = true
            self.fetchPartener()
        }
    }
    
    // MARK: - 파트너의 정보와 요망 기록을 불러옵니다
    func fetchPartener() {
        self.fetchYourYomang()
        self.fetchPartnerData()
    }
    
    // MARK: - 파트너의 정보를 불러옵니다
    private func fetchPartnerData() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let pid = user.partnerId else { return }
        Constants.userCollection.document(pid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let partner = try? snapshot.data(as: User.self) else { return }
            if partner.partnerId == nil {
                // 연결 끊기 당한 경우, 연결된 파트너가 없는 경우
                self.partner = nil
                self.partnerImageUrl = nil
                self.connectWithPartner = false
                self.data.removeAll()
            } else {
                self.partner = partner
                Constants.profileCollection.whereField("uid", isEqualTo: pid).getDocuments { snapshot, err in
                    if let err = err {
                        print("=== DEBUG: fetch partner's profile image \(err.localizedDescription)")
                    }
                    guard let snapshot = snapshot else { return }
                    if snapshot.documents.count == 0 { return }
                    guard let profile = try? snapshot.documents[0].data(as: ProfileImage.self) else { return }
                    self.partnerImageUrl = profile.profileImageUrl
                }
            }
        }
    }
    
    // MARK: - 파트너의 요망을 불러옵니다
    private func fetchYourYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let pid = user.partnerId else { return }
        Constants.historyCollection.whereField("senderUid", isEqualTo: pid).getDocuments { snapshot, _ in
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
        Constants.historyCollection.document(yomangId).updateData(["emoji": appendEmoji])
        self.fetchYourYomang()
    }
}
