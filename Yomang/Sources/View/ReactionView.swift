//
//  ReactionView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/07/24.
//

import SwiftUI

struct ReactionView: View {
    @State private var isAnimationVisible: Bool = false
    @State var animationInProgress = false
    @State private var selectedIndex: Int?
    @State private var lottieName: String = ""
    @ObservedObject var viewModel: YourYomangViewModel
    @Binding var yomangIndex: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: 0x3D3D3D))
                .frame(height: 72)
                .cornerRadius(20)
                .opacity(0.7)
                .padding(.horizontal, 20)
            
            if animationInProgress {
                LottieView(animationInProgress: $animationInProgress, lottieName: lottieName)
            }
            
            Spacer()
            
            HStack {
                Button {
                    reactAction(selectedIndex: 0, lottieName: "reaction")
                } label: {
                    ReactionButtonView(color: .blue)
                }
                Button {
                    reactAction(selectedIndex: 1, lottieName: "secondreaction")
                } label: {
                    ReactionButtonView(color: .red)
                }
                
                Button {
                    reactAction(selectedIndex: 2, lottieName: "thirdreaction")
                } label: {
                    ReactionButtonView(color: .green)
                }
            }
        }
    }
    
    private func reactAction(selectedIndex: Int, lottieName: String) {
        let data = viewModel.data[yomangIndex]
        guard let yomangId = data.id else { return }
        let originEmoji = data.emoji ?? []
        if !originEmoji.contains(lottieName) {
            viewModel.reactToYourYomang(yomangId: yomangId, originEmoji: originEmoji, emojiName: lottieName)
        }
        self.animationInProgress = true
        self.selectedIndex = selectedIndex
        self.lottieName = lottieName
    }
}

struct ReactionButtonView: View {
    let color: Color
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 40)
            .padding()
    }
}
