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
//    @Binding var selectedTag: Int
    @Binding var isHistoryButtonClicked: Bool
    
    var body: some View {
        ScrollView {
            ZStack {
                if viewModel.data.count == 0 {
                    Text("아직 주고받은 요망이 하나도 없어요")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .offset(y: UIScreen.height / 3)
                } else {
                    LazyVGrid(columns: items) {
                        ForEach(viewModel.data, id: \.self) { yomang in
                            NavigationLink(
                                destination: ArchiveSingleView(data: yomang),
                                label: {
                                    ZStack {
                                        KFImage(URL(string: yomang.imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: width, height: width)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        if let emoji = yomang.emoji,
                                           emoji.count > 0 {
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Spacer()
                                                    ReactionButtonView(imageName: emoji[emoji.count - 1])
                                                        .padding(5)
                                                        .padding(.trailing, 2)
                                                }
                                            }
                                        }
                                    }
                                }) 
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.top)
                }
            }
        }
        .onAppear {
            viewModel.fetchAllYomang()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    isHistoryButtonClicked = false
                    dismiss()
                } label: {
                    if isHistoryButtonClicked {
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
    @State static var isHistoryButtonClicked = false
    static var previews: some View {
        HistoryView(isHistoryButtonClicked: $isHistoryButtonClicked)
    }
}
