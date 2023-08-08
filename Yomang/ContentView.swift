//
//  ContentView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                SettingView()
            } label: {
                Text("설정 및 개인정보")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
