//
//  YomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI

struct YomangView: View {
    
    @Binding var matchingIdFromUrl: String?
    @ObservedObject var yourYomangViewModel = YourYomangViewModel()
    @ObservedObject var myYomangViewModel = MyYomangViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                TabView {
                    YourYomangView(viewModel: yourYomangViewModel, matchingIdFromUrl: $matchingIdFromUrl)
                        .tag(0)
                    
                    MyYomangView(viewModel: myYomangViewModel)
                        .tag(1)
                    
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
            }
        }
    }
}

struct YomangView_Previews: PreviewProvider {
    @State static var matchingId: String? = "itms-apps://itunes.apple.com/app/6461822956"
    
    static var previews: some View {
        YomangView(matchingIdFromUrl: $matchingId)
    }
}
