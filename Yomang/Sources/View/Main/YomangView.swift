//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//
/*
 TODO: 뷰 넘김에 따른 이름 변화_ 애니메이션 버그 있음
 TODO: 이모지 반응칸 추가
 TODO: 아이콘 버튼 추가
 TODO: 현재사진으로 돌아가는 매커니즘 추가
 */

import SwiftUI

struct YomangView: View {
    @State private var activeTab: Tab = .yours
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
                        .tag(Tab.yours)
                        .offsetX(activeTab == Tab.yours) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(Tab.yours.index))
                            let pageProgress = pageOffset / size.width
                            scrollProgress = min(pageProgress, 0)
                        }
                    
                    MyYomangView()
                        .tag(Tab.mine)
                        .offsetX(activeTab == Tab.mine) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(Tab.mine.index))
                            let pageProgress = pageOffset / size.width
                            scrollProgress = min(pageProgress, 0)
                        }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                TabIndicatorView(activeTab: $activeTab, scrollProgress: $scrollProgress, tapState: $tapState)
            }
        }.ignoresSafeArea(.container, edges: .all)
    }
}

struct YomangView_Previews: PreviewProvider {
    static var previews: some View {
        YomangView()
    }
}
