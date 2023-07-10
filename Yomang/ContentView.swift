import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct ContentView: View {
    
    @Binding var matchingID : String?
    
    var body: some View{
        VStack{
            AppleLoginButtonView()
            Text(matchingID ?? "noID")
        }
    }
}


struct AppleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(matchingID: .constant(""))
    }
}
