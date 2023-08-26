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
        self.collection.whereField("senderUid", isEqualTo: user.id!).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            self.data = data.sorted(by: { $0.uploadedDate > $1.uploadedDate })
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
