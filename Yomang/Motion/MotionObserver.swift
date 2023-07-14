//
//  MotionObserver.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/13.
//

import SwiftUI
import CoreMotion

class MotionObserver: ObservableObject {
    @Published var motionManager = CMMotionManager()
    @Published var xValue: CGFloat = 0
    @Published var yValue: CGFloat = 0
    @Published var movingOffset: CGSize = .zero

    func fetchMotionData(duration: CGFloat) {
        motionManager.startDeviceMotionUpdates(to: .main) {
            data, err in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("ERROR IN DATA")
                return
            }
            withAnimation(.timingCurve(0.18, 0.78, 0.18, 1, duration: 0.77)) {
                self.xValue = data.attitude.roll
                self.yValue = data.attitude.pitch
                self.movingOffset = self.getOffset(duration: duration)
            }
        }
    }
    
    func getOffset(duration: CGFloat) -> CGSize {
        
        var width = xValue * duration
        var height = yValue * duration
        
        width = (width < 0 ? (-width > 16 ? -16 : width) : (width > 16 ? 16 : width))
        height = (height < 0 ? (-height > 16 ? -16 : height) : (height > 16 ? 16 : height))
        
        return CGSize(width: width, height: height)
    }
    
}
