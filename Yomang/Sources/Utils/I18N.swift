//
//  I18N.swift
//  Yomang
//
//  Created by 제나 on 2023/08/07.
//

/*
 Internationalization: I18N (일반적으로 쓰이는 용어)
 
 Using localization
 https://developer.apple.com/documentation/swiftui/preparing-views-for-localization
 %lld: Integer
 %@: String
 Text("\(copyOperation.numFiles, specifier: "%lld")")
 */

// MARK: - Resources/Localization/Localizable.string에서 ko, en 먼저 정의한 후 이곳에서 상수화 작업을 진행합니다.
import Foundation

struct I18N {
    /* App */
    static let yomang = "yomang".localized()
    
    /* Authentication */
    static let authenticationMessage = "authentication-agree-message".localized()
}
