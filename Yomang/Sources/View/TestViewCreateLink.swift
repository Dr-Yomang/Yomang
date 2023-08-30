//
//  TestViewCreateLink.swift
//  Yomang
//
//  Created by NemoSquare on 8/29/23.
//

import SwiftUI

struct TestViewCreateLink: View {
    var body: some View {
        Button(action: {AuthViewModel().createInviteLink()}, label: {Text("Share Link")})
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestViewCreateLink()
    }
}
