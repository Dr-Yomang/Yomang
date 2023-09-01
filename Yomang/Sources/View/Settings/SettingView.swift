//
//  SettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isSignOutInProgress = false
    @State private var selectedImage: PhotosPickerItem?
    @State private var editUsername = false
    @State private var username = ""
    @State private var isUploadInProgress = false
    @State private var sureToDeletePartner = false
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                // MARK: - 프로필 이미지
                ZStack {
                    if let profileImgUrl = viewModel.profileImageUrl {
                        KFImage(URL(string: profileImgUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 112, height: 112)
                            .clipShape(Circle())
                    } else {
                        Image("yt_surprise")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 112, height: 112)
                            .clipShape(Circle())
                    }
                    
                    Text(viewModel.username ?? "")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white)
                        .cornerRadius(12)
                        .offset(y: 60)
                }
                .padding(.bottom, 26)
                
                NavigationLink {
                    ProfileView(viewModel: viewModel)
                } label: {
                    Text("프로필 설정 변경하기")
                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.8))
                        .font(.caption)
                }
                .navigationTitle("설정 및 개인정보")
            }
            List {
                Section(header: Text(String.headerTitleSettingProfile).font(.headline)) {
                    NavigationLink {
                        MyAccountView(viewModel: viewModel)
                    } label: {
                        HStack {
                            Image(systemName: .personFill)
                            Text(String.buttonMyProfile)
                        }
                    }
                }
                
                // MARK: - Section. 내 사용
                Section(header: Text(String.headerTitleMyUsage).font(.headline)) {
                    // MARK: - 파트너 연결 끊기
                    NavigationLink {
                        PartnerConnectionSettingView(viewModel: viewModel)
                    }
                label: {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("파트너 연결")
                    }
                    .foregroundColor(Color.white)
                }
                    // MARK: - 알림 설정 ([설정]앱으로 이동)
                    NavigationLink {
                        NotificationSettingView(viewModel: viewModel)
                    } label: {
                        HStack {
                            Image(systemName: .bellFill)
                            Text("알림 설정")
                        }
                    }
                    
                    NavigationLink {
                        WidgetSettingView()
                    } label: {
                        HStack {
                            Image(systemName: "heart.square")
                            Text("위젯 설정")
                        }
                    }
                    
                }
            }
            .scrollDisabled(true)
            .navigationTitle(String.navigationTitleSetting)
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
            if isSignOutInProgress {
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchSettingData()
        }
    }
    
    private func deleteUserAction() {
        isUploadInProgress = true
        viewModel.deletePartner {
            AuthViewModel.shared.fetchUser {
                isUploadInProgress = false
            }
        }
    }
}
