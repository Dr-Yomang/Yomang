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
            VStack(spacing: 36) {
                Text("요망에 오신 걸\n환영해요!")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                Text("서로의 위젯에 언제라도 불쑥 나타나\n기분 좋은 서프라이즈를 주고 받아볼까요?")
                    .foregroundColor(Color.white)
                    .font(.title3)
                    .bold()
                    .multilineTextAlignment(.center)
                Spacer()
                AppleLoginButtonView(matchingIdFromUrl: $matchingIdFromUrl, isSignInInProgress: $isSignInInProgress)
                    .signInWithAppleButtonStyle(.white)
                    .frame(width: UIScreen.width - 40, height: 56)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
            .padding(.top, 100)
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
