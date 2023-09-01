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
    
    @ObservedObject var viewModel: MyYomangViewModel
    @Binding var index: Int
    @Binding var isUploadInProgress: Bool
    
    @State var isWarning: Bool = false
    
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
    
    var imagecanvasView: some View {
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.width, height: UIScreen.width)
            MyCanvas(canvasView: $canvasView)
                .frame(width: UIScreen.width, height: UIScreen.width )
        }
    }
    
    var body: some View {
        ZStack {
            
            imagecanvasView
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: UIScreen.width, height: UIScreen.width )
                }.frame(width: UIScreen.width, height: UIScreen.height)
//                .offset(y: isUploadInProgress ? Constants.offsetSize : 0)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button(action: { isWarning.toggle() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(isUploadInProgress ? .gray : .nav100)
                            }
                            .disabled(isUploadInProgress)
                            .alert(isPresented: $isWarning) {
                                Alert(title: Text("꾸미기를 그만두시겠어요? "), message: Text("지금까지 꾸민 요망이 사라져요."), primaryButton: .destructive(Text("그만두기"), action: {dismiss()}), secondaryButton: .cancel(Text("취소")))
                            }
                            
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
                        Text("꾸미기")
                            .foregroundColor(.white)
                            .opacity(isUploadInProgress ? 0.7: 1.0)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("완료") {
                            let image = ZStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.width, height: UIScreen.width )
                                MyCanvas(canvasView: $canvasView)
                                    .frame(width: UIScreen.width, height: UIScreen.width )
                            }.frame(width: UIScreen.width, height: UIScreen.width).offset(y: isUploadInProgress ? 0 : -Constants.offsetSize).saveAsImage(width: UIScreen.width, height: UIScreen.width * 0.98)
                            let data = image.pngData()
                            
                            isUploadInProgress = true

                            myYomangImage.drawingImage = UIImage(data: data!)
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
                }.toolbarBackground(Color(red: 0.15, green: 0.15, blue: 0.15), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            
            if isUploadInProgress {
                Color.black
                    .opacity(0.7)
                ProgressView()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        .ignoresSafeArea()
        .accentColor(.nav100)
    }
}
