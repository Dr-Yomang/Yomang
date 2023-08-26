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

    private var uiImage: UIImage {
        if let data = myYomangImage.croppedImageData,
           let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(systemName: "person.crop.circle")!
        }
    }
    
    @Binding var myYomangImage: MyYomangImage
    @State var isTest: Bool = false
    
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
            Color.black
            VStack {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Constants.widgetSize.width,
                               height: Constants.widgetSize.height)
                        .mask {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: Constants.widgetSize.width,
                                       height: Constants.widgetSize.height)
                        }
                    
                    MyCanvas(canvasView: $canvasView)
                        .frame(width: Constants.widgetSize.width,
                               height: Constants.widgetSize.height)
                        .mask {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: Constants.widgetSize.width,
                                       height: Constants.widgetSize.height)
                        }
                }
                
            }
            
        }
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: { undoManager?.undo() }) {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    Button(action: {  undoManager?.redo() }) {
                        Image(systemName: "arrow.uturn.forward.circle")
                    }

                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("마크업")
                .foregroundColor(.white)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("완료") {
                    myYomangImage.drawingImage = takeCapture()
                    popToRoot = false
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.15, green: 0.15, blue: 0.15), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .ignoresSafeArea()
            .accentColor(.nav100)
    }
    
    func takeCapture() -> UIImage {
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

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView(popToRoot: .constant(false), myYomangImage: .constant(MyYomangImage()))
    }
}
