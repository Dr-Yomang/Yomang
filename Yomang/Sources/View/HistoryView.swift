//
//  ImageHistoryView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/12.
//

import SwiftUI
import Kingfisher

struct HistoryView: View {
    private let items = [GridItem(), GridItem()]
    private let width = UIScreen.width / 2 - 24
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = HistoryViewModel()
    @Binding var selectedTag: Int
    var body: some View {
        ScrollView {
            ZStack {
                if viewModel.data.count == 0 {
                    Text("아직 주고받은 요망이 하나도 없어요")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .offset(y: UIScreen.height / 3)
                }
                LazyVGrid(columns: items, content: {
                    ForEach(viewModel.data) { yomang in
                        NavigationLink(
                            // TODO: history grid 선택하면 어떻게 되는지: 큰 사진!
                            destination: EmptyView(),
                            label: {
                                KFImage(URL(string: yomang.imageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            })
                    }
                })
                .padding(.horizontal, 18)
                .padding(.top)
            }
        }
        .onAppear {
            viewModel.fetchAllYomang()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    if selectedTag != 0 {
                        Image(systemName: .chevronBackward)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    @State static var selectedTag = 1
    static var previews: some View {
        HistoryView(selectedTag: $selectedTag)
    }
}
