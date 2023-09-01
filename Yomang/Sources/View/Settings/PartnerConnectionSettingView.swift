//
//  PartnerConnectionSettingView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI

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
