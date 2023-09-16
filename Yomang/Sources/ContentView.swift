import SwiftUI
import Firebase

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSplash = true
    @State var navigateToYomangView = false
    @State var nickname: String = "나의 닉네임"
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showSplash {
                SplashView()
            } else { // hide splash
                if viewModel.userSession != nil {
                    if viewModel.matchingIdFromUrl != nil || navigateToYomangView {
                        YomangView()
                    } else {
                        LinkView(navigateToYomangView: $navigateToYomangView)
                    }
                } else {
                    LoginView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                showSplash.toggle()
            })
        }
    }
}

struct SplashView: View {
    @State var isChange: Bool = false
    var body: some View {
        ZStack {
   
                if !isChange {
                    Image("on").resizable()
                        .scaledToFit()
                } else {
                    Image("wink").resizable()
                        .scaledToFit()
                }
        }.frame(width: UIScreen.width * 0.43, height: UIScreen.height * 0.24)
        .offset(y: -UIScreen.height * 0.1)
        .ignoresSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                 isChange.toggle() })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: {
                 isChange.toggle() })
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
