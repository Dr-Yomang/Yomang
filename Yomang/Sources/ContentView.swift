import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSplash = true
    @State private var matchingIdFromUrl: String?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if showSplash {
                SplashView()
            } else { // hide splash
                if viewModel.user != nil {
                    if viewModel.username == nil {
                        LinkView()
                    } else {
                        YomangView()
                    }
                } else {
                    LoginView(matchingIdFromUrl: $matchingIdFromUrl)
                        .onOpenURL { url in
                            if url.scheme! == "YomanglabYomang" && url.host! == "share" {
                                if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
                                    for query in components.queryItems! {
                                        // 링크에 상대 매칭코드 없으면 nil, 아니면 링크에서 얻어온 매칭코드 값 넣기
                                        matchingIdFromUrl = query.value ?? nil
                                    }
                                }
                            }
                        }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                showSplash.toggle()
            })
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
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
