//
//  LinkView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/11.
//

import SwiftUI

struct LinkView: View {
    @State private var flowCount: Int = 0
    @State private var displayedText: String = ""
    @State private var fullText: String = ""
    @State private var buttonText: String = ""
    @State private var nickname: String = ""
    @State private var userCode: String = "sdkfk10dkf0s3nd9ne"
    @FocusState private var isTextFieldFocused: Bool
    let typingInterval = 0.05
    let nicknameLimit = 10
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.black)
                    .ignoresSafeArea()
                
                Image("Yotto_gown")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 240)
                    .offset(y: -64)
                    .padding()
                
                VStack {
                    Spacer().frame(height: 32)
                    Text(displayedText)
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    if flowCount == 1 {
                        VStack{
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
            }//ZStack
            .ignoresSafeArea(.keyboard)
            
            VStack {
                Spacer()
                if flowCount == 2 {
                    Button(action: {
                        flowCount -= 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray)
                            .frame(height: 56)
                            .overlay(
                                Text("제 별명이 아니에요")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.2 : 1.0)
                        
                    }
                    .disabled(displayedText < fullText)
                    ShareLink(item: "share") {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text(buttonText)
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.2 : 1.0)
                    }
                    .disabled(displayedText < fullText)
                }
                else {
                    Button(action: {
                        flowCount += 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text(buttonText)
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                            )
                            .opacity(displayedText < fullText ? 0.2 : 1.0)
                            .opacity(flowCount == 1 && nickname.count == 0 ? 0.2 : 1.0)
                    }
                    .disabled(displayedText < fullText)
                    .disabled(flowCount == 1 && nickname.count == 0)
                }
            }//VStack
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
        }//ZStack
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
    
    private func shareLink() {
        let activityViewController = UIActivityViewController(activityItems: [userCode], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
}



struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
