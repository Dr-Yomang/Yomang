//
//  LoginView.swift
//  Yomang
//
//  Created by NemoSquare on 7/10/23.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var matchingIdFromUrl: String?
    @State private var isSignInInProgress = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image(.yottoHeadOnly)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 272)
                Text(String.yomang)
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .bold()
                AppleLoginButtonView(matchingIdFromUrl: $matchingIdFromUrl, isSignInInProgress: $isSignInInProgress)
                    .signInWithAppleButtonStyle(.white)
                    .frame(width: 268, height: 48)
                    .font(.largeTitle)
                Spacer()
                Text(String.authenticationMessage)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.caption2)
            }
            if isSignInInProgress {
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(matchingIdFromUrl: .constant("YomanglabYomang://share?value=xTld2kfJ3kl"))
    }
}
