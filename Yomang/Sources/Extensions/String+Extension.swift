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

// MARK: - Image Names
extension String {
    static let yotto1 = "Yotto1"
}
