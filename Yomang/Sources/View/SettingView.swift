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

struct PartnerConnectionSettingView: View {
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
            .padding(.bottom, 35)
            HStack {
                Text("연결된 파트너")
                    .padding(.leading, 20)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                Text("까망토끼")
                    .bold()
                    .foregroundColor(.black)
                    .background(                  RoundedRectangle(cornerRadius: 12)
                        .frame(width: 82, height: 28))
                    .padding(.leading, 14)
                Spacer()
            }
            .padding(.bottom, 44)
            Button(action: {
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(hex: 0x1C1C1D))
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                    HStack {
                        Text("연결 끊기")
                            .font(.subheadline)
                            .foregroundStyle(Color(hex: 0x8A42FF))
                            .padding(.leading, 32)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.white)
                            .padding(.trailing, 25)
                    }
                }
            })
            Spacer()
        }
    }
}

struct PartnerNotConnectedSettingView: View {
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
                Text("연결된 파트너가 없어요.")
                    .padding(.leading, 20)
                    .foregroundStyle(Color(hex: 0xC7C7CC))
                Spacer()
            }
            .padding(.bottom, 51)
            Button(action: {
                // TODO: 새로 연결하기 기능
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(hex: 0x1C1C1D))
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                    HStack {
                        Text("새로 연결하기")
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                            .padding(.leading, 32)
                        Spacer()
                    }
                }
            })
            .padding(.bottom, 10)
            Button(action: {
                // TODO: 끊어진 연결 복구하기
            }, label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(hex: 0x1C1C1D))
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                    HStack {
                        Text("끊어진 연결 복구하기")
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                            .padding(.leading, 32)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.white)
                            .padding(.trailing, 25)
                    }
                }
            })
            Spacer()
        }
    }
}

struct DisconnectSettingView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Spacer()
                Text("연결 끊기")
                    .bold()
                    .font(.title2)
                    .padding(.leading, -32.0)
                Spacer()
            }
            .padding(.bottom, 42)
            Text("파트너와의 연결을 끊게 되면 연결은 물론 함께 나누며 쌓아온 요망도 모두 사라지게 돼요.\n\n끊어진 연결과 쌓아왔던 요망은 n일까지만 복구할 수 있고, 그 이후에는 복구할 수 없어요.")
                .padding(.horizontal, 20)
                .foregroundStyle(Color(hex: 0xC7C7CC))
            HStack {
                Text("정말로 파트너와의 연결을 끊으시겠어요?")
                    .padding(.leading, 20)
                    .padding(.top, 15)
                    .bold()
                    .foregroundStyle(Color(hex: 0x8A42FF))
                Spacer()
            }
            Spacer()
            Button(action: {}, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 56)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color(hex: 0x1C1C1D))
                    Text("연결 끊기")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(Color(hex: 0x8A42FF))
                }
            })
        }
    }
}

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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSettingView()
    }
}
