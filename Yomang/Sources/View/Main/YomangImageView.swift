//
//  YomangImageView.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//

import SwiftUI
import Kingfisher

struct YomangImageView: View {
    
    let data: [YomangData]
    @Binding var index: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .opacity(0.2)
                .frame(width: UIScreen.width - 40,
                       height: Constants.widgetSize.height / Constants.widgetSize.width * (UIScreen.width - 40))
                .padding(.horizontal, 20)
            if data.count == 0 {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                    .opacity(0.2)
                    .frame(width: UIScreen.width - 40,
                           height: Constants.widgetSize.height / Constants.widgetSize.width * (UIScreen.width - 40))
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(style: StrokeStyle(lineWidth: 3))
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .frame(width: UIScreen.width - 40,
                                   height: Constants.widgetSize.height / Constants.widgetSize.width * (UIScreen.width - 40))
                            .padding(.horizontal, 20)
                    )
            } else {
                KFImage(URL(string: data[index].imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.width - 40,
                           height: Constants.widgetSize.height / Constants.widgetSize.width * (UIScreen.width - 40))
                    .mask {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: UIScreen.width - 40,
                                   height: Constants.widgetSize.height / Constants.widgetSize.width * (UIScreen.width - 40))
                    }
                    .padding(.horizontal, 20)
                    .overlay(
                        ZStack {
                            if AuthViewModel.shared.user?.partnerId == nil {
                                Text("아직 파트너와\n연결되지 않았어요")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                            }
                        }
                    )
            }
        }//  ZStack
    }
}

struct YomangImageView_Previews: PreviewProvider {
    @State static var index: Int = 0
    static var previews: some View {
        YomangImageView(data: MyYomangViewModel().data, index: $index)
    }
}
