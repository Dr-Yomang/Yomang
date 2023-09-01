//
//  ReactionButtonView.swift
//  Yomang
//
//  Created by 제나 on 2023/08/31.
//

import SwiftUI

struct ReactionButtonView: View {
    let imageName: String
    var body: some View {
        Circle()
            .foregroundColor(.white.opacity(0.2))
            .frame(width: UIScreen.width * 0.13)
            .overlay(
                Group {
                    switch imageName {
                    case "yt_sad":
                        Text("😢")
                            .font(.title)
                            .offset(x: 1)
                    case "yt_laugh":
                        Text("😂")
                            .font(.title)
                            .offset(x: 1)
                    case "yt_love":
                        Text("😍")
                            .font(.title)
                            .offset(x: 1)
                    case "yt_thumbsUp":
                        Text("👍")
                            .font(.title)
                            .offset(x: 1)
                    default:
                        EmptyView()
                    }
                }
            )
    }
}
