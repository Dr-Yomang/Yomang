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
    @State private var isWaveEffect: Bool = false
    @State private var effectOpacityToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var effectSizeToggle: [Bool] = Array(repeating: false, count: 5)
    @State var isShownSheet = false
    @ObservedObject var viewModel = YourYomangViewModel()
    @Binding var matchingIdFromUrl: String?
    
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
                        .ignoresSafeArea()
                )
            ZStack {
                if isWaveEffect {
                    ForEach(0 ..< 5) { index in
                        EffectLoadingView(effectOpacityToggle: effectOpacityToggle[index], effectSizeToggle: effectSizeToggle[index], delayTime: 0.2 * Double(index))
                    }
                    .scaleEffect(isScaleEffect ? 1.05 : 1)
                }
                
                YomangImageView(data: viewModel.data, index: $index)
                    .onTapGesture {
                        DispatchQueue.main.async {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            isWaveEffect = true
                            withAnimation(.easeIn(duration: 0.3)) {
                                isScaleEffect = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            withAnimation(.easeOut(duration: 0.5)) {
                                isScaleEffect = false
                                isWaveEffect = false
                            }
                        }
                    }
                    .scaleEffect(isScaleEffect ? 1.05 : 1)
                
                if viewModel.data.count == 0 {
                    Text("상대방의 첫 요망을\n기다리고 있어요!")
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .scaleEffect(isScaleEffect ? 1.05 : 1)
                }
            }
            .frame(width: UIScreen.width - Constants.yomangPadding,
                   height: UIScreen.width - Constants.yomangPadding)
            .offset(y: -56)
            
            VStack {
                if viewModel.connectWithPartner {
                    if viewModel.data.count > 0 {
                        ReactionView(viewModel: viewModel, yomangIndex: $index)
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
                    }
                }
            }
            .padding(Constants.yomangPadding / 2)
            .offset(y: UIScreen.width / 2.2)
            
            VStack {
                Text(viewModel.partner?.username ?? "소중한 그대")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        ZStack {
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                                .opacity(0.8)
                                .overlay {
                                    if let imageUrl = viewModel.partnerImageUrl {
                                        KFImage(URL(string: imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    } else {
                                        Image("Yotto")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .offset(x: 5)
                                    }
                                }
                                .overlay(
                                    Circle()
                                        .strokeBorder(style: StrokeStyle(lineWidth: 3))
                                        .foregroundColor(.white)
                                )
                                .offset(y: -56)
                                .scaleEffect(isScaleEffect ? 1.05 : 1)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 48)
                        }
                    )
            }
            .offset(y: -UIScreen.width / 1.45)
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
}

struct YourYomangView_Previews: PreviewProvider {
    @State static var matchingId: String? = "itms-apps://itunes.apple.com/app/6461822956"
    
    static var previews: some View {
        YourYomangView(viewModel: YourYomangViewModel(), matchingIdFromUrl: $matchingId)
    }
}

struct EffectLoadingView: View {
    
    @State var effectOpacityToggle: Bool
    @State var effectSizeToggle: Bool
    let delayTime: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(Color.white, lineWidth: effectSizeToggle ? 1 : 2)
            .scaleEffect(effectSizeToggle ? 1.8 : 1)
            .opacity(effectOpacityToggle ? 0 : 0.5)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                        effectOpacityToggle = true
                        effectSizeToggle = true
                    }
                }
            }
            .scaledToFit()
    }
}
