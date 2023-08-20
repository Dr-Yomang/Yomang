//
//  MyYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI
import Kingfisher

struct MyYomangView: View {
    
    @StateObject var motionData = MotionObserver()
    @State private var index: Int = 0
    @State private var dragHeight: CGFloat = .zero
    @State private var isSwipping: Bool = false
    @State private var isSwipeUp: Bool = false
    @State private var isSwipeDown: Bool = false
    @State private var isSwipeRight: Bool = false
    @State private var isSwipeLeft: Bool = false
    @State private var isDateActive: Bool = false
    @ObservedObject var viewModel = MyYomangViewModel()

    var body: some View {
        ZStack {
            YomangImageView(data: viewModel.data)
                .onTapGesture {
                    // TODO: 요망 만들기 뷰
                }
            Text("이곳을 눌러 마음을 담아 요망을 보내보세요")
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

struct MyYomangView_Previews: PreviewProvider {
    static var previews: some View {
        MyYomangView()
    }
}
