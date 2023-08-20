//
//  HistoryViewModel.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class HistoryViewModel: ObservableObject {
    let collection = Firestore.firestore().collection("HistoryDebugCollection")
    
    @Published var data = [YomangData]()
    
    init() {
        fetchAllYomang()
    }
    
    func fetchAllYomang() {
        guard let user = AuthViewModel.shared.user else { return }
        self.collection.whereField("senderUid", isEqualTo: user.id!).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            self.data = data.sorted(by: { $0.uploadedDate > $1.uploadedDate })
        }
        
        guard let partnerUid = user.partnerId else { return }
        self.collection.whereField("senderUid", isEqualTo: partnerUid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            self.data.append(contentsOf: data.sorted(by: { $0.uploadedDate > $1.uploadedDate }))
        }
    }
}
