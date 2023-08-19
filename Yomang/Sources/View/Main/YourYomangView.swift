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
    @EnvironmentObject var viewModel: AuthViewModel
    
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
            Rectangle()
                .fill(yourYomangImages[index])
                .frame(width: 330, height: 330)
                .overlay(
                    ZStack {
                        Text(yourYomangImagesDate[index])
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .offset(y: -120)
                            .scaleEffect(isDateActive ? 1 : 0.95)
                            .opacity(isDateActive ? 1 : 0)
                        if viewModel.user?.partnerId == nil {
                            Text("아직 파트너와\n연결되지 않았어요")
                                .multilineTextAlignment(.center)
                                .font(.headline)
                        }
                    }
                )
                .overlay(
                    ZStack {
                        Color.white
                            .opacity(isSwipping ? 0.5 : 0)
                        Image("Yotto")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 230, height: 230)
                            .offset(x: 10, y: 60)
                    }.opacity(isSwipping ? 1 : 0)
                )
                .overlay(
                    Color.white
                        .opacity(0.5)
                )
                .cornerRadius(30)
                .rotation3DEffect(
                    Angle(degrees: isSwipeUp ? -10 : isSwipeDown ? 10 : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .center,
                    perspective: 0.3
                )
                .rotation3DEffect(
                    Angle(degrees: -CGFloat(motionData.movingOffset.width * 2)),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center,
                    perspective: 0.1
                )
                .offset(y: -40)
                .offset(y: isSwipeUp ? -20 : isSwipeDown ? 20 : 0)
                .onAppear {
                    motionData.fetchMotionData(duration: 16)
                }
                .gesture(DragGesture()
                    .onChanged { gesture in
                        self.dragHeight = gesture.translation.height
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isSwipping = true
                            if dragHeight > 0 {
                                isSwipeDown = true
                            } else {
                                isSwipeUp = true
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            isSwipping = false
                            isSwipeUp = false
                            isSwipeDown = false
                            isDateActive = true
                            if dragHeight > 0 {
                                index = (index - 1 + yourYomangImages.count) % yourYomangImages.count
                            } else {
                                index = (index + 1) % yourYomangImages.count
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                withAnimation(.easeInOut(duration: 1)) {
                                    isDateActive = false
                                }
                            })
                        }
                    }
                )
            if viewModel.user?.partnerId != nil {
                ReactionView()
            } else {
                VStack {
                    Spacer()
                    ShareLink(item: URL(string: "YomanglabYomang://share?value=\(viewModel.user?.id)") ?? URL(string: "https://opentutorials.org/module/6260/32205")!) {
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
