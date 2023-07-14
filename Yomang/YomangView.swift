//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//
/*
 TODO: 뷰 넘김에 따른 이름 변화
 TODO: 이모지 반응칸 추가
 TODO: 아이콘 버튼 추가
 TODO: 현재사진으로 돌아가는 매커니즘 추가
 */

import SwiftUI

struct YomangView: View {
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            TabView {
                YourYomangView()
                    .tag(0)
                
                MyYomangView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
    }
}

struct YomangView_Previews: PreviewProvider {
    static var previews: some View {
        YomangView()
    }
}
