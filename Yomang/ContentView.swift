import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct ContentView: View {
    
    @Binding var matchingIDTest: String?
    @State var nowuser = Auth.auth().currentUser
    
    var body: some View {
        VStack {
            AppleLoginButtonView()
            Text(matchingIDTest ?? "noID")
            Text(nowuser?.uid ?? "No")
        }
    }
}

struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(matchingIDTest: .constant(nil))
    }
}
