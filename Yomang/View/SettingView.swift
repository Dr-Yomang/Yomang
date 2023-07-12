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
        NavigationView {
            List {
                Section {
                    HStack {
//                        Image(systemName: "person.fill.xmark")
                        Text("\(username)")
                    }
                }
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "person.text.rectangle.fill")
                            Text("닉네임 변경")
                        }
                    }

                }
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "person.fill.xmark")
                            Text("연결 해제")
                        }
                    }
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "person.line.dotted.person.fill")
                            Text("연결 해제 복구")
                        }
                    }
                    NavigationLink {
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: "person.2.wave.2.fill")
                            Text("새로 연결하기")
                        }
                    }
                }
                    
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("로그아웃")
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("탈퇴")
                    }

                }
            }
        }
        .navigationTitle("설정 및 개인정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
