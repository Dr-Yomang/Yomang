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
            Color.black
                .ignoresSafeArea()
                .overlay(
                    Image("YomangMoon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1800, height: 1800)
                        .offset(x: UIScreen.main.bounds.width / 2, y: 1050)
                        .opacity(1)
                        .ignoresSafeArea()
                )
            YomangImageView(data: viewModel.data)
            Text("상대방의 첫 요망을 기다리고 있어요")
                .font(.headline)
                .foregroundColor(.white)
            
            if viewModel.connectWithPartner {
                ReactionView()
                    .offset(y: CGFloat(Constants.yomangHeight + Constants.reactionBarHeight) / 2 + 20)
            } else {
                VStack {
                    Spacer()
                    ShareLink(item: URL(string: "YomanglabYomang://share?value=\(AuthViewModel.shared.user?.id)") ?? URL(string: "https://opentutorials.org/module/6260/32205")!) {
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
