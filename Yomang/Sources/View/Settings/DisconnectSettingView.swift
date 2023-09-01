//
//  DisconnectSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct DisconnectSettingView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Spacer()
                Text("연결 끊기")
                    .bold()
                    .font(.title2)
                    .padding(.leading, -32.0)
                Spacer()
            }
            .padding(.bottom, 42)
            Text("파트너와의 연결을 끊게 되면 연결은 물론 함께 나누며 쌓아온 요망도 모두 사라지게 돼요.\n\n끊어진 연결과 쌓아왔던 요망은 n일까지만 복구할 수 있고, 그 이후에는 복구할 수 없어요.")
                .padding(.horizontal, 20)
                .foregroundStyle(Color(hex: 0xC7C7CC))
            HStack {
                Text("정말로 파트너와의 연결을 끊으시겠어요?")
                    .padding(.leading, 20)
                    .padding(.top, 15)
                    .bold()
                    .foregroundStyle(Color(hex: 0x8A42FF))
                Spacer()
            }
            Spacer()
            Button(action: {}, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color(hex: 0x1C1C1D))
                    Text("연결 끊기")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color(hex: 0x8A42FF))
                }
            })
        }
    }
}
