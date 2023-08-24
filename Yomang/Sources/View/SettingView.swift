//
//  SettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
// ..

import SwiftUI

struct SettingView: View {
    private var username = "ZENA"
    @Environment(\.dismiss) private var dismiss
    @State private var isSignOutInProgress = false
    var body: some View {
        ZStack {
            List {
                Section {
                    HStack {
                        Circle()
                            .foregroundColor(Color.neu500)
                            .overlay {
                                Image(String.yottoWithUpperBody)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                            }
                            .frame(width: 112, height: 112)
                            .padding(.vertical, 10)
                        Spacer()
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
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: .bellFill)
                            Text(String.buttonSettingNotification)
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
            if isSignOutInProgress {
                Color.black
                    .opacity(0.8)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
