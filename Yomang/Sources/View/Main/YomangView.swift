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
    @Binding var matchingIdFromUrl: String?
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .overlay(
                        Image("YomangMoon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1800, height: 1800)
                            .offset(x: activeTab == .yours ? UIScreen.width / 2 : -UIScreen.width / 2, y: 1050)
                            .ignoresSafeArea()
                    )
                
                TabView(selection: $activeTab) {
                    YourYomangView(matchingIdFromUrl: $matchingIdFromUrl)
                        .tag(Tab.yours)
                        .offsetX(activeTab == Tab.yours) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (UIScreen.width * CGFloat(Tab.yours.index))
                            let pageProgress = pageOffset / UIScreen.width
                            scrollProgress = min(pageProgress, 0)
                        }
                    
                    MyYomangView()
                        .tag(Tab.mine)
                        .offsetX(activeTab == Tab.mine) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (UIScreen.width * CGFloat(Tab.mine.index))
                            let pageProgress = pageOffset / UIScreen.width
                            scrollProgress = min(pageProgress, 0)
                        }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .navigationBarItems(trailing:
                                        HStack {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                    }
                    
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                    }
                })
                TabIndicatorView(activeTab: $activeTab, scrollProgress: $scrollProgress, tapState: $tapState)
            }
        }
    }
}
