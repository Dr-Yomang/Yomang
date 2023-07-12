//
//  YomangAnimation.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI

struct YomangAnimation: View {
    @State var selectedTabTag = 0
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            TabView(selection: $selectedTabTag) {
                YourYomangAnmiation()
                    .tag(0)
                MyYomangAnimation()
                    .tag(1)
            }.ignoresSafeArea()
            .accentColor(Color.white)
            .navigationTitle(selectedTabTag == 0 ? "너의 요망" : "나의 요망")
            .tabViewStyle(.page(indexDisplayMode: .always))
            .navigationBarTitleDisplayMode(.large)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationViewStyle(.stack)
        }
    }
}

struct YomangAnimation_Previews: PreviewProvider {
    static var previews: some View {
        YomangAnimation()
    }
}
