//
//  MyYomangImageModel.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import Foundation
import PencilKit

struct MyYomangImage {
    var imageData: Data?
    var croppedImageData: Data?
    var scale: Double = 0
    var position: CGSize = .zero
    var drawingImage: UIImage? = UIImage(systemName: "person.crop.circle")!
}
