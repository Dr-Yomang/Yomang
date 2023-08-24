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
    @State private var index = 0
    @State private var dragHeight = CGFloat.zero
    @State private var isSwipping = false
    @State private var isSwipeUp = false
    @State private var isSwipeDown = false
    @State private var isSwipeRight = false
    @State private var isSwipeLeft = false
    @State private var isDateActive = false
    @ObservedObject var viewModel = YourYomangViewModel()
    @Binding var matchingIdFromUrl: String?
    
    var body: some View {
        ZStack {
            YomangImageView(data: viewModel.data, index: $index)
            if viewModel.data.count == 0 {
                Text("상대방의 첫 요망을 기다리고 있어요")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            if viewModel.connectWithPartner {
                ReactionView(viewModel: viewModel, yomangIndex: $index)
                    .offset(y: CGFloat(Constants.yomangHeight + Constants.reactionBarHeight) / 2 + 20)
            } else {
                VStack {
                    Spacer()
                    ShareLink(item: URL(string: "YomanglabYomang://share?value=\(AuthViewModel.shared.user?.id)")
                              ?? URL(string: "itms-apps://itunes.apple.com/app/6461822956")!) {
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
                .onAppear {
                    if !viewModel.connectWithPartner {
                        if let pid = matchingIdFromUrl {
                            AuthViewModel.shared.matchTwoUser(partnerId: pid)
                        }
                    }
                }
            }
        }
    }
}
