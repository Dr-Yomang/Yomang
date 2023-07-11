//
//  LoginView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/11.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack {
                Spacer().frame(height: 32)
                Image("Yotto")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 180)
                    .padding()
                Text("요망에 오신 걸 환영해요!")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .padding()
                Spacer().frame(height: 48)
                Button(action: {
                    
                }) {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .overlay(
                            Text("Apple로 시작하기")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                        )
                        .padding()
                }
                Spacer()
                Text("By signing up, you agree to our Terms of Service and\nacknowledge that our Privacy Policy applies to you.")
                    .foregroundColor(.white)
                    .font(.caption)
                
            }//VStack
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
