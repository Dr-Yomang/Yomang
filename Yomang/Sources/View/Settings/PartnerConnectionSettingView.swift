//
//  PartnerConnectionSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

struct PartnerConnectionSettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack {
            if viewModel.partnerID == nil {
                HStack {
                    Text("연결된 파트너가 없어요.")
                        .padding(.leading, 20)
                        .padding(.top, 42)
                        .foregroundStyle(Color(hex: 0xC7C7CC))
                    Spacer()
                }
                Section() {
                    NavigationLink() {
                        EmptyView()
                    } label: {
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
                    }
                    .padding(.top, 42)
                    .padding(.bottom, 10)
                }
                
                Section() {
                    NavigationLink() {
                        EmptyView()
                    } label: {
                        ZStack {
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
                            }
                        }
                    }
                }
                Spacer()
            } else {
                HStack {
                    Text("연결된 파트너")
                        .padding(.leading, 20)
                        .foregroundStyle(Color(hex: 0xC7C7CC))
                    Text("까망토끼")
                        .bold()
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 12)
                            .frame(width: 82, height: 28))
                        .padding(.leading, 14)
                    Spacer()
                }
                .padding(.top, 35)
                .padding(.bottom, 44)
                Section() {
                    NavigationLink() {
                        DisconnectSettingView(viewModel: viewModel)
                    } label: {
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
                            }
                        }
                    }
                }
                Spacer()
            }
        }//VStack
        .navigationTitle("파트너 연결")
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
