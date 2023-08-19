//
//  LinkView.swift
//  Yomang
//
//  Created by NemoSquare on 7/10/23.
//

import SwiftUI

// TextField의 Underline 기능이 iOS 15에서 사용불가!
// 다른 방식으로 밑줄을 만들어야 합니다.
// 어떡하지...

struct LinkView: View {
    @State private var underLineString: String = ""
    @State private var textStr: String = ""
        
    var body: some View {
        VStack {
            ZStack {
                Text(textStr)
                    .underline()
                    .multilineTextAlignment(.center)
                Text("_____")
                    .underline()
                TextField("이름", text: $textStr)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        LinkView()
    }
}
