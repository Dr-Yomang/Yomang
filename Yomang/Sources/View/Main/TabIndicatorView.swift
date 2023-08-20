//
//  TabIndicatorView.swift
//  Yomang
//
//  Created by 제나 on 2023/08/19.
//

import SwiftUI

struct TabIndicatorView: View {
    @Binding var activeTab: Tab
    @Binding var scrollProgress: CGFloat
    @Binding var tapState: AnimationState
    private let tabWidth = UIScreen.width / 3
    private var isYours: Bool {
        return activeTab == .yours
    }
    var body: some View {
        VStack {
            ZStack {
                Image("Yotto_Face")
                    .resizable()
                    .scaledToFit()
                    .rotation3DEffect(Angle(degrees: isYours ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                    .frame(width: 70, height: 70)
                    
                HStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(activeTab == .yours ? .white : .gray)
                            .offset(x: activeTab == .yours ? 0 : 50)
                            .frame(width: activeTab == .yours ? tabWidth-16 : 16, height: activeTab == .yours ? 50 : 16)
                        Text(Tab.yours.rawValue)
                            .font(.title3.bold())
                            .foregroundColor(activeTab == .yours ? .black : .clear)
                            .frame(width: tabWidth, height: 50)
                            .contentShape(Rectangle())
                    }
                    .offset(x: scrollProgress * tabWidth)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeTab = .yours
                            scrollProgress = -CGFloat(Tab.yours.index)
                            tapState.startAnimation()
                        }
                    }
                    .offset(y: 50)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(activeTab == .mine ? .white : .gray, lineWidth: 2)
                            .background(Color.black)
                            .offset(x: activeTab == .mine ? 0 : -50)
                            .frame(width: activeTab == .mine ? tabWidth-16 : 16, height: activeTab == .mine ? 50 : 16)
                        
                        Text(Tab.mine.rawValue)
                            .font(.title3.bold())
                            .foregroundColor(activeTab == .mine ? .white : .clear)
                            .frame(width: tabWidth, height: 50)
                            .contentShape(Rectangle())
                    }
                    .offset(x: scrollProgress * tabWidth)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeTab = .mine
                            scrollProgress = -CGFloat(Tab.mine.index)
                            tapState.startAnimation()
                        }
                    }
                    .offset(y: 50)
                }
                .modifier(
                    AnimationEndCallback(endValue: tapState.progress, onEnd: {
                        tapState.reset()
                    })
                )
                .frame(width: CGFloat(Tab.allCases.count) * tabWidth)
                .padding(.leading, tabWidth)
            }
            .offset(y: 50)
            Spacer()
        }
    }
}
