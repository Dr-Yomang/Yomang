//
//  ProfileView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/09/01.
//

import SwiftUI
import Combine
import Kingfisher
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel: SettingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImage: PhotosPickerItem?
    @State private var isLengthZero = false
    @State private var isUploadInProgress = false
    @State private var username = ""
    @State private var isAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                if let profileImgUrl = viewModel.profileImageUrl {
                    KFImage(URL(string: profileImgUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 178, height: 178)
                        .clipShape(Circle())
                        .padding(.top, 10)
                    
                } else {
                    Image("yt_surprise")
                        .resizable()
                        .frame(width: 178, height: 178)
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(.top, 10)
                }
                
                if isUploadInProgress {

                    Circle()
                        .frame(width: 178, height: 178)
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .padding(.top, 10)
                    ProgressView()
                        .frame(width: 178, height: 178)
                        .clipShape(Circle())
                }
            }.alert(isPresented: $isAlert) {
                Alert(title: Text("설정한 이름은 11자 이상으로 설정할 수 없습니다."), message: Text("이름을 다시 설정해주세요. "), dismissButton: .cancel(Text("확인")) )
            }
            PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                VStack {
                    Text("사진 변경하기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.8))
                        .padding(.bottom, 8)
                }
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
            .disabled(isUploadInProgress)
            
            HStack(spacing: 20) {
                Text("이름")
                    .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.8))
                    .font(.system(size: 16))
                
                VStack {
                    TextField(viewModel.username!, text: $username)
                        .font(.system(size: 20))
                        .textInputAutocapitalization(.never)
                        .frame(width: 256)
                    
                    Rectangle()
                        .frame(width: 256, height: 1)
                        .foregroundColor(.white)
                    
                }
            }
            Spacer()
        }
        .navigationTitle("내 계정 설정")
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    verifyThenUploadNewUsername()
                    hideKeyboard()
                } label: {
                    Text("완료")
                        .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                }
            }
        }
    }
    
    private func verifyThenUploadNewUsername() {
        if username.count > 0, username.count < 11 {
            viewModel.changeUsername(username) {
                isUploadInProgress = false
                dismiss()
            }
        } else if username.count >= 11 {
            isAlert.toggle()
            username = ""
        } else {
            dismiss()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
