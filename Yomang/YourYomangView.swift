//
//  YourYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI

struct YourYomangView: View {
    
    @StateObject var motionData = MotionObserver()
    let yourYomangImages: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    let yourYomangImagesDate: [String] = ["2023-07-13", "2023-07-12", "2023-07-11", "2023-07-10", "2023-07-09", "2023-07-08"]
    @State private var index: Int = 0
    @State private var dragHeight : CGFloat = .zero
    @State private var isSwipping: Bool = false
    @State private var isSwipeUp: Bool = false
    @State private var isSwipeDown: Bool = false
    @State private var isSwipeRight: Bool = false
    @State private var isSwipeLeft: Bool = false
    @State private var isDateActive: Bool = false
    
    var body: some View {
        ZStack {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        Image("YomangMoon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1800, height: 1800)
                            .offset(x: proxy.size.width / 2, y: 1050)
                            .opacity(1)
                            .ignoresSafeArea()
                    )
                }
            }
            Rectangle()
                .fill(yourYomangImages[index])
                .frame(width: 330, height: 330)
                .overlay(
                    Text(yourYomangImagesDate[index])
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .offset(y: -120)
                        .scaleEffect(isDateActive ? 1 : 0.95)
                        .opacity(isDateActive ? 1 : 0)
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
                                print("Down")
                            } else {
                                isSwipeUp = true
                                print("Up")
                            }
                        }
                        print(dragHeight)
                    }
                    .onEnded { gesture in
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
            
            Rectangle()
                .fill(.white)
                .frame(width: 330, height: 100)
                .cornerRadius(20)
                .opacity(0.7)
                .offset(y: 175+24)
            
        }
    }
}

struct YourYomangView_Previews: PreviewProvider {
    static var previews: some View {
        YourYomangView()
    }
}
