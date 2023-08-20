//
//  ImageSelectView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PhotosUI

struct ImageSelectViewContainer: View {
    
    @State var myYomangImage = MyYomangImage()
    
    var body: some View {
        NavigationStack {
            VStack {
                ImageSelectView(myYomangImage: $myYomangImage)
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .background(Color.black)
        }
    }
}

struct ImageSelectView: View {
    // 마크업 사진은 전체 화면 캡쳐한 이미지 -> 마스크로 위젯 사이즈 맞춰서 가리고 있음!
    @Environment(\.screenSize) var screenSize
    @State private var selectedItem: PhotosPickerItem?
    @Binding var myYomangImage: MyYomangImage
    
    @State var displayPhotoCropper = false
    
    private var imageConstraint: CGFloat {
        return screenSize.shortSide
    }
    
    var body: some View {
        ZStack {
            Color.black
            ZStack {
                ZStack {
                    if myYomangImage.drawingImage != nil {
                        Image(uiImage: myYomangImage.drawingImage!)
                            .resizable()
                            .scaledToFill()
                            .mask {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: Constants.widgetSize.width,
                                           height: Constants.widgetSize.height)
                            }
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                    }
                }
                .frame(width: screenSize.width, height: screenSize.height, alignment: .center)
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: screenSize.width, height: screenSize.width)
                        .foregroundColor(.clear)
                        .padding()
                    
                    PhotoPicker(selectedItem: $selectedItem) {
                        Label("Select a photo", systemImage: "photo")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                myYomangImage.imageData = data
                                myYomangImage.croppedImageData = nil
                            }
                        }
                        displayPhotoCropper = true
                    }
                }
            }
            .navigationTitle("")
            .navigationDestination(isPresented: $displayPhotoCropper) {
                PhotoCropView(myYomangImage: $myYomangImage, popToRoot: $displayPhotoCropper)
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
}

// MARK: - PHOTO PICKER
private struct PhotoPicker: View {
    
    @Binding var selectedItem: PhotosPickerItem?
    @ViewBuilder var label: any View
    
    var body: some View {
        ZStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    AnyView(label)
                }
                .foregroundColor(Color(UIColor.systemBackground))
                .tint(.purple)
                .buttonStyle(.borderedProminent)
        }
    }
}
