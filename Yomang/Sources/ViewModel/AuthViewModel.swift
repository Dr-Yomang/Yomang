//
//  AuthViewModel.swift
//  Yomang
//
//  Created by ZENA on 7/8/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

let collection = Firestore.firestore().collection("UserDebugCollection")

class AuthViewModel: ObservableObject {
    
    static let shared = AuthViewModel()
    
    // 파이어베이스 서버 측으로부터 현재 로그인 세션 유지 중인 유저 정보가 있는지 확인
    @Published var userSession: FirebaseAuth.User?
    @Published var user: User?
    @Published var username: String?
    
    init() {
        self.userSession = Auth.auth().currentUser
        fetchUser { _ in }
    }
    
    func fetchUser(_ completion: @escaping(Bool) -> Void) {
        guard let uid = userSession?.uid else {
            completion(false)
            return
        }
        
        collection.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            self.user = user
            self.username = user.username
            UserDefaults.shared.set(user.id, forKey: "uid")
            if user.partnerId != nil {
                UserDefaults.shared.set(user.partnerId, forKey: "partnerId")
            }
            print("=== DEBUG: fetch \(self.user)")
            completion(true)
        }
    }
    
    // 유저를 서버에 등록하고 (회원가입) 각 유저에게 부여되는 고유한 코드를 생성함
    func signInUser(credential: AuthCredential, email: String, partnerId: String?, _ completion: @escaping(String) -> Void?) {
        Auth.auth().signIn(with: credential) { (result, error) in
            // 서버에서 데이터를 받아오지 못했을 경우 별도의 작업 수행 없이 return
            if let error = error {
                print("===DEBUG: failed to create user \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }

            // 받아온 유저 고유 id를 저장
            UserDefaults.shared.set(user.uid, forKey: "uid")
            self.user?.id = user.uid

            let data = ["uid": user.uid,
                        "username": nil,
                        "email": email,
                        "partnerId": partnerId ?? nil,
                        "history": nil] as [String: Any?]

            collection.document(user.uid).setData(data as [String: Any]) { _ in
                print("=== DEBUG: 회원 등록 완료 \n\(data) ")
                self.userSession = Auth.auth().currentUser
                self.fetchUser { _ in
                    if let partnerId = partnerId {
                        collection.document(partnerId).updateData(["partnerId": user.uid])
                    }
                    completion(user.uid)
                }
            }
        }
    }
    
    func setUsername(username: String) {
        guard let uid = user?.id else { return }
        collection.document(uid).updateData(["username": username])
        self.username = username
    }
    
    func signOut() {
        do {
//            guard let uid = self.user?.userId else { return }
//
//            let removeObjectKey = ["imageUrl", "partnerId", "notiMessage", "widgetImage"]
//            for key in removeObjectKey {
//                UserDefaults.shared.removeObject(forKey: key)
//            }
//            collection.document(uid).updateData(["partnerId": "NaN"])
//            collection.document(uid).updateData(["isConnected": "false"])
//            collection.document(uid).updateData(["imageUrl": ""])
//
//            fetchUser { _ in }
            
            try Auth.auth().signOut()

            for key in UserDefaults.shared.dictionaryRepresentation().keys {
                UserDefaults.shared.removeObject(forKey: key.description)
            }

        } catch {
            print("== DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
}
