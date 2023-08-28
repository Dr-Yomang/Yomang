import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSplash = true
    @Binding var matchingIdFromUrl: String?
    @State var nickname: String = "나의 닉네임"
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showSplash {
                SplashView()
            } else { // hide splash
                if viewModel.user != nil {
                    if viewModel.username != nil {
                        YomangView(matchingIdFromUrl: $matchingIdFromUrl)
                    } else {
                        LinkView(matchingIdFromUrl: $matchingIdFromUrl)
                    }
                } else {
                    LoginView(matchingIdFromUrl: $matchingIdFromUrl)

                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { showSplash.toggle() })
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color(hex: 0x2F2745)], startPoint: .top, endPoint: .bottom))
            
            Text("YOMANG")
                .font(.system(size: 48))
                .bold()
                .foregroundColor(.white)
                .offset(y: -200)
        }.ignoresSafeArea()
    }
}
