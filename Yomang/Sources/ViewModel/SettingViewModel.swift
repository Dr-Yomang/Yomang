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
    
    let collection = Firestore.firestore().collection("ProfileImageDebugCollection")
    @Published var username: String?
    @Published var profileImageUrl: String?
    
    init() {
        fetchUsername()
        fetchProfileImageUrl()
    }
    
    func fetchUsername() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        collection.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.username = user.username
        }
    }
    
    func fetchProfileImageUrl() {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        self.collection.whereField("uid", isEqualTo: uid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            guard let data = try? documents[0].data(as: ProfileImage.self) else { return }
            self.profileImageUrl = data.profileImageUrl
        }
    }
    
    func changeUsername(_ newUsername: String, completion: @escaping() -> Bool) {
        guard let uid = AuthViewModel.shared.user?.id else { return }
        Firestore.firestore().collection("UserDebugCollection").document(uid).updateData(["username": newUsername])
        self.username = newUsername
        AuthViewModel.shared.username = newUsername
    }
    
    func changeProfileImage(image: UIImage, completion: ((Error?) -> Void)?) {
        guard let user = AuthViewModel.shared.user else { return }
        guard let uid = user.id else { return }
        ImageUploader.uploadImage(image: image, type: .profile) { imageUrl in
            let data = ["uid": uid,
                        "profileImageUrl": imageUrl]
            
            self.collection.addDocument(data: data, completion: completion)
        }
    }
}
