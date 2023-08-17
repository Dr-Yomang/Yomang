//
//  ReactionView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/07/24.
//

import SwiftUI

struct ReactionView: View {
    @State private var isAnimationVisible: Bool = false
    @State var animationInProgress = false
    @State private var selectedIndex: Int? = nil
    @State private var lottieName: String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 330, height: 100)
                .cornerRadius(20)
                .opacity(0.7)
            
            if animationInProgress {
                LottieView(animationInProgress: $animationInProgress, lottieName: lottieName)
            }
            
            Spacer()
            
            HStack{
                Button{
                    self.isAnimationVisible = true
                    animationInProgress.toggle()
                    selectedIndex = 0
                    lottieName = "reaction"
                
                } label: {
                    Circle()
                        .frame(width: 50)
                }
                .padding()
                
                Button{
                    self.isAnimationVisible = true
                    animationInProgress.toggle()
                    selectedIndex = 1
                    lottieName = "secondreaction"
                    
                } label: {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 50)
                }
                .padding()
                
                
                Button{
                    self.isAnimationVisible = true
                    animationInProgress.toggle()
                    selectedIndex = 2
                    lottieName = "thirdreaction"
                    
                } label: {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 50)
                }
                .padding()
            }
        }
        .offset(y: 175+24)
    }
}

struct ReactionView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionView()
    }
}
