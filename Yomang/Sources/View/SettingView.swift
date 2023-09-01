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
        ZStack {
            List {
                Section {
                    HStack(spacing: 20) {
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
                            Circle()
                                .trim(from: 0.08, to: 0.42)
                                .frame(width: 120, height: 120)
                                .foregroundColor(.black)
                                .opacity(0.7)
                            
                            PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                                VStack {
                                    Spacer()
                                    
                                    Text("편집")
                                        .foregroundColor(.white)
                                        .padding(.bottom, 8)
                                }
                                .frame(width: 120, height: 120)
                            }
                            .disabled(isUploadInProgress)
                            if isUploadInProgress {
                                Circle()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.black)
                                    .opacity(0.7)
                                ProgressView()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            }
                        }
                        // MARK: - 닉네임
                        VStack(alignment: .leading, spacing: 10) {
                            Text(viewModel.username!)
                                .font(.headline)
                            Text("닉네임 변경")
                                .font(.caption)
                                .onTapGesture {
                                    editUsername = true
                                }
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text(String.headerTitleSettingProfile)) {
                    NavigationLink {
                        EmptyView()
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
            
            // MARK: - 탈퇴하기
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        AuthViewModel.shared.deleteUser()
                    } label: {
                        Text("탈퇴하기")
                            .foregroundColor(.gray)
                            .font(.system(size: 5))
                        // TODO: - 탈퇴 이후 플로우가 너무 많아서 지금 버그 투성ㅇㅣ...최대한 가리는게 좋을 것 같은ㄷ ㅔ....
                            .padding(.trailing, 20)
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
        .alert("닉네임 변경", isPresented: $editUsername) {
            TextField("\(viewModel.username ?? "새 닉네임")", text: $username)
                .textInputAutocapitalization(.never)
            Button("변경할게요", action: verifyThenUploadNewUsername)
            Button("취소", role: .cancel) {
                editUsername = false
            }
        } message: {
            Text("변경할 닉네임을 입력하세요.")
        }
        .alert(instantAlertTitle, isPresented: $showInstantAlert) {
            Button("확인했어요", role: .cancel) {
                showInstantAlert = false
                if alertType == .goToSetting {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        } message: {
            Text(instantAlertMessage)
        }
        .alert("정말 상대방과의 연결을 끊으시겠어요?", isPresented: $sureToDeletePartner) {
            Button("네, 끊을게요", role: .destructive, action: deleteUserAction)
            Button("취소할게요", role: .cancel) {
                sureToDeletePartner = false
            }
        }message: {
            Text("주고받은 모든 요망이 즉시 삭제돼요")
        }
        .onChange(of: selectedImage) { newItem in
            Task {
                isUploadInProgress = true
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    guard let image = UIImage(data: data) else { return }
                    viewModel.changeProfileImage(image: image) { _ in
                        viewModel.fetchProfileImageUrl()
                        isUploadInProgress = false
                    }
                }
            }
        }
    }
    
    private func verifyThenUploadNewUsername() {
        if username.count > 0, username.count < 11 {
            viewModel.changeUsername(username) {
                isUploadInProgress = false
            }
        } else {
            setInstantAlert(title: "닉네임을 다시 입력해 주세요",
                            message: "닉네임의 길이는 1자 이상 10자 이하여야 합니다.",
                            type: .usernameLengthLimit)
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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
