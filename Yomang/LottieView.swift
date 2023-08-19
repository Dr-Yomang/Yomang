//
//  LottieView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/07/24.
//

import Lottie
import SwiftUI
import UIKit


struct LottieView: UIViewRepresentable {
    
    @Binding var animationInProgress: Bool
    let lottieName: String
    
    func makeUIView(context: Context) -> some LottieAnimationView {
        let lottieAnimationView = LottieAnimationView(name: lottieName)
        lottieAnimationView.play { complete in
            if complete {
                animationInProgress = false
            }
        }
        return lottieAnimationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
