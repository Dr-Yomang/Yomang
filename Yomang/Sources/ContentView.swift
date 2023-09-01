import SwiftUI
import Firebase
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
//                    .onAppear() {
//                        print("current user")
////                        try? Auth.auth().signOut()
////                        print(Auth.auth().currentUser)
////                        print(AuthViewModel.shared.user)
////                        print(AuthViewModel.shared.userSession)
////                        print(AuthViewModel.shared.username)
//
//                    }
            } else { // hide splash
                if viewModel.userSession != nil {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { showSplash.toggle() })
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
