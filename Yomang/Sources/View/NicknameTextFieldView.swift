//
//  NicknameTextFieldView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/02.
//

import SwiftUI

struct NicknameTextFieldView: View {
    @Binding var nickname: String
    @FocusState private var isTextFieldFocused: Bool
    let nicknameLimit = 10
    
    var body: some View {
        VStack {
            ZStack {
                if nickname.isEmpty {
                    Text("입력하기")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
                TextField("", text: $nickname)
                    .focused($isTextFieldFocused)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.title)
                    .frame(height: 60)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    .onChange(of: nickname) { _ in
                        if nickname.count > nicknameLimit {
                            let limitedText = nickname.dropLast()
                            nickname = String(limitedText)
                        }
                    }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .scaleEffect(1.1)
                .offset(y: -20)
        }.fixedSize()
    }
}
