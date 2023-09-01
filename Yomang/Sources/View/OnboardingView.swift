//
//  OnboardingView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/09/01.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isShownSheet: Bool
    
    var body: some View {
        TabView {
            FirstOnboardingView()
            
            SecondOnboardingView()
            
            LastOnboardingView(isShownSheet: $isShownSheet)
        }
//        .ignoresSafeArea()
//        .edgesIgnoringSafeArea(.all)
        .presentationDragIndicator(.visible)
        
    }
}

struct FirstOnboardingView: View {
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            Text("기다리는 동안 \n 위젯을 설정해볼까요?")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            Text("요망은 당신과 파트너의 홈 화면에 \n 위젯으로 서로의 사진을 주고 받는 서비스예요. \n 아래 설명에 따라 위젯을 설정해주세요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom)
            
            Spacer()
            
            Text("먼저, 홈 화면을 3초 이상 \n 꾹 눌러주세요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
            
            Image("wid1").offset(y: 40)
                
        }.offset(y: 30)
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.all)
    }
}

struct SecondOnboardingView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("왼쪽 상단에 나타난 \n 더하기 버튼을 눌러주세요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            Image("wid2")
            
            Spacer()
        }
    }
}

struct LastOnboardingView: View {
    @Binding var isShownSheet: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer(minLength: 30)
            
            Text("앱 목록 중 요망을 선택하고 \n 원하는 크기의 위젯을 골라요.")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            Image("wid3")
            
            Spacer()
            
            Button{
                isShownSheet.toggle()
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: 350, height: 56)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    Text("위젯 설정을 완료했어요!")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                }
            }
            
            Spacer()
            
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isShownSheet: .constant(true))
    }
}
