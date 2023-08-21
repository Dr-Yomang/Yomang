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
    @ObservedObject var viewModel: MyYomangViewModel
    @State private var isUploadInProgress = false
    @State private var isFetchingInProgress = false

    var body: some View {
        ZStack {
            YomangImageView(data: viewModel.data)
                .onTapGesture {
                    isUploadInProgress = true
                    // TODO: 요망 만들기 뷰
                    viewModel.uploadMyYomang(image: UIImage(named: "image\(Int.random(in: 0..<7))")!) { _ in
                        viewModel.fetchMyYomang()
                        isUploadInProgress = false
                    }
                }
                .overlay {
                    ZStack {
                        if viewModel.data.count == 0 {
                            Text("이곳을 눌러 마음을 담아 요망을 보내보세요")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        if isUploadInProgress {
                            Color
                                .black
                                .opacity(0.5)
                                .ignoresSafeArea()
                            ProgressView()
                        }
                    }
                }
        }
    }
}
