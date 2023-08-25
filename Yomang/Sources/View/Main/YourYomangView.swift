//
//  YourYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import Foundation
import SwiftUI

struct YourYomangView: View {
    
    @State private var index = 0
    
    @State private var isScaleEffect: Bool = false
    @State private var isWaveEffect: Bool = false
    @State private var effectOpacityToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var effectSizeToggle: [Bool] = Array(repeating: false, count: 5)
    @ObservedObject var viewModel: YourYomangViewModel
    @Binding var matchingIdFromUrl: String?
    
    var body: some View {
        ZStack {
            Image("YomangMoon")
                .resizable()
                .scaledToFit()
                .frame(width: 1800, height: 1800)
                .offset(x: UIScreen.width / 2, y: 1050)
                .ignoresSafeArea()
            
            ZStack {
                ForEach(0 ..< 5) { index in
                    EffectLoadingView(effectOpacityToggle: effectOpacityToggle[index], effectSizeToggle: effectSizeToggle[index], delayTime: 0.4 * Double(index))
                }
                .opacity(isWaveEffect ? 1 : 0)
                
                YomangImageView(data: viewModel.data, index: $index)
                    .scaleEffect(isScaleEffect ? 1.05 : 1)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged {_ in
                                withAnimation(.easeIn(duration: 0.2)) {
                                    isScaleEffect = true
                                    isWaveEffect = true
                                }
                            }
                            .onEnded {_ in
                                withAnimation(.easeIn(duration: 1)) {
                                    isScaleEffect = false
                                    isWaveEffect = false
                                }
                            }
                    )
                
                if viewModel.data.count == 0 {
                    Text("상대방의 첫 요망을 기다리고 있어요")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .frame(width: UIScreen.width - Constants.yomangPadding,height: UIScreen.width - Constants.yomangPadding)
            .offset(y: -56)
            
            if viewModel.connectWithPartner {
                ReactionView(viewModel: viewModel, yomangIndex: $index)
            } else {
                VStack {
                    Spacer()
                    ShareLink(item: URL(string: "YomanglabYomang://share?value=\(String(describing: AuthViewModel.shared.user?.id))")
                              ?? URL(string: "itms-apps://itunes.apple.com/app/6461822956")!) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("파트너 연결 링크 다시 보내기")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
                            )
                    }
                }
                .onAppear {
                    if !viewModel.connectWithPartner {
                        if let pid = matchingIdFromUrl {
                            AuthViewModel.shared.matchTwoUser(partnerId: pid)
                        }
                    }
                }
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
