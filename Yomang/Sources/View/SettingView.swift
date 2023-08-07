//
//  SettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
//

import SwiftUI

struct SettingView: View {
    private var username = "ZENA"
    var body: some View {
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
        }
        .navigationTitle(String.navigationTitleSetting)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: .chevronBackward)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
