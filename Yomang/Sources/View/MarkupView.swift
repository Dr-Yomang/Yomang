//
//  MarkupView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PencilKit

struct MarkupView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    @Binding var popToRoot: Bool
    
    @State private var canvasView = PKCanvasView()
    
    @Binding var myYomangImage: MyYomangImage
    @State var isTest: Bool = false
    
    @ObservedObject var viewModel: MyYomangViewModel
    @Binding var index: Int
    @Binding var isUploadInProgress: Bool
    
    private var uiImage: UIImage {
        if let data = myYomangImage.croppedImageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(systemName: "person.crop.circle")!
        }
    }
    
    var displayImage: UIImage? {
        if let data = myYomangImage.croppedImageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
    
    var body: some View {
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: Constants.widgetSize.height / Constants.widgetSize.width * UIScreen.width )
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: UIScreen.width, height: Constants.widgetSize.height / Constants.widgetSize.width * UIScreen.width )
                }
            
            MyCanvas(canvasView: $canvasView)
                .frame(width: UIScreen.width, height: Constants.widgetSize.height / Constants.widgetSize.width * UIScreen.width )
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: UIScreen.width, height: Constants.widgetSize.height / Constants.widgetSize.width * UIScreen.width )
                }
            
            if isUploadInProgress {
                Color.black
                    .opacity(0.7)
                ProgressView()
            }
        }
        .offset(y: -28)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(isUploadInProgress ? .gray : .nav100)
                    }
                    .disabled(isUploadInProgress)
                    
                    Button {
                        undoManager?.undo()
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    .disabled(isUploadInProgress)
                    Button {
                        undoManager?.redo()
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                    }
                    .disabled(isUploadInProgress)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("마크업")
                    .foregroundColor(.white)
                    .opacity(isUploadInProgress ? 0.7: 1.0)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("완료") {
                    isUploadInProgress = true
                    myYomangImage.drawingImage = takeCapture()
                    if let image = myYomangImage.drawingImage {
                        viewModel.uploadMyYomang(image: image) { _ in
                            index = 0
                            isUploadInProgress = false
                            viewModel.fetchMyYomang()
                            popToRoot = false
                        }
                    }
                }
                .disabled(isUploadInProgress)
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.15, green: 0.15, blue: 0.15), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .ignoresSafeArea()
        .accentColor(.nav100)
    }
    
    private func takeCapture() -> UIImage {
        var image: UIImage?
        guard let currentLayer = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.layer else { return UIImage() }
        
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
}
