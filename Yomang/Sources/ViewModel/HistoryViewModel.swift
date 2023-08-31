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
        var ourYomangs = [YomangData]()
        // MARK: - 나의 요망
        guard let user = AuthViewModel.shared.user else { return }
        self.collection.whereField("senderUid", isEqualTo: user.id!).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
            ourYomangs = data.sorted(by: { $0.uploadedDate > $1.uploadedDate })
            // MARK: - 파트너 요망
            guard let partnerUid = user.partnerId else {
                self.data = ourYomangs.sorted(by: { $0.uploadedDate > $1.uploadedDate })
                return
            }
            self.collection.whereField("senderUid", isEqualTo: partnerUid).getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let data = documents.compactMap({ try? $0.data(as: YomangData.self) })
                ourYomangs.append(contentsOf: data)
                self.data = ourYomangs.sorted(by: { $0.uploadedDate > $1.uploadedDate })
            }
        }
    }
}
