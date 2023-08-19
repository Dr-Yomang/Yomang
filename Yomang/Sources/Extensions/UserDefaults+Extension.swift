//
//  UserDefaults+Extension.swift
//  Yomang
//
//  Created by 제나 on 2023/08/16.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.academy.Yomang"
        return UserDefaults(suiteName: appGroupId)!
    }
}
