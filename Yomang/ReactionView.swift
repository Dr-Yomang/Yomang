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
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(.white)
                    .frame(width: 330, height: 100)
                    .cornerRadius(20)
                    .opacity(0.7)
                    
                if animationInProgress {
                    LottieView(animationInProgress: $animationInProgress)
                }
                
                Spacer()
                
                HStack{
                    Button{
                        self.isAnimationVisible = true
                        animationInProgress.toggle()
                        
                    } label: {
                        Circle()
                            .frame(width: 50)
                    }
                    .padding()
                    
                    
                    
                    Button{
                        self.isAnimationVisible = true
                        
                    } label: {
                        Circle()
                            .foregroundColor(.red)
                            .frame(width: 50)
                    }
                    .padding()
                    
                    
                    Button{
                        self.isAnimationVisible = true
                        
                    } label: {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 50)
                    }
                    .padding()
                }
            }
        }.offset(y: 175+24)
    }
}

struct ReactionView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionView()
    }
}
