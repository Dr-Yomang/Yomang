//
//  WidgetSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct WidgetSettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(content: {
            VStack {
                Text("요망은 당신과 파트너의 홈 화면에 위젯으로 서로의 사진을 주고 받는 서비스예요.\n\n아래의 단계별 설명에 따라 위젯을 설정해주세요.")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 39)
                    .padding(.top, 42)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                
                Image("WidgetSettingImg1")
                    .padding(.bottom, 24)
                Image("WidgetSettingImg2")
                    .padding(.bottom, 24)
                Image("WidgetSettingImg3")
                    .padding(.bottom, 24)
            }
            .navigationTitle("위젯 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: .chevronBackward)
                            .foregroundColor(.white)
                    }
                }
            }
        })
    }
}
