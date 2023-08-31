//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI

struct YomangView: View {
    @Binding var matchingIdFromUrl: String?
    @State private var selectedTag = 1
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                TabView(selection: $selectedTag) {
                    HistoryView(selectedTag: $selectedTag)
                        .tag(0)
                    YourYomangView(matchingIdFromUrl: $matchingIdFromUrl)
                        .tag(1)
                    MyYomangView()
                        .tag(2)
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .navigationBarItems(trailing:
                                        HStack {
                    NavigationLink {
                        HistoryView(selectedTag: $selectedTag)
                            .navigationTitle(Text("히스토리"))
                            .navigationBarTitleDisplayMode(.inline)

                    } label: {
                        if selectedTag != 0 {
                            Image(systemName: "heart")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }

                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                })
            }
        }
    }
}
