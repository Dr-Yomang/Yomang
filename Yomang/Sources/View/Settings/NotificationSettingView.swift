//
//  NotificationSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct NotificationSettingView: View {
    
    @State var isNotificationActivated: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Spacer()
                Text("파트너 연결")
                    .bold()
                    .font(.title2)
                    .padding(.leading, -32.0)
                Spacer()
            }
            .padding(.bottom, 42)
            
            HStack {
                if isNotificationActivated {
                    Text("알림이 켜져있어요.")
                        .padding(.leading, 20)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                    
                    Spacer()
                    
                    Button(action: {
                        isNotificationActivated.toggle()
                    }, label: {
                        Text("알림 끄기")
                            .foregroundStyle(Color.white)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .padding(.horizontal, -15)
                                    .padding(.vertical, -6)
                                    .foregroundStyle(Color(hex: 0x1C1C1D)))
                            .padding(.trailing, 20)
                    })
                } else {
                    Text("알림이 꺼져있어요.")
                        .padding(.leading, 20)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                    
                    Spacer()
                    
                    Button(action: {
                        isNotificationActivated.toggle()
                    }, label: {
                        Text("알림 켜기")
                            .foregroundStyle(Color.white)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .padding(.horizontal, -15)
                                    .padding(.vertical, -6)
                                    .foregroundStyle(Color(hex: 0x1C1C1D)))
                            .padding(.trailing, 20)
                    })
                }
            }
            .padding(.bottom, 6)
            
            if isNotificationActivated {
                HStack {
                    Text("기기 설정에서 알림을 끌 수 있어요.")
                        .padding(.leading, 20)
                        .foregroundStyle(Color(hex: 0x8A42FF))
                        .font(.subheadline)
                    Spacer()
                }
            } else {
                HStack {
                    Text("기기 설정에서 알림을 켤 수 있어요.")
                        .padding(.leading, 20)
                        .foregroundStyle(Color(hex: 0x8A42FF))
                        .font(.subheadline)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
