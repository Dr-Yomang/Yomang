//
//  ContentView.swift
//  Yomang
//
//  Created by 제나 on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    @State var navigate: Bool = false

    var body: some View {
<<<<<<< HEAD
        NavigationView {
            NavigationLink("Go to ImageHistoryView", destination: ImageHistoryView())
=======
<<<<<<< HEAD
        if !navigate {
            LinkView(navigate: $navigate)
        } else {
            YomangView()
=======
        NavigationView {
            NavigationLink {
                SettingView()
            } label: {
                Text("설정 및 개인정보")
            }

>>>>>>> cec5ecff2d8c9becd9b40479a5b156b53f819f3f
>>>>>>> 149c67595907e8bfa90325b42109a0bde13e6e3b
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
