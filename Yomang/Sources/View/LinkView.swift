//
//  LinkView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/11.
//

import SwiftUI

struct LinkView: View {
    @Binding var matchingIdFromUrl: String?
    @Binding var navigateToYomangView: Bool
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var flowCount = 0
    
    @State private var displayedText = ""
    @State private var fullText = ""
    @State private var displayedText2 = ""
    @State private var fullText2 = ""
    @State private var imageName = ""
    
    @State private var nickname = ""
    
    @State private var jumpToggle = false
    @State private var rotationToggle = false
    
    var body: some View {
        ZStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer().frame(height: UIScreen.height * 0.1)
                    
                    if flowCount == 1 {
                        NicknameTextFieldView(nickname: $nickname)
                    } else {
                        Text(displayedText)
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    }
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.width * 0.5)
                        .padding()
                        .rotationEffect(Angle.degrees(rotationToggle ? 0.5 : -0.5))
                        .offset(y: jumpToggle ? 3 : -3)
                        .shadow(color: .gray, radius: 6, x: 0, y: 4)
                        .onAppear {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 0.3).repeatCount(5, autoreverses: true)) {
                                    rotationToggle.toggle()
                                }
                            }
                        }
                        .onChange(of: flowCount) { newValue in
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true)) {
                                    if newValue == 2 {
                                        jumpToggle.toggle()
                                    } else {
                                        rotationToggle.toggle()
                                    }
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                                jumpToggle.toggle()
                            }
                        }
                    
                    Text(displayedText2)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .onAppear {
                    imageName = .yottoGown1
                    
                    displayedText = ""
                    fullText = "반가워요!\n저는 요망이에요"
                    startTyping1()
                    
                    displayedText2 = ""
                    fullText2 = "제가 당신을\n어떻게 부르면 될까요?"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        startTyping2()
                    }
                }
                .onChange(of: flowCount) { newValue in
                    switch newValue {
                    case 1: imageName = .yottoGown2
                        fullText = "제가 당신을 어떻게\n부르면 될까요?"
                        fullText2 = ""
                    case 2: imageName = .yottoGown3
                        fullText = "\(nickname)씨"
                        fullText2 = "라고 부르면 될까요?"
                    case 3: imageName = .yottoGown4
                        fullText = "좋아요,\n\(nickname)씨."
                        fullText2 = "당신을 파트너와\n이어드릴게요"
                    case 4: imageName = .yottoGown4
                        fullText = "연결이 완료되면\n알려드릴게요."
                        fullText2 = "기다리는 동안\n요망을 둘러볼까요?"
                    default:
                        fullText = ""
                        fullText2 = ""
                    }
                    displayedText = ""
                    displayedText2 = ""
                    startTyping1()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        startTyping2()
                    }
                }
            } // ZStack
            .ignoresSafeArea(.keyboard)
            
            VStack {
                Spacer()
                switch flowCount {
                case 0:
                    Button {
                        flowCount = 1
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("이름 알려주기")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1.0)
                    }
                    .disabled(displayedText < fullText || displayedText2 < fullText2)
                    
                case 1:
                    Button {
                        flowCount = 2
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("확인")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(nickname.count == 0 ? 0 : 1.0)
                    }
                    .disabled(displayedText < fullText || displayedText2 < fullText2)                    .disabled(nickname.count == 0)
                    
                case 2:
                    Button {
                        flowCount = 3
                        viewModel.setUsername(username: nickname)
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("응, 이대로 불러줘")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1)
                    }
                    .disabled(displayedText < fullText || displayedText2 < fullText2)
                    
                    Button {
                        flowCount = 1
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.clear)
                            .frame(height: 56)
                            .overlay(
                                Text("그건 내 이름이 아니야")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1)
                    }
                    .disabled(displayedText < fullText || displayedText2 < fullText2)
                    
                case 3:
                    if matchingIdFromUrl == nil {
                        ShareLink(item: URL(string: viewModel.shareLink)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .overlay(
                                    Text("파트너 연결 링크 공유하기")
                                        .foregroundColor(.black)
                                        .font(.title3)
                                        .bold()
                                )
                                .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1)
                        }
                        .disabled(displayedText < fullText || displayedText2 < fullText2)
                        .simultaneousGesture(TapGesture().onEnded {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                flowCount = 4
                            }
                        })
                    }
                    
                case 4:
                    Button {
                        flowCount = 5
                        navigateToYomangView = true
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("요망 둘러보기")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1)
                    }
                    .disabled(displayedText < fullText || displayedText2 < fullText2)
                    
                    if matchingIdFromUrl == nil {
                        ShareLink(item: URL(string: viewModel.shareLink)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.clear)
                                .frame(height: 56)
                                .overlay(
                                    Text("파트너 연결 링크 공유하기")
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                        .bold()
                                )
                                .opacity(displayedText < fullText || displayedText2 < fullText2 ? 0.3 : 1)
                        }
                        .disabled(displayedText < fullText || displayedText2 < fullText2)
                    }
                    
                default: EmptyView()
                }
                
            } // VStack
            .padding()
            
            if flowCount == 5 {
                YomangView(matchingIdFromUrl: $matchingIdFromUrl)
                
            }
            
        } // ZStack
    }
    
    private func startTyping1() {
        let typingInterval = 0.05
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
    
    private func startTyping2() {
        let typingInterval = 0.05
        var currentIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if currentIndex < fullText2.count {
                let index = fullText2.index(fullText2.startIndex, offsetBy: currentIndex)
                displayedText2 += String(fullText2[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}
