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
import FirebaseDynamicLinks

class AuthViewModel: ObservableObject {
    
    static let shared = AuthViewModel()
    let collection = Firestore.firestore().collection("UserDebugCollection")
    
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
            print("=== DEBUG: fetch \(self.user)")
            completion(true)
        }
    }
    
    // 유저를 서버에 등록하고 (회원가입) 각 유저에게 부여되는 고유한 코드를 생성함
    func signInUser(credential: AuthCredential, email: String, partnerId: String?, _ completion: @escaping(String) -> Void) {
        Auth.auth().signIn(with: credential) { (result, error) in
            // 서버에서 데이터를 받아오지 못했을 경우 별도의 작업 수행 없이 return
            if let error = error {
                print("===DEBUG: failed to create user \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else { return }
            self.user?.id = user.uid

            let data = ["uid": user.uid,
                        "username": nil,
                        "email": email,
                        "partnerId": partnerId ?? nil] as [String: Any?]
//                        MARK: - cloud functions가 deploy되면 구조가 바뀝니다
//                        "partnerToken": nil] as [String: Any?]

            self.collection.document(user.uid).setData(data as [String: Any]) { _ in
                print("=== DEBUG: 회원 등록 완료 \n\(data) ")
                self.userSession = Auth.auth().currentUser
                self.fetchUser { _ in
                    if let partnerId = partnerId {
                        self.collection.document(partnerId).updateData(["partnerId": user.uid])
                    }
                    completion(user.uid)
                }
            }
        }
    }
    
    func signInUser(credential: AuthCredential, _ completion: @escaping() -> Void) {
        Auth.auth().signIn(with: credential) { _, _ in
            self.userSession = Auth.auth().currentUser
            self.fetchUser { _ in }
            completion()
        }
    }
    
    func setUsername(username: String) {
        guard let uid = user?.id else { return }
        collection.document(uid).updateData(["username": username])
        self.username = username
    }
    
    func matchTwoUser(partnerId: String) {
        guard let uid = user?.id else { return }
        guard user?.partnerId != nil else { return }
        collection.document(partnerId).getDocument { snapshot, _ in
            guard let partner = snapshot else { return }
            guard let data = partner.data() else { return }
            guard data["partnerId"] != nil else { return }
        }
        self.collection.document(uid).updateData(["partnerId": partnerId])
        self.collection.document(partnerId).updateData(["partnerId": uid])
    }
    
    func signOut(_ completion: @escaping() -> Void) {
        do {
            guard self.user?.id != nil else { return }
            try Auth.auth().signOut()
            self.user = nil
            self.userSession = nil
            self.username = nil
            completion()
        } catch {
            print("== DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
    
    func createInviteLink() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "yomanglabyomang.page.link"
        components.path = "/matchingLink"
        
        let itemIDQueryItem = URLQueryItem(name: "UserID", value: "myUserIdValue")
        components.queryItems = [itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print("\(linkParameter.absoluteString)링크를 공유하려고 시도합니다.")
        
        let domain = "https://yomanglabyomang.page.link"
        guard let linkBuilder = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: domain) else {
            return
        }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        linkBuilder.iOSParameters?.appStoreID = "6449183477"
        
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title = "상대가 요망 초대장을 보냈어요!"
        linkBuilder.socialMetaTagParameters?.descriptionText = "초대 수락하기"
        // 여기에 앱 아이콘 미리보기 URL 들어가야 함
        
        //linkBuilder.socialMetaTagParameters?.imageURL = URL()
        
        guard let longURL = linkBuilder.url else { return }
        print("원본 다이나믹 링크 : \(longURL.absoluteString)")
        
        linkBuilder.shorten { url, warnings, error in
            if let error = error {
                print("링크 줄이는 과정에서 에러 발생 \(error)")
                return
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }
            guard let url = url else { return }
            print("줄인 url 결과 : \(url.absoluteString)")
        }
    }
    
    func parseDeepLinkComponents(from url: URL) -> String {
        // url이 https로 시작 안하면 리턴 (잘못된 url)
        guard url.scheme == "https" else {
            return "NaN"
        }
        
        let urlStr : String = url.absoluteString
        if urlStr.contains("https://yomanglabyomang.page.link/matchingLink?UserID=") {
            var splitedLink = urlStr.split(separator: "=")
            return String(splitedLink[1])
        } else {
            return "NaN"
        }
    }
}
