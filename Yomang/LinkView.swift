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
    @State private var fullText = "반가워요!\n저는 요망이에요"
    @State var nickname = ""
    private let typingInterval = 0.08
    
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
                    switch flowCount {
                    case 0: Text(displayedText)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear {
                                startTyping()
                            }
                    case 1: Text(displayedText)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear {
                                startTyping()
                            }
                        TextField("별명", text: $nickname)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(.title)
                            .frame(height: 60)
                            .border(Color.white)
                    case 2: Text(displayedText)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear {
                                startTyping()
                            }
                    case 3: Text(displayedText)
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .onAppear {
                                startTyping()
                            }
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                }
            }//ZStack
            .ignoresSafeArea(.keyboard)
            
            VStack {
                Spacer()
                switch flowCount {
                case 0:
                    Button(action: {
                        displayedText = ""
                        fullText = "제가 당신을 어떻게\n부르면 될까요?"
                        flowCount += 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("다음으로")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                            )
                    }
                case 1:
                    Button(action: {
                        displayedText = ""
                        fullText = "좋아요!\n\(nickname)씨."
                        flowCount += 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("확인")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                            )
                    }
                case 2:
                    Button(action: {
                        displayedText = ""
                        fullText = "제가 당신을 어떻게\n부르면 될까요?"
                        flowCount -= 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray)
                            .frame(height: 56)
                            .overlay(
                                Text("제 이름이 아니에요")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                            )
                    }
                    Button(action: {
                        displayedText = ""
                        fullText = "상대방과의 연결을\n기다리는 동안\n요망을 둘러볼까요?"
                        flowCount += 1
                    })
                    {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("연결링크 공유하기")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                            )
                    }
                case 3:  Button(action: {
                    displayedText = ""
                    fullText = ""
                    flowCount += 1
                })
                {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .overlay(
                            Text("요망 둘러보기")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                        )
                }
                default:
                    EmptyView()
                }
            }//VStack
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
    
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
