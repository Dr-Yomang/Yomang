//
//  YourYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import Foundation
import SwiftUI
import Kingfisher

struct YourYomangView: View {
    
    @State private var index = 0
    @State private var isScaleEffect: Bool = false
    @State var isShownSheet = false
    @Binding var selectedTag: Int
    @ObservedObject var viewModel = YourYomangViewModel()
    @State private var lottieName: String = ""
    @State private var isLottiePlayed: Bool = false
    
    @AppStorage("hasSeenOnboarding", store: UserDefaults.standard) var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            Color.black
                .overlay(
                    Image("YomangMoon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1800, height: 1800)
                        .offset(x: UIScreen.width / 2, y: 1100)
                )
            VStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .opacity(0.4)
                    .overlay {
                        if let imageUrl = viewModel.partnerImageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(.yottoGown2)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80)
                                .offset(x: -5, y: 21)
                                .clipShape(Circle())
                        }
                    }
                    .offset(y: 32)
                
                Text(viewModel.partner?.username ?? "소중한 그대")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 36)
                    )
                
                ZStack {
                    YomangImageView(data: viewModel.data, index: $index)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation(.easeIn(duration: 0.1)) {
                                    isScaleEffect = true
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isScaleEffect = false
                                }
                            }
                        }
                        .scaleEffect(isScaleEffect ? 0.95 : 1)

                    if !viewModel.connectWithPartner && viewModel.data.count == 0 {
                        Text("파트너와의 연결을\n기다리고 계시군요!")
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .scaleEffect(isScaleEffect ? 0.95 : 1)
                    }
                    
                    if viewModel.connectWithPartner && viewModel.data.count == 0 {
                        Text("상대와 연결되었어요!\n첫 요망을 기다려볼까요?")
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                            .scaleEffect(isScaleEffect ? 0.95 : 1)
                    }
                }
                .frame(width: UIScreen.width - (Constants.widgetPadding * 2),
                       height: (UIScreen.width - (Constants.widgetPadding * 2)) * 1.05)
                
                if viewModel.connectWithPartner {
                    if viewModel.data.count > 0 {
                        ReactionView(viewModel: viewModel, lottieName: $lottieName, isLottiePlayed: $isLottiePlayed, data: viewModel.data[0])
                            .frame(width: UIScreen.width - (Constants.widgetPadding * 2))
                            .padding(.vertical)
                    }
                } else {
                    ShareLink(item: URL(string: AuthViewModel.shared.shareLink)!) {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("파트너 연결 링크 다시 보내기")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            )
                            .frame(width: UIScreen.width - (Constants.widgetPadding * 2))
                            .padding(.vertical)
                    }
                }
                Spacer()
            }
            .offset(y: -16)
            
            if isLottiePlayed {
                LottieView(name: lottieName)
                    .ignoresSafeArea()
            }
            
        }
        .onChange(of: self.selectedTag, perform: { tag in
            guard tag == 1 else { return }
            viewModel.fetchYourYomang()
        })
        .onAppear {
            if !hasSeenOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isShownSheet = true
                    self.hasSeenOnboarding = true
                }
            }
        }
        .sheet(isPresented: $isShownSheet) {
            OnboardingView(isShownSheet: $isShownSheet)
        }
    }
}
