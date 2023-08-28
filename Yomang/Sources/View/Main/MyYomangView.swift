//
//  MyYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI
import Kingfisher

struct MyYomangView: View {
    
    @State private var index = 0
    @State private var isUploadInProgress = false
    @State private var isFetchingInProgress = false
    @State private var isScaleEffect = false
    @ObservedObject var viewModel: MyYomangViewModel
    
    var body: some View {
        ZStack {
            Image("YomangMoon")
                .resizable()
                .scaledToFit()
                .frame(width: 1800, height: 1800)
                .offset(x: -UIScreen.width / 2, y: 1100)
                .ignoresSafeArea()
            
            YomangImageView(data: viewModel.data, index: $index)
                .frame(width: UIScreen.width - Constants.yomangPadding, height: UIScreen.width - Constants.yomangPadding)
                .overlay {
                    ZStack {
                        if viewModel.data.count == 0 {
                            Text("이곳을 눌러 마음을 담아 요망을 보내보세요")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        if isUploadInProgress {
                            Color
                                .black
                                .opacity(0.5)
                                .ignoresSafeArea()
                            ProgressView()
                        }
                    }
                }
                .onTapGesture {
                    DispatchQueue.main.async {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        withAnimation(.easeIn(duration: 0.3)) {
                            isScaleEffect = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        withAnimation(.easeOut(duration: 0.5)) {
                            isScaleEffect = false
                        }
                        isUploadInProgress = true
                        viewModel.uploadMyYomang(image: UIImage(named: "image\(Int.random(in: 0..<7))")!) { _ in
                            viewModel.fetchMyYomang()
                            index = 0
                            isUploadInProgress = false
                        }
                    }
                }
                .scaleEffect(isScaleEffect ? 1.05 : 1)
                .offset(y: -56)
            
            VStack {
                Text("나의 닉네임")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 48)
                    )
                
            }
            .offset(y: -UIScreen.width / 1.45)
        }
    }
}

struct MyYomangView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyYomangView(viewModel: MyYomangViewModel())
    }
}
