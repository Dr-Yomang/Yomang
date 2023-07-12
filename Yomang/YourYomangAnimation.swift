//
//  AnimationView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI

struct YourYomangAnmiation: View {
    
    let yomangImages: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    @State private var index: Int = 0
    @State private var dragHeight : CGFloat = .zero
    @State private var isSwipping: Bool = false
    @State private var isSwipeUp: Bool = false
    @State private var isSwipeDown: Bool = false
    @State private var isSwipeRight: Bool = false
    @State private var isSwipeLeft: Bool = false
    
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
                .fill(yomangImages[index])
                .frame(width: 330, height: 330)
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
                .cornerRadius(30)
                .rotation3DEffect(
                    Angle(degrees: isSwipeUp ? -10 : isSwipeDown ? 10 : 0),
                    axis: (x: 1.0, y: 0.0, z: 0.0),
                    anchor: .center,
                    perspective: 0.3
                )
                .offset(y: -40)
                .offset(y: isSwipeUp ? -20 : isSwipeDown ? 20 : 0)
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
                            if dragHeight > 0 {
                                index = (index - 1 + yomangImages.count) % yomangImages.count
                            } else {
                                index = (index + 1) % yomangImages.count
                            }
                        }
                    }
                )
            
        }
    }
}

struct YourYomangAnimation_Previews: PreviewProvider {
    static var previews: some View {
        YourYomangAnmiation()
    }
}
