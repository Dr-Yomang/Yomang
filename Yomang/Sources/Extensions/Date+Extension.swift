//
//  Date+Extension.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//

import Foundation

extension Date {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
