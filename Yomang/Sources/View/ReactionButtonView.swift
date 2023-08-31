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
            .foregroundColor(.white)
            .frame(width: 52)
            .overlay(
                Group {
                    switch imageName {
                    case "yt_aeng":
                        Image("yt_aeng")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52)
                            .offset(y: 5)
                            .clipShape(Circle())
                        
                    case "yt_great":
                        Image("yt_great")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52)
                            .offset(x: 3, y: 25)
                            .clipShape(Circle())

                    case "yt_love":
                        Image("yt_love")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52)
                            .offset(x: 5, y: 25)
                            .clipShape(Circle())

                    case "yt_surprise":
                        Image("yt_surprise")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 52)
                            .offset(y: 20)
                            .clipShape(Circle())

                    default:
                        EmptyView()
                    }
                }
            )
    }
}
