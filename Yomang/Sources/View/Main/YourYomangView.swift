//
//  YourYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import Foundation
import SwiftUI

struct YourYomangView: View {
    
    @StateObject var motionData = MotionObserver()
    let yourYomangImages: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    let yourYomangImagesDate: [String] = ["2023-07-13", "2023-07-12", "2023-07-11", "2023-07-10", "2023-07-09", "2023-07-08"]
    @State private var index: Int = 0
    @State private var dragHeight: CGFloat = .zero
    @State private var isSwipping: Bool = false
    @State private var isSwipeUp: Bool = false
    @State private var isSwipeDown: Bool = false
    @State private var isSwipeRight: Bool = false
    @State private var isSwipeLeft: Bool = false
    @State private var isDateActive: Bool = false
    @ObservedObject var viewModel = YourYomangViewModel()
    
    var body: some View {
        ZStack {
            YomangImageView(data: viewModel.data)
            Text("상대방의 첫 요망을 기다리고 있어요")
                .font(.headline)
                .foregroundColor(.white)
            
            if viewModel.connectWithPartner {
                ReactionView(viewModel: viewModel, yomangIndex: $index)
//                    .offset(y: CGFloat(Constants.yomangHeight + Constants.reactionBarHeight) / 2 + 20)
//                    .offsetY(true) { rect in
////                        let yOffset = CGFloat(Constants.yomangHeight + Constants.reactionBarHeight) / 2 + 20
////                        return CGPoint(x: rect.origin.x, y: yOffset)
//                        let minY = rect.minY
//                        let pageOffset = minY - (UIScreen.height * CGFloat(Tab.yours.index))
//                        let pageProgress = pageOffset / UIScreen.height
//                        
//                    }
                
            } else {
                VStack {
                    Spacer()
                    ShareLink(item: URL(string: "YomanglabYomang://share?value=\(String(describing: AuthViewModel.shared.user?.id))") ?? URL(string: "https://opentutorials.org/module/6260/32205")!) {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .overlay(
                                Text("파트너 연결 링크 다시 보내기")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
                            )
                            .padding(.bottom, 52)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
