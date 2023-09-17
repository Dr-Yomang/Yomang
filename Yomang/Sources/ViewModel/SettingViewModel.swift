//
//  SettingViewModel.swift
//  Yomang
//
//  Created by 제나 on 2023/08/30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var username: String?
    @Published var profileImageUrl: String?
    @Published var isAlertOn = false
    @Published var partnerID: String?
    @Published var partnerUsername: String?
    
    init() {
        fetchSettingData()
    }
    
    func fetchSettingData() {
        fetchUsername()
        fetchProfileImageUrl()
        fetchPartnerUsername()
        queryAuthorizationStatus()
    }
    
    func fetchUsername() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        Constants.userCollection.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.username = user.username
        }
    }
    
    func fetchProfileImageUrl() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        Constants.profileCollection.whereField("uid", isEqualTo: uid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            if documents.count == 0 { return }
            guard let data = try? documents[0].data(as: ProfileImage.self) else { return }
            self.profileImageUrl = data.profileImageUrl
        }
    }
    
    func fetchPartnerID(_ completion: @escaping() -> Void) {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        Constants.userCollection.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.partnerID = user.partnerId
            self.partnerUsername = user.username
            completion()
        }
    }
    
    func fetchPartnerUsername() {
        guard AuthViewModel.shared.user != nil else { return }
        self.fetchPartnerID {
            guard let pid = self.partnerID else { return }
            Constants.userCollection.document(pid).getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                guard let user = try? snapshot.data(as: User.self) else { return }
                self.partnerUsername = user.username
            }
        }
    }
    
    func changeUsername(_ newUsername: String, completion: @escaping() -> Void) {
        guard let uid = AuthViewModel.shared.user?.id else { return }
        Constants.userCollection.document(uid).updateData(["username": newUsername])
        self.username = newUsername
        AuthViewModel.shared.username = newUsername
        completion()
    }
    
    func changeProfileImage(image: UIImage, completion: ((Error?) -> Void)?) {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        ImageUploader.uploadImage(image: image, type: .profile) { imageUrl in
            let data = ["uid": uid,
                        "profileImageUrl": imageUrl]
            self.profileImageUrl = imageUrl
            Constants.profileCollection.whereField("uid", isEqualTo: uid).getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                if documents.count == 0 {
                    Constants.profileCollection.addDocument(data: data, completion: completion)
                } else {
                    Constants.profileCollection.document(documents[0].documentID).updateData(["profileImageUrl": imageUrl], completion: completion)
                }
            }
        }
    }
    
    func queryAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined, .denied, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    self.isAlertOn = false
                }
            case .authorized:
                DispatchQueue.main.async {
                    self.isAlertOn = true
                }
            @unknown default:
                DispatchQueue.main.async {
                    self.isAlertOn = false
                }
            }
        }
    }
    
    func deletePartner(_ completion: @escaping() -> Void) {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        guard let pid = user.partnerId else { return }
        // MARK: - 서로의 연결정보 삭제
        Constants.userCollection.document(uid).updateData(["partnerId": nil])
        Constants.userCollection.document(pid).updateData(["partnerId": nil])
        // MARK: - partner의 히스토리 먼저 삭제
        self.deleteAllYomangs(targetUid: pid) {
            // MARK: - 나의 히스토리 삭제
            self.deleteAllYomangs(targetUid: uid) {
                completion()
            }
        }
    }
    
    private func deleteAllYomangs(targetUid: String, _ completion: @escaping() -> Void) {
        Constants.historyCollection.whereField("senderUid", isEqualTo: targetUid).getDocuments { snapshot, error in
            if let error = error { print(error) }
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            for item in data {
                guard let docId = item.id else { return }
                Constants.historyCollection.document(docId).delete { err in
                    if let err = err {
                        print("=== DEBUG: delete partner \(err)")
                    }
                }
            }
            completion()
        }
    }
}
