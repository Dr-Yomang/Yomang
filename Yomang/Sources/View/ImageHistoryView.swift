//
//  ImageHistoryView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
//

import SwiftUI

struct ImageHistoryView: View {
    private let items = [GridItem(), GridItem()]
        private let width = CGFloat(170)
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: items, content: {
                    ForEach (0..<13) { post in
                       NavigationLink(
                        destination: EmptyView(),
                        label: {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: width, height: width)
                                .foregroundColor(.neu400)
                        })
                    }
                })
                .padding(.horizontal, 18)
                .padding(.top)
            }
            .navigationTitle(Text("히스토리"))
            .navigationBarTitleDisplayMode(.large)
        }
}

struct ImageHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ImageHistoryView()
    }
}
