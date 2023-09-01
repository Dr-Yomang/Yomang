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
    @ObservedObject private var viewModel = SettingViewModel()
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
                        MyAccountView(vm: viewModel)
                    } label: {
                        HStack {
                            Image(systemName: .personFill)
                            Text(String.buttonMyProfile)
                        }
                    }
                }
                
                Section(header: Text(String.headerTitleMyUsage)) {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: .person2Fill)
                            Text(String.buttonConnectPartner)
                        }
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
                    HStack {
                        Image(systemName: "person.crop.square")
                        Text("위젯 설정")
                        Spacer()
                        Button {
                            // 위젯설정뷰로 이동
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .opacity(0.5)
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
    private func verifyThenUploadNewUsername() {
        if username.count > 0, username.count < 11 {
            viewModel.changeUsername(username) {
                isUploadInProgress = false
            }
        } else {
            
        }
    }
}
