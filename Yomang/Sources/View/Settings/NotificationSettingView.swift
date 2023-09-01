//
//  NotificationSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct NotificationSettingView: View {
    @State private var isNotificationActivated: Bool = true
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingViewModel
    
    @State private var showInstantAlert = false
    private let instantAlertTitle = "[설정]으로 이동할게요"
    private let instantAlertMessage = "[설정] - [알림]에서 알림을 허용해 주세요"
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.isAlertOn {
                    Text("알림이 켜져있어요.")
                        .padding(.leading, 20)
                        .foregroundStyle(Color(hex: 0xC7C7CC))
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            showInstantAlert = true
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
                        showInstantAlert = true
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
            
            if viewModel.isAlertOn {
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
        .onAppear {
            viewModel.queryAuthorizationStatus()
        }
        .alert(Text(instantAlertTitle), isPresented: $showInstantAlert) {
            Button {
                showInstantAlert = false
                dismiss()
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            } label: {
                Text("확인")
            }
        } message: {
            Text(instantAlertMessage)
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
}
