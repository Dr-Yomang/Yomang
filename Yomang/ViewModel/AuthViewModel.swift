//
//  AuthViewModel.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth

class AuthViewModel: ObservableObject{
    
}

/* MC2 프로젝트 당시 작성한 코드인데 상황에 따라 참조할 목적으로 남겨둡니다.
// 정식출시 버전은 UserCollection에 데이터 저장,테스트는 앞에 Test 붙임
let db = Firestore.firestore().collection("TestUserCollection")

//Firebase와 User 간의 통신을 담당
class AuthViewModel: ObservableObject{
    
    static let shared = AuthViewModel()
    
    // 파이어베이스 서버 측으로부터 현재 로그인 세션 유지 중인 유저 정보가 있는지 확인
    @Published var userSession: FirebaseAuth.User?
    @Published var user: User?
    
    //TODO 인터넷 연결 없을 시 오류 확인하는 기능 추가해야
    init() {
        self.userSession = Auth.auth().currentUser
        fetchUser { _ in }
    }
    
    func fetchUser(_ completion: @escaping(Bool) -> ()) {
        guard let uid = userSession?.uid else {
            completion(false)
            return
        }
        
        //정식출시 버전은 Apple 로그인을 사용하기에, 세션 내의 유저가 없다면 UserDefaults로 저장된 userId에 대한 밸류값이 있는지 확인할 필요가 없어짐. 세션 내의 유저가 없다면 다시 로그인을 시켜야...
        db.document(uid).getDocument { snapshot , _ in
            guard let user = try? snapshot?.data(as: User.self) else {
                self.user?.userId = UserDefaults.shared.string(forKey: "userId") ?? "NaN"
                return
            }
            
            self.user = user
            UserDefaults.standard.set(user.userId, forKey: "userId")
            if user.isConnected {
                UserDefaults.standard.set(user.partnerId, forKey: "partnerId")
            }
            print("=== DEBUG: fetch \(self.user)")
            completion(true)
        }
    }
    
    private func getDeviceUUID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    //유저를 서버에 등록하고 (회원가입) 각 유저에게 부여되는 고유한 코드를 생성함
    func registerUser(_ completion: @escaping(String) -> Void?) {
        let uuid = getDeviceUUID()
        
        Auth.auth().signInAnonymously() { result, error in

            //서버에서 데이터를 받아오지 못했을 경우 별도의 작업 수행 없이 return
            if let error = error {
                print(" === Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            //받아온 유저 고유 id를 저장
            UserDefaults.standard.set(user.uid, forKey: "userId")
            self.user?.uuid = user.uid
            
            print("=== DEBUG: 접근했어")
            
            let data = ["userId": user.uid,
                        "partnerId": "NaN",
                        "isConnected": false,
                        "imageUrl": "",
                        "uuid": uuid]
            
            db.document(user.uid).setData(data) { _ in
                print("=== DEBUG: 회원 등록 완료 \n\(data) ")
                self.userSession = Auth.auth().currentUser
                self.fetchUser { _ in
                    completion(user.uid)
                }
            }
        }
    }
    
    //유저와 매칭!
    func matchingUser(partnerId: String) {
        guard let uid = user?.uuid else { return }
        
        // 유저가 입력한 파트너 아이디로 partnerId 세팅
        self.user?.partnerId = partnerId
        
        db.document(uid).updateData(["partnerId": partnerId])
        
        // 파트너가 설정한 partnerId가 현재 유저의 userId와 동일한지 확인
        db.document(partnerId).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else { return }
            let partnersPartnerId = data["partnerId"] as! String // partner's partnerId
            
            if uid == partnersPartnerId {
                self.user?.isConnected = true
                
                // 두 유저 모두 연결된 것으로 변경
                db.document(uid).updateData(["isConnected": true])
                db.document(partnerId).updateData(["isConnected": true])
            } else if partnersPartnerId.isEmpty {
                print("잘못된 코드를 넣은 것 같습니다! \(data)")
            } else {
                if partnersPartnerId == "NaN" {
                    print("대기중...")
                } else {
                    print("둘 중 누군가는 잘못된 코드를 넣었습니다!")
                }
            }
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping() -> Void) {
        guard let uid  = self.user?.uuid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let ref = Storage.storage().reference().child("Photos/\(uid)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        ref.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("=== DEBUG: 이미지 업로드 실패 \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url , _ in
                guard let imageUrl = url?.absoluteString else { return }
                db.document(uid).updateData(["imageUrl": imageUrl])
                self.user?.imageUrl = imageUrl
                completion()
            }
        }
    }
    
    func fetchImageUrl(_ completion: @escaping(String) -> Void?) {
        
        guard let _ = UserDefaults.standard.string(forKey: "userId") else { return }
        guard let partnerId = UserDefaults.standard.string(forKey: "partnerId") else { return }
        
        db.document(partnerId).getDocument{ document, error in
            
            if let _ = error {
                UserDefaults.standard.set("에러가 발생해 이미지를 불러오지 못했습니다. DEBUG #1", forKey: "notiMessage")
            } else {
                
                UserDefaults.standard.set("에러가 발생해 이미지를 불러오지 못했습니다. DEBUG #2", forKey: "notiMessage")
                if let document = document,
                   let data = document.data() {
                    if let partnerImageUrl = data["imageUrl"] as? String {
                        UserDefaults.standard.set("요망이 업데이트되었습니다. 확인요망!", forKey: "notiMessage")
                        UserDefaults.standard.set(partnerImageUrl, forKey: "imageUrl")
                        print("DEBUG: image url \(partnerImageUrl)")
                        
                        /// NSData로 변환해 저장
                        guard let url = URL(string: partnerImageUrl) else { return }
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            self.setImageInUserDefaults(UIImage: UIImage(data: data) ?? UIImage(), "widgetImage")
                        }.resume()
                        
                        completion(partnerImageUrl)
                    }
                }
            }
        }
    }
    
    /// UIImage convert to NSData
    func setImageInUserDefaults(UIImage value: UIImage, _ key: String) {
        let imageData = value.jpegData(compressionQuality: 0.5)
        UserDefaults.standard.set(imageData, forKey: key)
    }
    
    //
    
    /**
     0404에는 로그아웃에 대한 기능 명세가 없습니다. 테스트용으로 구현된 메소드이니 사용하지 마세요.
     */
    func signOut() {
        do {
//            guard let uid = self.user?.userId else { return }
//
//            let removeObjectKey = ["imageUrl", "partnerId", "notiMessage", "widgetImage"]
//            for key in removeObjectKey {
//                UserDefaults.shared.removeObject(forKey: key)
//            }
//            db.document(uid).updateData(["partnerId": "NaN"])
//            db.document(uid).updateData(["isConnected": "false"])
//            db.document(uid).updateData(["imageUrl": ""])
//
//            fetchUser { _ in }
            
            try Auth.auth().signOut()

            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                UserDefaults.standard.removeObject(forKey: key.description)
            }

        } catch {
            print("== DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
    
    
}
*/
