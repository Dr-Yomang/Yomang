//
//  TabViewStyle.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI

struct TabViewStyle: View {
    @State private var activeTab: Tab = .your
    @State private var scrollProgress: CGFloat = .zero
    @State private var tapState: AnimationState = .init()
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                
                TabView(selection: $activeTab) {                    
                    
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        TabImageView(tab)
                            .tag(tab)
                            .offsetX(activeTab == tab) { rect in
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(tab.index))
                                let pageProgress = pageOffset / size.width
                                    scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
                            }
                    }
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                TabIndicatorView()
            }
        }.ignoresSafeArea(.container, edges: .bottom)
    }
    
    @ViewBuilder
    func TabIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            let tabWidth = size.width / 3
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Text(tab.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(activeTab == tab ? .white : .gray)
                        .frame(width: tabWidth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeTab = tab
                                scrollProgress = -CGFloat(tab.index)
                                tapState.startAnimation()
                            }
                        }
                        
                }
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
    
    @ViewBuilder
    func TabImageView(_ tab: Tab) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(tab.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct TabViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        TabViewStyle()
    }
}
