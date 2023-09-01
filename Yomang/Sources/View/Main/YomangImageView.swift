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
            if data.count == 0 {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.gray001)
                    .frame(width: UIScreen.width - (Constants.widgetPadding * 2),
                           height: (UIScreen.width - (Constants.widgetPadding * 2)) * 1.05)
                    .padding(.horizontal, 20)
            } else {
                KFImage(URL(string: data[index].imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.width - (Constants.widgetPadding * 2),
                           height: (UIScreen.width - (Constants.widgetPadding * 2)) * 1.05)
                    .mask {
                        RoundedRectangle(cornerRadius: 16)
                        
                    }
            }
        }
    }
}

struct YomangImageView_Previews: PreviewProvider {
    @State static var index: Int = 0
    static var previews: some View {
        YomangImageView(data: MyYomangViewModel().data, index: $index)
    }
}
