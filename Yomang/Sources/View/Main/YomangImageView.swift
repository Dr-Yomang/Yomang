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
    @StateObject var motionData = MotionObserver()
    @State private var index: Int = 0
    @State private var dragHeight: CGFloat = .zero
    @State private var isSwipping: Bool = false
    @State private var isSwipeUp: Bool = false
    @State private var isSwipeDown: Bool = false
    @State private var isSwipeRight: Bool = false
    @State private var isSwipeLeft: Bool = false
    @State private var isDateActive: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: 0x3D3D3D).opacity(0.4))
                .frame(height: CGFloat(Constants.yomangHeight))
                .padding(.horizontal, 20)
            if data.count == 0 {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: 0x3D3D3D))
                    .frame(height: CGFloat(Constants.yomangHeight))
                    .padding(.horizontal, 20)
            } else {
                KFImage(URL(string: data[index].imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(UIScreen.width - 40), height: CGFloat(Constants.yomangHeight))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 20)
                    .overlay(
                        ZStack {
                            YomangDateTextView(date: data[index].uploadedDate.description, isDateActive: $isDateActive)
                            if AuthViewModel.shared.user?.partnerId == nil {
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
                                .cornerRadius(16)
                            VStack {
                                Spacer()
                                Image("Yotto")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 230, height: 230)
                            }
                        }
                            .opacity(isSwipping ? 1 : 0)
                            .padding(.horizontal, 20)
                        
                    )
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
                    .offset(y: isSwipeUp ? -20: isSwipeDown ? 20: 0)
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
                                    index = (index - 1 + data.count) % data.count
                                } else {
                                    index = (index + 1) % data.count
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        isDateActive = false
                                    }
                                })
                            }
                        }
                    )
            }
        }
    }
}
