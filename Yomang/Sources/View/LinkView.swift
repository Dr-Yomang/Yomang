//
//  LinkView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/11.
//

import SwiftUI

struct LinkView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var displayedTextTop = ""
    private let fullTextTop = "반가워요!\n저는 요망이에요"
    @State private var displayedTextBottom = ""
    private let fullTextBottom = "당신을 파트너와\n이어드릴게요"
    
    @State private var jumpToggle = false
    @State private var rotationToggle = false
    
    var body: some View {
        ZStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: UIScreen.height * 0.1)
                    
                    Text(displayedTextTop)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    Image(.yottoGown1)
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
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                                jumpToggle.toggle()
                            }
                        }
                    
                    Text(displayedTextBottom)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .shadow(color: .gray, radius: 4, x: 0, y: 2)
                    
                    Spacer()
                }
                .onAppear {
                    displayedTextTop = ""
                    startTyping1()
                    displayedTextBottom = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        startTyping2()
                    }
                }
            } // ZStack
            .ignoresSafeArea(.keyboard)
            
            VStack {
                Spacer()
                Button {
                    viewModel.matchingIdFromUrl = ""
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.clear)
                        .frame(height: 56)
                        .overlay(
                            Text("요망 둘러보기")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .bold()
                        )
                        .opacity(displayedTextTop.count < fullTextTop.count || displayedTextBottom.count < fullTextBottom.count ? 0.3 : 1)
                }
                .disabled(displayedTextTop.count < fullTextTop.count || displayedTextBottom.count < fullTextBottom.count)
                
                if viewModel.matchingIdFromUrl == nil {
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
                            .opacity(displayedTextTop.count < fullTextTop.count || displayedTextBottom.count < fullTextBottom.count ? 0.3 : 1)
                    }
                    .disabled(displayedTextTop.count < fullTextTop.count || displayedTextBottom.count < fullTextBottom.count)
                }
            } // VStack
            .padding()
        } // ZStack
    }
    
    private func startTyping1() {
        let typingInterval = 0.05
        var currentIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if currentIndex < fullTextTop.count {
                let index = fullTextTop.index(fullTextTop.startIndex, offsetBy: currentIndex)
                displayedTextTop += String(fullTextTop[index])
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
            if currentIndex < fullTextBottom.count {
                let index = fullTextBottom.index(fullTextBottom.startIndex, offsetBy: currentIndex)
                displayedTextBottom += String(fullTextBottom[index])
                currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
        timer.fire()
    }
}
