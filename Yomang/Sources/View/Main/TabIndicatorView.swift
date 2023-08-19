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
    var body: some View {
        GeometryReader {
            let size = $0.size
            let tabWidth = size.width / 3
            
            ZStack {
                Image("Yotto_Face")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .offset(x: -5, y: activeTab == .yours ? 100 : 170)
                    .opacity(activeTab == .yours ? 1 : 0)
                
                Image("Yotto_Face")
                    .resizable()
                    .scaleEffect(x: -1, y: 1)
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .offset(x: 5, y: activeTab == .yours ? 170 : 100)
                    .opacity(activeTab == .yours ? 0 : 1)
                
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
                    .offset(y: 150)
                    
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
                    .offset(y: 150)
                }
                .modifier(
                    AnimationEndCallback(endValue: tapState.progress, onEnd: {
                        tapState.reset()
                    })
                )
                .frame(width: CGFloat(Tab.allCases.count) * tabWidth)
                .padding(.leading, tabWidth)
            }
        }
    }
}
