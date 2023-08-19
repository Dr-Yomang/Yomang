//
//  Tab.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case yours = "너의 요망"
    case mine = "나의 요망"
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
    var count: Int {
        return Tab.allCases.count
    }
}
