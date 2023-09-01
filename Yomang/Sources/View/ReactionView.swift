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
    @ObservedObject var viewModel: YourYomangViewModel
    @Binding var lottieName: String
    @Binding var isLottiePlayed: Bool
    let data: YomangData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(height: UIScreen.height * 0.095)
                .opacity(0.2)

            HStack(spacing: UIScreen.width * 0.07) {
                Button {
                    reactAction(lottieName: "yt_thumbsUp")
                } label: {
                    ReactionButtonView(imageName: "yt_thumbsUp")
                }
                Button {
                    reactAction(lottieName: "yt_love")
                } label: {
                    ReactionButtonView(imageName: "yt_love")
                }
                Button {
                    reactAction(lottieName: "yt_laugh")
                } label: {
                    ReactionButtonView(imageName: "yt_laugh")
                }
                Button {
                    reactAction(lottieName: "yt_sad")
                } label: {
                    ReactionButtonView(imageName: "yt_sad")
                }
            }
            if animationInProgress {
                LottieView(name: lottieName, loopMode: .playOnce)
                    .ignoresSafeArea()
            }
        }
    }
    
    private func reactAction(lottieName: String) {
//        let data = viewModel.data[yomangIndex]
//        guard let yomangId = data.id else { return }
//        let originEmoji = data.emoji ?? []
//        if !originEmoji.contains(lottieName) {
//            viewModel.reactToYourYomang(yomangId: yomangId, originEmoji: originEmoji, emojiName: lottieName)
//        }
        guard let id = data.id else { return }
        self.lottieName = lottieName
        self.isLottiePlayed = true
        let originEmoji = data.emoji ?? []
        viewModel.reactToYourYomang(yomangId: id, originEmoji: originEmoji, emojiName: lottieName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLottiePlayed = false
            
        }
    }
}
