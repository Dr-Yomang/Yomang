//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//
/*
 TODO: 뷰 넘김에 따른 이름 변화
 TODO: 이모지 반응칸 추가
 TODO: 아이콘 버튼 추가
 TODO: 현재사진으로 돌아가는 매커니즘 추가
 */

import SwiftUI

struct YomangView: View {
    @State private var activeTab: Tab = .your
    @State private var scrollProgress: CGFloat = .zero
    @State private var tapState: AnimationState = .init()
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                    Color.black
                        .ignoresSafeArea()
                
                TabView(selection: $activeTab) {
                    YourYomangView()
                        .tag(Tab.your)
                        .offsetX(activeTab == Tab.your) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(Tab.your.index))
                            let pageProgress = pageOffset / size.width
                            scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
                        }
                    
                    MyYomangView()
                        .tag(Tab.my)
                        .offsetX(activeTab == Tab.my) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(Tab.my.index))
                            let pageProgress = pageOffset / size.width
                            scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
                        }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                TabIndicatorView()
            }
        }.ignoresSafeArea(.container, edges: .all)
    }
    
    @ViewBuilder
    func TabIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            let tabWidth = size.width / 3
            
            ZStack {
                Image("Yotto_Face")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .offset(x: -5, y: activeTab == .your ? 100 : 300)
                    .opacity(activeTab == .your ? 1 : 0)
                    .scaleEffect(activeTab == .your ? 1 : 0)
                
                Image("Yotto_Face")
                    .resizable()
                    .scaleEffect(x: -1, y: 1)
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .offset(x: 5, y: activeTab == .your ? 300 : 100)
                    .opacity(activeTab == .your ? 0 : 1)
                    .scaleEffect(activeTab == .your ? 0 : 1)
                
                
                HStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(activeTab == .your ? .white : .gray)
                            .frame(width: activeTab == .your ? tabWidth-16 : 16, height: activeTab == .your ? 50 : 16)
                            .offset(x: activeTab == .your ? 0 : 50)
                        Text(Tab.your.rawValue)
                            .font(.title3.bold())
                            .foregroundColor(activeTab == .your ? .black : .clear)
                            .frame(width: tabWidth, height: 50)
                            .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeTab = .your
                            scrollProgress = -CGFloat(Tab.your.index)
                            tapState.startAnimation()
                        }
                    }
                    .offset(y: 150)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(activeTab == .my ? .white : .gray, lineWidth: 2)
                            .frame(width: activeTab == .my ? tabWidth-16 : 16, height: activeTab == .my ? 50 : 16)
                            .background(Color.black)
                            .offset(x: activeTab == .my ? 0 : -50)
                        
                        Text(Tab.my.rawValue)
                            .font(.title3.bold())
                            .foregroundColor(activeTab == .my ? .white : .clear)
                            .frame(width: tabWidth, height: 50)
                            .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            activeTab = .my
                            scrollProgress = -CGFloat(Tab.my.index)
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
                .offset(x: scrollProgress * tabWidth)
            }
        }
    }
}

struct YomangView_Previews: PreviewProvider {
    static var previews: some View {
        YomangView()
    }
}
