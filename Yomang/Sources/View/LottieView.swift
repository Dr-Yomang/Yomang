//
//  LottieView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/15.


import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    let contentMode: UIView.ContentMode
    @Binding var play: Bool

    let animationView: LottieAnimationView

    init(name: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1, contentMode: UIView.ContentMode = .scaleAspectFit, play: Binding<Bool> = .constant(true)) {
        self.name = name
        self.animationView = LottieAnimationView(name: name)
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        self.contentMode = contentMode
        self._play = play
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        animationView.contentMode = contentMode
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if play {
            animationView.play { _ in
                play = false
            }
        }
    }
}



////
////  LottieView.swift
////  MC3
////
////  Created by Niko Yejin Kim on 2023/07/21.
////
//import Lottie
//import SwiftUI
//import UIKit
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        let animationView: AnimationView = .init(name: "rainyD")
//        self.view.addSubview(animationView)
//
//
//        // animationView의 설정 작업은 알아서 하세요
//        animationView.frame = self.view.bounds
//        animationView.center = self.view.center
//        animationView.contentMode = .scaleAspectFit
//
//    }
//}
//
