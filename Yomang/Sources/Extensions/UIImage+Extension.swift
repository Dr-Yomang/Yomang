//
//  UIImage+Extension.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import Foundation
import SwiftUI

enum OrientationFormat {
    case landscape, portrait
}

extension UIImage {
    var imageOrientation: OrientationFormat {
        if self.size.height >= self.size.width {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    var longSide: CGFloat {
        if imageOrientation == .portrait {
            return self.size.height
        } else {
            return self.size.width
        }
    }
    
    var shortSide: CGFloat {
        if imageOrientation == .portrait {
            return self.size.width
        } else {
            return self.size.height
        }
    }
    
    func fixOrientation() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        UIGraphicsEndImageContext()
        return image
    }
}
