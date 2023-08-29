//
//  DeepLinkURLViewModel.swift
//  Yomang
//
//  Created by NemoSquare on 8/29/23.
//

import Foundation

class DeepLinkURLViewModel {

  enum DeepLink: Equatable {
    case home
    case details(partnerId: String)
  }

  // Parse url
  func parseComponents(from url: URL) -> DeepLink? {
    // url이 https로 시작 안하면 리턴 (잘못된 url)
    guard url.scheme == "https" else {
      return nil
    }
    // 2
    guard url.pathComponents.contains("about") else {
      return .home
    }
    // 3
    guard let query = url.query else {
      return nil
    }
    // 4
    let components = query.split(separator: ",").flatMap {
      $0.split(separator: "=")
    }
    // 5
    guard let idIndex = components.firstIndex(of: Substring("recipeID")) else {
      return nil
    }
    // 6
    guard idIndex + 1 < components.count else {
      return nil
    }
    // 7
    return .details(partnerId: String(components[idIndex + 1]))
  }
}
