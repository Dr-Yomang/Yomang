//
//  YomangDateTextView.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//

import SwiftUI

struct YomangDateTextView: View {
    let date: String
    @Binding var isDateActive: Bool
    var body: some View {
        Text(date)
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .offset(y: -150)
            .scaleEffect(isDateActive ? 1 : 0.95)
            .opacity(isDateActive ? 1 : 0)
    }
}
