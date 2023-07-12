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
        if !navigate {
            LinkView(navigate: $navigate)
        } else {
            YomangAnimation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
