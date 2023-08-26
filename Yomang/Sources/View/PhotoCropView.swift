//
//  PhotoCropView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI

struct PhotoCropView: View {
    @Binding var myYomangImage: MyYomangImage
    @Binding var popToRoot: Bool
    
    @State private var zoomScale: CGFloat = 1
    @State private var lastZoom: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State var nextView: Bool = false
    @ObservedObject var viewModel: MyYomangViewModel
    @Binding var index: Int
    @Binding var isUploadInProgress: Bool
    
    private var uiImage: UIImage {
        if let data = myYomangImage.imageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(systemName: "person.crop.circle")!
        }
    }
    
    private var imageScale: CGFloat {
        if uiImage.shortSide / uiImage.longSide >= imageConstraint / UIScreen.main.bounds.height {
            return imageConstraint / uiImage.shortSide
        } else {
            return UIScreen.main.bounds.height / uiImage.longSide
        }
    }
    
    private var imageConstraint: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var body: some View {
        ZStack {
            ZStack {
                if uiImage.imageOrientation == .portrait {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .position(x: UIScreen.main.bounds.width / 2,
                                  y: UIScreen.main.bounds.height / 2)
                        .mask(Color.black.opacity(0.5))
                        .scaleEffect(zoomScale)
                        .offset(offset)
                }
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageConstraint, height: imageConstraint)
                    .position(x: UIScreen.main.bounds.width / 2,
                              y: UIScreen.main.bounds.height / 2)
                    .scaleEffect(zoomScale)
                    .offset(offset)
                    .mask {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: imageConstraint,
                                   height: imageConstraint / Constants.widgetSize.width * Constants.widgetSize.height )
                    }
                    .gesture(panGesture.simultaneously(with: zoomGesture))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        withAnimation {
                            zoomScale = 1.0
                            offset = CGSizeZero
                        }
                    } label: {
                        Text("재설정")
                    }
                    .foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    nextButton
                        .navigationDestination(isPresented: $nextView) {
                        MarkupView(popToRoot: $popToRoot, myYomangImage: $myYomangImage, viewModel: viewModel, index: $index, isUploadInProgress: $isUploadInProgress)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.15, green: 0.15, blue: 0.15), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .accentColor(.nav100)
        }
        .ignoresSafeArea()
        .background(Color.black)
    }
}

// MARK: - FUNCTIONS
extension PhotoCropView {
    func saveImage() {
        guard let croppedImage = cropImage(uiImage) else { return }
        myYomangImage.croppedImageData = croppedImage.pngData()
        myYomangImage.scale = Double(zoomScale)
        myYomangImage.position = offset
    }
    
    func cropImage(_ image: UIImage) -> UIImage? {
        guard let cgImage: CGImage = image.fixOrientation().cgImage else {
            print("failed to convert to CGImage")
            return nil
        }
        
        let imageWidth: CGFloat = CGFloat(cgImage.width)
        let imageHeight: CGFloat = CGFloat(cgImage.height)
        
        var cropRect: CGRect {
            let cropSizeWidth: CGFloat = (imageConstraint / imageScale) / zoomScale
            let cropSizeHeight: CGFloat = imageConstraint /  Constants.widgetSize.width * Constants.widgetSize.height / imageScale / zoomScale
            let initialX: CGFloat = (imageWidth - cropSizeWidth) / 2
            let initialY: CGFloat = (imageHeight - cropSizeHeight) / 2
            let xOffset: CGFloat = initialX - (offset.width / imageScale) / zoomScale
            let yOffset: CGFloat = initialY - (offset.height / imageScale) / zoomScale
            let rect = CGRect(x: xOffset, y: yOffset, width: cropSizeWidth, height: cropSizeHeight)
            return rect
            
        }
        
        guard let croppedImage = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: croppedImage)
    }
    
    private func setOffsetAndScale() {
        let newZoom: CGFloat = min(max(zoomScale, 1), 4)
        let imageWidth = (uiImage.size.width * imageScale) * newZoom
        let imageHeight = (uiImage.size.height * imageScale) * newZoom
        
        var width: CGFloat {
            if imageWidth > imageConstraint {
                let widthLimit: CGFloat = (imageWidth - imageConstraint) / 2
                
                if offset.width > 0 {
                    return min(widthLimit, offset.width)
                } else {
                    return max(-widthLimit, offset.width)
                }
            } else {
                return .zero
            }
        }
        
        var height: CGFloat {
            if imageHeight > imageConstraint {
                let heightLimit: CGFloat = (imageHeight - imageConstraint) / 2
                
                if offset.height > 0 {
                    return min(heightLimit, offset.height)
                } else {
                    return max(-heightLimit, offset.height)
                }
            } else {
                return .zero
            }
        }
        
        let newOffset = CGSize(width: width, height: height)
        
        lastOffset = newOffset
        lastZoom = newZoom
        
        withAnimation {
            offset = newOffset
            zoomScale = newZoom
        }
    }
    
    func loadPreviousValues() {
        if myYomangImage.croppedImageData != nil {
            if myYomangImage.position != .zero {
                offset = myYomangImage.position
                lastOffset = myYomangImage.position
            }
            
            if myYomangImage.scale != 0 {
                zoomScale = myYomangImage.scale
                lastZoom = myYomangImage.scale
            }
        }
    }
}

// MARK: - GESTURES
extension PhotoCropView {
    var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { gesture in
                zoomScale = lastZoom * gesture
            }
            .onEnded { _ in
                setOffsetAndScale()
            }
    }
    
    var panGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                var newOffset = lastOffset
                newOffset.width += gesture.translation.width
                newOffset.height += gesture.translation.height
                offset = newOffset
            }
            .onEnded { _ in
                setOffsetAndScale()
            }
    }
}

// MARK: - LOCAL COMPONENTS
extension PhotoCropView {
    private var widgetMask: Path {
        let rect = CGRect(x: 0, y: 0, width: imageConstraint, height: UIScreen.main.bounds.height)
        let innerRect = CGRect(x: 0, y: 0, width: imageConstraint, height: UIScreen.main.bounds.height)
        var shape = RoundedRectangle(cornerRadius: 10).path(in: rect)
        shape.addPath(RoundedRectangle(cornerRadius: 10).path(in: innerRect))
        return shape
    }
    
    private var nextButton: some View {
        Button {
            nextView.toggle()
            saveImage()
        } label: {
            Text("다음")
        }
    }
    
}
