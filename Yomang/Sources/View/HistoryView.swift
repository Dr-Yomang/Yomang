//
//  ImageHistoryView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
//

import SwiftUI

struct HistoryView: View {
    private let items = [GridItem(), GridItem()]
    private let width = CGFloat(170)
    @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: items, content: {
                    ForEach(0..<13) { _ in
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: .chevronBackward)
                            .foregroundColor(.white)
                    }
                }
            }
        }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
