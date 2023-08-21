//
//  MyYomangViewModel.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class MyYomangViewModel: ObservableObject {
    let collection = Firestore.firestore().collection("HistoryDebugCollection")
    
    @Published var data = [YomangData]()
    
    init() {
        fetchMyYomang()
    }
    
    func fetchMyYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        print(user.id ?? "")
        self.collection.whereField("senderUid", isEqualTo: user.id!).getDocuments { snapshot, _ in
            print("snapshot \(snapshot)")
            guard let documents = snapshot?.documents else { return }
            print("documents \(documents)")
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            print("data \(data)")
            self.data = data.sorted(by: { $0.uploadedDate > $1.uploadedDate })
            print(self.data)
        }
    }
    
    func uploadMyYomang(image: UIImage, completion: ((Error?) -> Void)?) {
        guard let user = AuthViewModel.shared.user else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["uploadedDate": Date(),
                        "senderUid": user.id,
                        "receiverUid": user.partnerId ?? "tmp",
                        "imageUrl": imageUrl,
                        "emoji": nil] as [String: Any?]
            
            self.collection.addDocument(data: data, completion: completion)
        }
    }
}
