//
//  LinkView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/11.
//

import SwiftUI

struct LinkView: View {
    @State private var flowCount = 0
    @State private var displayedText = ""
    @State private var fullText = ""
    @State private var buttonText = ""
    @State private var nickname = ""
    @Binding var matchingIdFromUrl: String?
    @State private var jumpToggle = false
    @State private var rotationToggle = false
    let typingInterval = 0.05
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                    .overlay(
                        Image("YomangMoon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1600, height: 1600)
                            .offset(y: 820)
                            .opacity(0.8)
                            .ignoresSafeArea()
                    )
                Image("Yotto_gown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 240)
                    .offset(y: -48)
                    .padding()
                    .rotationEffect(Angle.degrees(rotationToggle ? 1.0 : -1.0))
                    .offset(y: jumpToggle ? 5 : -5)
                    .shadow(color: .gray, radius: 6, x: 0, y: 4)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3).repeatCount(5, autoreverses: true)) {
                            rotationToggle.toggle()
                        }
                    }
                    .onChange(of: flowCount) { newValue in
                        withAnimation(.easeInOut(duration: 0.3).repeatCount(5, autoreverses: true)) {
                            if newValue == 2 {
                                jumpToggle.toggle()
                            } else {
                                rotationToggle.toggle()
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2).repeatCount(6, autoreverses: true)) {
                            jumpToggle.toggle()
                        }
                    }
                
                VStack {
                    Spacer().frame(height: 48)
                    Text(displayedText)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    if flowCount == 1 {
                        NicknameTextFieldView(nickname: $nickname)
                    }
                    Spacer()
                }
                .onAppear {
                    displayedText = ""
                    fullText = "반가워요!\n저는 요망이에요"
                    startTyping()
                }
                .onChange(of: flowCount) { newValue in
                    displayedText = ""
                    switch newValue {
                    case 1: fullText = "제가 당신을 어떻게\n부르면 될까요?"
                    case 2: fullText = "좋아요!\n\(nickname)씨.\n\n\n\n\n\n\n\n\n\n\n\n당신과 당신의 파트너를\n이어줄게요."
                    case 3: fullText = "상대방과의 연결을\n기다리는 동안\n요망을 둘러볼까요?"
                    default: fullText = "default"
                    }
                    startTyping()
                }
            } // ZStack
            .ignoresSafeArea(.keyboard)
            
            VStack {
                Spacer()
                switch flowCount {
                case 0, 1:
                    Button {
                        flowCount += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text(buttonText)
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.2 : 1.0)
                            .opacity(flowCount == 1 && nickname.count == 0 ? 0.2 : 1.0)
                    }
                    .disabled(displayedText < fullText)
                    .disabled(flowCount == 1 && nickname.count == 0)
                    
                case 2:
                    Button {
                        flowCount -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray)
                            .frame(height: 56)
                            .overlay(
                                Text("제 별명이 아니에요")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.2 : 0.8)
                        
                    }
                    .disabled(displayedText < fullText)
                    if viewModel.user?.partnerId == nil {
                        ShareLink(item: URL(string: "YomanglabYomang://share?value=\(AuthViewModel.shared.user?.id)")
                                  ?? URL(string: "itms-apps://itunes.apple.com/app/6461822956")!) {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .overlay(
                                    Text(buttonText)
                                        .foregroundColor(.black)
                                        .font(.title3)
                                        .bold()
                                )
                                .opacity(displayedText < fullText ? 0.2 : 1.0)
                        }
                        .disabled(displayedText < fullText)
                        .simultaneousGesture(TapGesture().onEnded {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { flowCount = 3 })
                        })
                    } else {
                        Button {
                            viewModel.setUsername(username: nickname)
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .overlay(
                                    Text("요망 시작하기")
                                        .foregroundColor(.black)
                                        .font(.title3)
                                        .bold()
                                )
                                .opacity(displayedText < fullText ? 0.1 : 1.0)
                        }
                        .disabled(displayedText < fullText)
                    }
                    
                case 3:
                    ShareLink(item: matchingIdFromUrl ?? "") {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray)
                            .frame(height: 56)
                            .overlay(
                                Text("연결 링크 공유하기")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.1 : 0.8)
                    }
                    .disabled(displayedText < fullText)
                    
                    Button {
                        viewModel.setUsername(username: nickname)
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text(buttonText)
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.1 : 0.8)
                    }
                    .disabled(displayedText < fullText)
                default: EmptyView()
                }
                
            } // VStack
            .onAppear {
                buttonText = "다음으로"
            }
            .onChange(of: flowCount) { newValue in
                switch newValue {
                case 1: buttonText = "확인"
                case 2: buttonText = "연결 링크 공유하기"
                case 3: buttonText = "요망 둘러보기"
                default: buttonText = "default"
                }
            }
            .padding()
        } // ZStack
    }
    
    private func startTyping() {
        var currentIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if currentIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
                displayedText += String(fullText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
}

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
