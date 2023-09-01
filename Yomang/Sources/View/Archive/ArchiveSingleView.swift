//
//  ArchiveSingleView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI
import Kingfisher

struct ArchiveSingleView: View {
    let data: YomangData
    @Environment(\.dismiss) private var dismiss
    private let width = UIScreen.width - 40
    private var height: CGFloat {
        return Constants.widgetSize.height / Constants.widgetSize.width * width
    }
    var body: some View {
        ZStack {
            KFImage(URL(string: data.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: width,
                       height: height)
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: width,
                               height: height)
                }
                .padding(.horizontal, 20)
                .overlay {
                    if let emoji = data.emoji {
                        Image(emoji[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.width / 3)
                            .padding(.top, height / 2)
                            .padding(.leading, width / 2)
                    }
                }
            VStack {
                Spacer()
                ZStack {
                    Button {
                        // TODO: - 사진 저장 기능
                    } label: {
                        Image(systemName: "arrow.down.to.line.compact")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.width / 2, height: 50)
                            .padding(.bottom, 20)
                    }
                }
                .frame(width: UIScreen.width, height: 84)
                .background(Color(hex: 0x3D3D3D))
            }
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.bottom)
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
