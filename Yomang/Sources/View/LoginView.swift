//
//  LoginView.swift
//  Yomang
//
//  Created by NemoSquare on 7/10/23.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var matchingIdFromUrl: String?
    
    var body: some View {
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
            AppleLoginButtonView(matchingID: $matchingIdFromUrl)
                .signInWithAppleButtonStyle(.white)
                .frame(width: 268, height: 48)
                .font(.largeTitle)
            Spacer()
            
            // Debug : 테스트용으로 써보고 지우세요! URL 통해서 앱 실행시 매칭코드 여기 연결된 변수로 들어갑니다.
            // YomanglabYomang://share?value="사용자코드" 포맷으로 링크 만들어서 앱 켜보시면 테스트 가능
            Text(matchingIdFromUrl ?? "nil")
                .foregroundColor(.white)
            
            Text(String.authenticationMessage)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.caption2)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(matchingIdFromUrl: .constant("YomanglabYomang://share?value=xTld2kfJ3kl"))
    }
}
