//
//  Color+Extension.swift
//  Yomang
//
//  Created by 제나 on 2023/07/04.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    static let nav100 = Color(hex: 0x8A42FF)
    
    static let gray001 = Color(hex: 0x3d3d3d)
    static let gray002 = Color(hex: 0x666666)
}
