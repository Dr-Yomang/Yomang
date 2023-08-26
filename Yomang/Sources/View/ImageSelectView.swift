//
//  ImageSelectView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PhotosUI

struct ImageSelectView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @State var displayPhotoCropper = false
    @Binding var myYomangImage: MyYomangImage
    @ObservedObject var viewModel: MyYomangViewModel
    @Binding var index: Int
    @Binding var isUploadInProgress: Bool
    
    var body: some View {
        ZStack {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.width, height: UIScreen.width)
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
            PhotoCropView(myYomangImage: $myYomangImage, popToRoot: $displayPhotoCropper, viewModel: viewModel, index: $index, isUploadInProgress: $isUploadInProgress)
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
                .tint(.nav100)
                .buttonStyle(.borderedProminent)
        }
    }
}
