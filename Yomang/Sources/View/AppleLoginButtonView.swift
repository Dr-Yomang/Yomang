//
//  AppleLoginButtonView.swift
//  Yomang
//
//  Created by NemoSquare on 7/8/23.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct AppleLoginButtonView: View {
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    @State var currentNonce: String?
    
    // Hashing function using CryptoKit
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    var body: some View {
        SignInWithAppleButton(SignInWithAppleButton.Label.signIn,
                              onRequest: { request in
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        },
                              onCompletion: { result in
            switch result {
            case .success(let authResults):
                switch authResults.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    
                    guard let nonce = currentNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                    }
                    
                    let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
                    Auth.auth().signIn(with: credential) { (_, error) in
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        print("signed in")
                    }
                    
                    print("\(String(describing: Auth.auth().currentUser?.uid))")
                default:
                    break
                    
                }
            default:
                break
            }
        }
        )
    }
}

struct AppleLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AppleLoginButtonView()
    }
}
