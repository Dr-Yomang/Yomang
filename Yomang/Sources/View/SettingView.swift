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
    
    enum AlertType {
        case goToSetting
        case usernameLengthLimit
    }
    @Environment(\.dismiss) private var dismiss
    @State private var isSignOutInProgress = false
    @State private var selectedImage: PhotosPickerItem?
    @State private var editUsername = false
    @State private var username = ""
    @State private var isUploadInProgress = false
    @State private var sureToDeletePartner = false
    @ObservedObject private var viewModel = SettingViewModel()
    // MARK: - instant alert 관련
    @State private var alertType = AlertType.goToSetting
    @State private var showInstantAlert = false
    @State private var instantAlertTitle = ""
    @State private var instantAlertMessage = ""
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                // MARK: - 프로필 이미지
                ZStack {
                    if let profileImgUrl = viewModel.profileImageUrl {
                        KFImage(URL(string: profileImgUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image("yt_surprise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    
                    Text(viewModel.username!)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white)
                        .cornerRadius(12)
                        .offset(y: 60)
                }
                .padding(.bottom, 20)
                
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
                Section(header: Text(String.headerTitleSettingProfile)) {
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
                Section(header: Text(String.headerTitleMyUsage)) {
                    // MARK: - 파트너 연결 끊기
                    Button {
                        sureToDeletePartner = true
                    } label: {
                        HStack {
                            Image(systemName: .person2Slash)
                            Text(String.buttonConnectPartner)
                        }
                        .foregroundColor(.red)
                    }
                    // MARK: - 알림 설정 ([설정]앱으로 이동)
                    HStack {
                        Image(systemName: .bellFill)
                        Text(String.buttonSettingNotification)
                        Spacer()
                        Text(viewModel.alertAuthorizationStatus)
                            .foregroundColor(.gray)
                        Button {
                            setInstantAlert(title: "[설정]으로 이동할게요",
                                            message: "[설정] - [알림]에서 알림을 허용해 주세요",
                                            type: .goToSetting)
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                        
                    }
                }
                Section {
                    // MARK: - Sign out
                    Button {
                        isSignOutInProgress = true
                        AuthViewModel.shared.signOut {
                            isSignOutInProgress = false
                        }
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .foregroundColor(.red)
                        }
                        
                    }
                }
            }
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
    }
    
    private func deleteUserAction() {
        isUploadInProgress = true
        viewModel.deletePartner {
            AuthViewModel.shared.fetchUser { _ in
                isUploadInProgress = false
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
