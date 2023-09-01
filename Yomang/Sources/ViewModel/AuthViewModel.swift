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
import Alamofire
import SwiftJWT

class AuthViewModel: ObservableObject {
    
    static let shared = AuthViewModel()
    
    // 파이어베이스 서버 측으로부터 현재 로그인 세션 유지 중인 유저 정보가 있는지 확인
    @Published var userSession: FirebaseAuth.User?
    @Published var user: User?
    @Published var username: String?
    @Published var shareLink: String = "itms-apps://itunes.apple.com/app/6461822956"
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser { _ in
            self.createInviteLink()
        }
    }
    
    func fetchUser(_ completion: @escaping(Bool) -> Void) {
        guard let uid = userSession?.uid else {
            completion(false)
            return
        }
        
        Constants.userCollection.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            self.user = user
            self.username = user.username
            print("=== DEBUG: fetch \(self.user)")
            self.createInviteLink()
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
            
            Constants.userCollection.document(user.uid).setData(data as [String: Any]) { _ in
                print("=== DEBUG: 회원 등록 완료 \n\(data) ")
                self.userSession = Auth.auth().currentUser
                self.fetchUser { _ in
                    if let partnerId = partnerId {
                        Constants.userCollection.document(partnerId).updateData(["partnerId": user.uid])
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
        Constants.userCollection.document(uid).updateData(["username": username])
        self.username = username
    }
    
    func matchTwoUser(partnerId: String) {
        guard let uid = user?.id else { return }
        self.user?.partnerId = partnerId
        Constants.userCollection.document(partnerId).getDocument { snapshot, _ in
            guard let partner = snapshot else { return }
            guard let data = partner.data() else { return }
            guard data["partnerId"] != nil else { return }
        }
        Constants.userCollection.document(uid).updateData(["partnerId": partnerId])
        Constants.userCollection.document(partnerId).updateData(["partnerId": uid])
    }
    
    func signOut(_ completion: @escaping() -> Void) {
        do {
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
        guard let user = user else { return }
        var components = URLComponents()
        components.scheme = "https"
        components.host = "yomanglabyomang.page.link"
        components.path = "/matchingLink"
        
        let itemIDQueryItem = URLQueryItem(name: "UserID", value: user.id)
        components.queryItems = [itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print("\(linkParameter.absoluteString)링크를 공유하려고 시도합니다.")
        
        let domain = "https://yomanglabyomang.page.link"
        guard let linkBuilder = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: domain) else { return }
        
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
        
        linkBuilder.shorten { url, _, _ in
            guard let url = url else { return }
            self.shareLink = url.absoluteString
        }
    }
    
    func parseDeepLinkComponents(from url: URL) -> String {
        // url이 https로 시작 안하면 리턴 (잘못된 url)
        guard url.scheme == "https" else {
            return "NaN"
        }
        
        let urlStr = url.absoluteString
        if urlStr.contains("https://yomanglabyomang.page.link/matchingLink?UserID=") {
            var splitedLink = urlStr.split(separator: "=")
            return String(splitedLink[1])
        } else {
            return "NaN"
        }
    }
    
    // MARK: - 회원 탈퇴
    func getJWT() -> String {
        let myHeader = Header(kid: keyID) // sign in with
        struct MyClaims: Claims {
            let iss: String
            let iat: Int
            let exp: Int
            let aud: String
            let sub: String
        }
        
        let nowDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = 6
        let sixDate = Calendar.current.date(byAdding: dateComponent, to: nowDate) ?? Date()
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 3600
        let myClaims = MyClaims(iss: teamID,
                                iat: iat,
                                exp: exp,
                                aud: "https://appleid.apple.com",
                                sub: bundleID)
        
        var myJWT = JWT(header: myHeader, claims: myClaims)
        
        guard let url = Bundle.main.url(forResource: keyFileName, withExtension: "p8") else { return "" }
        let privateKey = try? Data(contentsOf: url, options: .alwaysMapped)
        
        let jwtSigner = JWTSigner.es256(privateKey: privateKey!)
        let signedJWT = try? myJWT.sign(using: jwtSigner)
        UserDefaults.standard.set(signedJWT, forKey: Constants.appleClientSecret)
        print("=== DEBUG: singedJWT \(signedJWT!)")
        return signedJWT!
    }
    
    func getAppleRefreshToken(code: String, completionHandler: @escaping (String?) -> Void) {
        guard let secret = UserDefaults.standard.string(forKey: Constants.appleClientSecret) else {return }
        guard let code = UserDefaults.standard.string(forKey: Constants.authorizationCode) else { return }
        
        let url = "https://appleid.apple.com/auth/token?client_id=\(bundleID)&client_secret=\(secret)&code=\(code)&grant_type=authorization_code"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        print("🗝 clientSecret - \(UserDefaults.standard.string(forKey: Constants.appleClientSecret))")
        print("🗝 authCode - \(code)")
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseData { response in
                print("🗝 response - \(response.description)")
                
                switch response.result {
                case .success(let output):
                    let decoder = JSONDecoder()
                    if let decodedData = try? decoder.decode(AppleTokenResponse.self, from: output) {
                        
                        if decodedData.refreshToken == nil {
                            print("=== DEBUG: 토큰 생성 실패")
                        } else {
                            completionHandler(decodedData.refreshToken)
                        }
                    }
                    
                case .failure:
                    // 로그아웃 후 재로그인하여
                    print("애플 토큰 발급 실패 - \(response.error.debugDescription)")
                }
            }
    }
    
    func revokeAppleToken(clientSecret: String, token: String, completion: @escaping () -> Void) {
        let url = "https://appleid.apple.com/auth/revoke?client_id=\(bundleID)&client_secret=\(clientSecret)&token=\(token)&token_type_hint=refresh_token"
        let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        
        AF.request(url,
                   method: .post,
                   headers: header)
        .validate(statusCode: 200..<600)
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode == 200 {
                print("=== DEUBG: 애플 토큰 삭제 성공!")
                completion()
            }
        }
    }
    
    func deleteUser(_ completion: @escaping() -> Void) {
        guard let user = AuthViewModel.shared.user else { return }
//        // MARK: - 파트너 연결끊고 히스토리 먼저 삭제
        guard let authorizationCode = UserDefaults.standard.string(forKey: Constants.authorizationCode) else { return }
        let jwtToken = AuthViewModel.shared.getJWT()
        self.getAppleRefreshToken(code: authorizationCode) { token in
            if let refreshToken = token {
                print("=== DEBUG: client secret 🔑 \(jwtToken)")
                print("=== DEBUG: refresh 🔑 \(refreshToken)")

                self.revokeAppleToken(clientSecret: jwtToken, token: refreshToken) {
                    print("=== DEBUG: Successully Apple revoke token")
                }
            } else {
                print("=== DEBUG: failed to get apple refresh token 🔑")
            }
        }
        guard let uid = user.id else { return }
        Constants.userCollection.document(uid).updateData(["partnerId": nil])
        Constants.historyCollection.whereField("senderUid", isEqualTo: uid).getDocuments { snapshot, error in
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
        }
        if let pid = user.partnerId {
            Constants.userCollection.document(pid).updateData(["partnerId": nil])
            Constants.historyCollection.whereField("senderUid", isEqualTo: pid).getDocuments { snapshot, error in
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
            }
        }
        
        // MARK: - 유저 정보 삭제
        guard let currentUser = Auth.auth().currentUser else { return }
        Constants.userCollection.document(currentUser.uid).delete { err in
            print("=== DEBUG: deleteUser() \(err)")
            self.signOut {
                currentUser.delete { err in
                    print("=== deleted error \(err)")
                    completion()
                }
            }
        }
    }
}
