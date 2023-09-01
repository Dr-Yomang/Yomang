//
//  MyAccountView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/09/01.
//

import SwiftUI

struct MyAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: SettingViewModel
    @State private var isSignOutInProgress = false
    @State private var isLengthZero = false
    @State private var isUploadInProgress = false
    @State private var showingAlert = false
    
    var body: some View {
//        List {
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
                        self.showingAlert = true
//                        isSignOutInProgress = true
//                        AuthViewModel.shared.signOut {
//                            isSignOutInProgress = false
//                        }
                    } label: {
                        HStack {
                            Text("로그아웃")
                                .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                        }
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("로그아웃"), message: Text("이 기기에서 로그아웃 하시겠습니까?"), primaryButton: .default(Text("로그아웃"), action: {
                            isSignOutInProgress = true
                            AuthViewModel.shared.signOut {
                                isSignOutInProgress = false
                            }
                        }), secondaryButton: .cancel(Text("취소")))
                    }
                }
                
                Section {
                    HStack {
                        Text("계정 탈퇴")
                            .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                        Spacer()
                        Button {
                            AuthViewModel.shared.deleteUser()
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.54, green: 0.26, blue: 1))
                                .opacity(0.5)
                        }
                        
                    }
                }
                //            }
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
    }
}
