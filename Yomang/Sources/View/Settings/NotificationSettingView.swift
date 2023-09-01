//
//  NotificationSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct NotificationSettingView: View {
    
    enum AlertType {
        case goToSetting
        case usernameLengthLimit
    }
    
    @State private var isNotificationActivated: Bool = true
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingViewModel
    
    @State private var alertType = AlertType.goToSetting
    @State private var showInstantAlert = false
    @State private var instantAlertTitle = ""
    @State private var instantAlertMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                if isNotificationActivated {
                    Text("알림이 켜져있어요.")
                        .padding(.leading, 20)
                        .foregroundStyle(Color(hex: 0xC7C7CC))
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            setInstantAlert(title: "[설정]으로 이동할게요",
                                            message: "[설정] - [알림]에서 알림을 허용해 주세요",
                                            type: .goToSetting)
                        } label: {
                            Text("알림 끄기")
                                .foregroundStyle(Color.white)
                                .bold()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .padding(.horizontal, -15)
                                        .padding(.vertical, -6)
                                        .foregroundStyle(Color(hex: 0x1C1C1D)))
                                .padding(.trailing, 20)
                        }
                    }
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
            .padding(.top, 42)
            
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
        .navigationTitle("알림 설정")
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
    }
    
    private func setInstantAlert(title: String, message: String, type: AlertType) {
        instantAlertTitle = title
        instantAlertMessage = message
        showInstantAlert = true
        alertType = type
    }
    
}
