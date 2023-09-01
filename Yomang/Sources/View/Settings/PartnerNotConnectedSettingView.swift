//
//  PartnerNotConnectedSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI
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
