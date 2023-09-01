//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI
import Kingfisher

struct YomangView: View {
    @Binding var matchingIdFromUrl: String?
    @State private var isHistoryButtonClicked: Bool = false
    @State private var selectedTag = 0
    @ObservedObject var viewModel = SettingViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                TabView(selection: $selectedTag) {
                    HistoryView(isHistoryButtonClicked: $isHistoryButtonClicked)
                        .tag(0)
                    YourYomangView(matchingIdFromUrl: $matchingIdFromUrl)
                        .tag(1)
                    MyYomangView()
                        .tag(2)
                }
                .onAppear {
                    selectedTag = 1
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            
                .navigationBarItems(leading:
                    Button(action: { withAnimation { selectedTag = 0 }}) {
                        Image(systemName: "square.grid.2x2").bold().font(.system(size: 19.0))
                            .foregroundColor(.white)
                })
                .navigationBarItems(trailing:
//                                        HStack {
//                    NavigationLink {
//                        HistoryView(selectedTag: $selectedTag, isHistoryButtonClicked: $isHistoryButtonClicked)
//                            .navigationTitle(Text("히스토리"))
//                            .navigationBarTitleDisplayMode(.inline)
//                    } label: {
//                        if selectedTag != 0 {
//                            Image(systemName: "heart")
//                                .foregroundColor(.white)
//                                .font(.system(size: 20))
//                        }
//                    }
//                    .simultaneousGesture(TapGesture().onEnded {
//                        isHistoryButtonClicked = true
//                    })
                    
                    NavigationLink {
                        SettingView(viewModel: viewModel)
                    } label: {
                        if let imageUrl = viewModel.profileImageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28)
                                .clipShape(Circle())
                        } else {
                            Image("yt_surprise")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 28)
                                .clipShape(Circle())
                        }
                    }
//                }
                )
            }
        }
    }
}
