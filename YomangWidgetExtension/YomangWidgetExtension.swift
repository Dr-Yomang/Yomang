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
        SimpleEntry(date: Date(), image: UIImage(named: "hani") ?? UIImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), image: UIImage(named: "wonyong") ?? UIImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entryDate = Date()
        var entry = SimpleEntry(date: entryDate, image: UIImage(named: "wonyong") ?? UIImage())
        fetchFromFirestore { successFetchData in
            if successFetchData {
                if let widgetImageData = UserDefaults(suiteName: "group.academy.Yomang")?.data(forKey: "widgetImage"),
                   let widgetImage = UIImage(data: widgetImageData) {
                    entry = SimpleEntry(date: entryDate, image: widgetImage)
                }
            } else {
                entry = SimpleEntry(date: entryDate, image: UIImage(named: "wonyong") ?? UIImage())
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
    
    func fetchFromFirestore(completion: @escaping(Bool) -> Void) {
        guard let partnerUid = UserDefaults.shared.string(forKey: "partnerId") else {
            completion(false)
            return
        }
        let collection = Firestore.firestore().collection("HistoryDebugCollection")
        
        collection.whereField("senderUid", isEqualTo: partnerUid).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let data = documents.compactMap({ try? $0.data(as: YomangData.self) }).sorted(by: { $0.uploadedDate > $1.uploadedDate })
            /// NSData로 변환해 저장
            guard let url = URL(string: data[0].imageUrl) else { return }
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                self.setImageInUserDefaults(UIImage: UIImage(data: data) ?? UIImage(), "widgetImage")
                completion(true)
            }.resume()
        }
    }
    
    /// UIImage convert to NSData
    func setImageInUserDefaults(UIImage value: UIImage, _ key: String) {
        let imageData = value.jpegData(compressionQuality: 0.5)
        UserDefaults.shared.set(imageData, forKey: key)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct YomangWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFill()
            Text(entry.date, style: .time)
        }
    }
}

struct YomangWidget: Widget {
    init() {
        FirebaseApp.configure()
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
        YomangWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "hani") ?? UIImage()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

// - MARK: Extension - UserDefaults
extension UserDefaults {
    static var shared: UserDefaults {
            let appGroupID = "group.academy.Yomang"
            return UserDefaults(suiteName: appGroupID)!
        }
}
