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
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(width: UIScreen.width - 40, height: 80)
                .opacity(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3))
                        .foregroundColor(.white)
                        .frame(height: 80)
                        .opacity(0.5)
                )
            HStack(spacing: 24) {
                Button {
                    reactAction(selectedIndex: 0, lottieName: "yt_aeng")
                } label: {
                    ReactionButtonView(imageName: "yt_aeng")
                }
                Button {
                    reactAction(selectedIndex: 1, lottieName: "yt_great")
                } label: {
                    ReactionButtonView(imageName: "yt_great")
                }
                Button {
                    reactAction(selectedIndex: 1, lottieName: "yt_love")
                } label: {
                    ReactionButtonView(imageName: "yt_love")
                }
                Button {
                    reactAction(selectedIndex: 1, lottieName: "yt_surprise")
                } label: {
                    ReactionButtonView(imageName: "yt_surprise")
                }
            }
            if animationInProgress {
                LottieView(animationInProgress: $animationInProgress, lottieName: lottieName)
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

struct ReactionView_Previews: PreviewProvider {
    @State static var index = 0
    static var previews: some View {
        ReactionView(viewModel: YourYomangViewModel(), yomangIndex: $index)
    }
}
