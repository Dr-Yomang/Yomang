//
//  MyAccountView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/09/01.
//

import SwiftUI

struct MyAccountView: View {
    enum AlertType {
        case signOut
        case deleteUser
    }
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingViewModel
    @State private var isUploadInProgress = false
    @State private var isLengthZero = false
    
    @State private var showInstantAlert = false
    @State private var instantAlertTitle = ""
    @State private var instantAlertMessage = ""
    @State private var alertType = AlertType.signOut
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("내 계정")
                        .foregroundColor(Color(red: 0.78, green: 0.78, blue: 0.8))
                        .frame(width: 52, height: 14, alignment: .topLeading)
                        .font(.system(size: 16))
                    
                    VStack(alignment: .leading) {
                        ZStack {
                            Rectangle()
                                .frame(width: 256, height: 28)
                                .cornerRadius(12)
                            
                            HStack {
                                Image(systemName: "apple.logo")
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.black)
                                
                                Text(AuthViewModel.shared.user!.email)
                                    .foregroundColor(.black)
                                    .font(.system(size: 10))
                            }
                        }
                        
                        Text("애플 계정 로그인을 사용하고 있습니다.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                    }
                    
                }
                .padding(.vertical, 15)
                
                List {
                    Section {
                        Button {
                            setInstantAlert(title: "로그아웃", message: "이 기기에서 로그아웃 하시겠습니까?", type: .signOut)
                        } label: {
                            HStack {
                                Text("로그아웃")
                                    .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("계정 탈퇴")
                                .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                            Spacer()
                            Button {
                                setInstantAlert(title: "계정을 탈퇴하시겠습니까?", message: "즉시 파트너와 연결이 끊어지며 모든 데이터가 삭제됩니다.", type: .deleteUser)
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                                    .opacity(0.5)
                            }
                        }
                    }
                }
            }
            if isUploadInProgress {
                Color.black.opacity(0.7).ignoresSafeArea()
                ProgressView()
            }
        }
        .alert(instantAlertTitle, isPresented: $showInstantAlert) {
            if alertType == .signOut {
                Button("로그아웃", role: .destructive, action: signOutAction)
            } else {
                Button("계정 탈퇴", role: .destructive, action: deleteUserAction)
            }
             Button("취소", role: .cancel) {
                 showInstantAlert = false
             }
         } message: {
             Text(instantAlertMessage)
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
        }
    }
    
    private func signOutAction() {
        isUploadInProgress = true
        AuthViewModel.shared.signOut {
            isUploadInProgress = false
        }
    }
    
    private func deleteUserAction() {
        isUploadInProgress = true
        AuthViewModel.shared.deleteUser {
            isUploadInProgress = false
        }
    }
    
    private func setInstantAlert(title: String, message: String, type: AlertType) {
        self.instantAlertTitle = title
        self.instantAlertMessage = message
        self.showInstantAlert = true
        self.alertType = type
    }
}
