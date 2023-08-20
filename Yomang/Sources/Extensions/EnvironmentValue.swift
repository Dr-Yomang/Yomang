//
//  EnvironmentValue.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI

private struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue = ViewSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
}

extension EnvironmentValues {
    var screenSize: ViewSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}
