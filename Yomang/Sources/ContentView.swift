import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSplash = true
    @Binding var matchingIdFromUrl: String?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showSplash {
                SplashView()
            } else { // hide splash
                if let user = viewModel.user {
                    if user.username == nil {
                        LinkView(matchingIdFromUrl: $matchingIdFromUrl)
                    } else {
                        YomangView(matchingIdFromUrl: $matchingIdFromUrl)
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
