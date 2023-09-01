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
    @State private var isLengthZero = false
    @State private var isUploadInProgress = false
//    @State private var showAlert = false
    @ObservedObject private var viewModel = SettingViewModel()
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
                
                Section(header: Text(String.headerTitleMyUsage)) {
                    Button {
                        viewModel.deletePartner {
                            AuthViewModel.shared.fetchUser { _ in
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: .person2Slash)
                            Text(String.buttonConnectPartner)
                        }
                        .foregroundColor(.white)
                    }
                    HStack {
                        Image(systemName: .bellFill)
                        Text(String.buttonSettingNotification)
                        Spacer()
                        Text(viewModel.alertAuthorizationStatus)
                            .foregroundColor(.gray)
                        Button {
                            // TODO: - 유저에게 설정으로 이동한다고 고지하기 + 앱 화면에는 설정이 바로 반영되지 않을 수 있음도 알리기
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
            Button("변경", action: verifyThenUploadNewUsername)
            Button("취소", role: .cancel) {
                editUsername = false
            }
        } message: {
            Text("변경할 닉네임을 입력하세요.")
        }
        .alert("닉네임을 다시 입력해 주세요", isPresented: $isLengthZero) {
            Button("확인", role: .cancel) {
                isLengthZero = false
            }
        } message: {
            Text("닉네임의 길이는 1자 이상 10자 이하여야 합니다.")
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
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
