//
//  YomangWidgetExtension.swift
//  YomangWidgetExtension
//
//  Created by 제나 on 2023/07/04.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseFirestore

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(named: "defaultWidgetImage") ?? UIImage())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), image: UIImage(named: "defaultWidgetImage") ?? UIImage())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entryDate = Date()
        var entry = SimpleEntry(date: entryDate, image: UIImage(named: "defaultWidgetImage") ?? UIImage())
        fetchFromFirestore { data in
            if let data = data {
                if let widgetImage = UIImage(data: data) {
                    entry = SimpleEntry(date: entryDate, image: widgetImage)
                }
            } else {
                entry = SimpleEntry(date: entryDate, image: UIImage(named: "defaultWidgetImage") ?? UIImage())
            }
            // 현재 날짜 및 시간 가져오기
            let components = Calendar.current.dateComponents(in: TimeZone(identifier: "Asia/Seoul")!, from: Date())
            
            // MARK: 위젯 리프레시 타임을 1분으로 설정하는 코드
            let targetDate = Calendar.current.date(from: components)!
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 1, to: targetDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    func fetchFromFirestore(completion: @escaping(Data?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        Constants.userCollection.document(user.uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            guard let partnerUid = user.partnerId else { return }
            
            Constants.historyCollection.whereField("senderUid", isEqualTo: partnerUid).getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let data = documents.compactMap({ try? $0.data(as: YomangData.self) }).sorted(by: { $0.uploadedDate > $1.uploadedDate })
                /// NSData로 변환해 저장
                guard let url = URL(string: data[0].imageUrl) else { return }
                URLSession.shared.dataTask(with: url) { data, _, error in
                    guard let data = data, error == nil else { return }
                    completion(data)
                }.resume()
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct YomangWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
    }
}

struct YomangWidget: Widget {
    init() {
        FirebaseApp.configure()
        do {
            try Auth.auth().useUserAccessGroup("\(teamID).pos.academy.Yomang")
        } catch {
            print(error.localizedDescription)
            print(error)
        }
    }
    let kind: String = "YomangWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YomangWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Yomang")
        .description("요망이들을 위한 위젯입니다 👀")
        .supportedFamilies([.systemSmall])
    }
}

struct YomangWidget_Previews: PreviewProvider {
    static var previews: some View {
        YomangWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "defaultWidgetImage") ?? UIImage()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
