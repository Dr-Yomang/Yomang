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
    @Binding var yomangIndex: Int
    @Binding var lottieName: String
    @Binding var isLottiePlayed: Bool
    
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
        self.lottieName = lottieName
        self.isLottiePlayed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLottiePlayed = false
        }
    }
}

struct ReactionView_Previews: PreviewProvider {
    @State static var index = 0
    @State static var isLottiePlayed = false
    @State static var lottieName = "yt_love"
    static var previews: some View {
        ReactionView(viewModel: YourYomangViewModel(), yomangIndex: $index, lottieName: $lottieName, isLottiePlayed: $isLottiePlayed)
    }
}
