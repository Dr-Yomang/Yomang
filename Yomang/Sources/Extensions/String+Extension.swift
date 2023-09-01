//
//  String+Extension.swift
//  Yomang
//
//  Created by 제나 on 2023/08/07.
//

import Foundation

// MARK: - Localization Methods
extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}

extension String {
    func date2string(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

// MARK: - Localized Strings
extension String {
    /* App */
    static let yomang = "yomang".localized()
    
    /* Authentication */
    static let authenticationMessage = "authentication-agree-message".localized()
    
    /* Setting */
    static let navigationTitleSetting = "navigation-title-setting".localized()
    
    static let headerTitleSettingProfile = "header-title-setting-profile".localized()
    static let buttonMyProfile = "button-my-profile".localized()
    
    static let headerTitleMyUsage = "header-title-my-usage".localized()
    static let buttonConnectPartner = "button-connect-partner".localized()
    static let buttonSettingNotification = "button-setting-notification".localized()
}

// MARK: - Image Names
extension String {
    // MARK: - Assets
    static let yottoHeadOnly = "YottoHeadOnly"
    static let yottoWithUpperBody = "YottoWithUpperBody"
    static let yottoGown1 = "Yotto_Gown_1"
    static let yottoGown2 = "Yotto_Gown_2"
    static let yottoGown3 = "Yotto_Gown_3"
    static let yottoGown4 = "Yotto_Gown_4"
    
    // MARK: - SF Symbols (이름 그대로, 카멜케이스만 적용해서 사용)
    static let bellFill = "bell.fill"
    static let chevronBackward = "chevron.backward"
    static let personFill = "person.fill"
    static let person2Fill = "person.2.fill"
    static let plus = "plus"
    static let person2Slash = "person.2.slash"
}
