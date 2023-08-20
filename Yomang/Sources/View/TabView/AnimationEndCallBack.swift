//
//  AnimationEndCallBack.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI

struct AnimationState {
    var progress: CGFloat = 0
    var status: Bool = false
    
    mutating func startAnimation() {
        progress = 1.0
        status = true
    }
    
    mutating func reset() {
        progress = .zero
        status = false
    }
}

struct AnimationEndCallback<Value: VectorArithmetic>: Animatable, ViewModifier {
    var animatableData: Value {
        didSet {
            checkIfAnimationFinished()
        }
    }
    
    var endValue: Value
    var onEnd: () -> Void
    
    init(endValue: Value, onEnd: @escaping () -> Void) {
        self.endValue = endValue
        self.animatableData = endValue
        self.onEnd = onEnd
    }
    
    func body(content: Content) -> some View {
        content
    }
    
    func checkIfAnimationFinished() {
         if animatableData == endValue {
            DispatchQueue.main.async {
                onEnd()
            }
        }
    }
}

