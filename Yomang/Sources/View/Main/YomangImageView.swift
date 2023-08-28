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
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .foregroundColor(.white)
                    .opacity(0.2)
                    .frame(width: geo.size.width, height: geo.size.width)
                if data.count == 0 {
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundColor(.white)
                        .opacity(0.2)
                        .frame(height: geo.size.width)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(style: StrokeStyle(lineWidth: 3))
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .frame(height: geo.size.width)
                            )
                } else {
                    KFImage(URL(string: data[index].imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
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
        }//  GeometryReader
    }
}

struct YomangImageView_Previews: PreviewProvider {
    @State static var index: Int = 0
    static var previews: some View {
        YomangImageView(data: MyYomangViewModel().data, index: $index)
    }
}
