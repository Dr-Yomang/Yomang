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
    @Binding var matchingIdFromUrl: String?
    @Binding var isSignInInProgress: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    
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
        SignInWithAppleButton(.signIn) { request in
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            isSignInInProgress = true
        } onCompletion: { result in
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
                    
                    let credential = OAuthProvider.credential(
                        withProviderID: "apple.com",
                        idToken: idTokenString,
                        rawNonce: nonce)
                    
                    guard let email = appleIDCredential.email else {
                        print("Already Signed in")
                        viewModel.signInUser(credential: credential) {
                            isSignInInProgress = false
                        }
                        return
                    }
                    
                    viewModel.signInUser(
                        credential: credential,
                        email: email,
                        partnerId: matchingIdFromUrl ?? nil) { result in
                            matchingIdFromUrl = result
                            isSignInInProgress = false
                        }
                default:
                    isSignInInProgress = false
                }
            case .failure(let error):
                isSignInInProgress = false
                print("Authorization faild: \(error.localizedDescription)")
            }
            
        }
    }
}
