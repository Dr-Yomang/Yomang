//
//  SettingViewModel.swift
//  Yomang
//
//  Created by 제나 on 2023/08/30.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingViewModel: ObservableObject {
    @Published var username: String?
    @Published var profileImageUrl: String?
    @Published var alertAuthorizationStatus = ""
    
    init() {
        fetchUsername()
        fetchProfileImageUrl()
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
                self.alertAuthorizationStatus = "꺼짐"
            case .authorized:
                self.alertAuthorizationStatus = "켜짐"
            @unknown default:
                self.alertAuthorizationStatus = ""
            }
        }
    }
    
    func deletePartner() {
        
    }
}
