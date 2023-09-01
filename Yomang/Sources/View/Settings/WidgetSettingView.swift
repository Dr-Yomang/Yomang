//
//  WidgetSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct WidgetSettingView: View {
    var body: some View {
        ScrollView(content: {
            VStack {
                HStack {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Spacer()
                    Text("위젯 설정")
                        .bold()
                        .font(.title2)
                        .padding(.leading, -32.0)
                    Spacer()
                }
                .padding(.bottom, 42)
                
                Text("요망은 당신과 파트너의 홈 화면에 위젯으로 서로의 사진을 주고 받는 서비스예요.\n\n아래의 단계별 설명에 따라 위젯을 설정해주세요.")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 39)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                
                Image("WidgetSettingImg1")
                    .padding(.bottom, 24)
                Image("WidgetSettingImg2")
                    .padding(.bottom, 24)
                Image("WidgetSettingImg3")
                    .padding(.bottom, 24)
            }
        })
    }
}
