//
//  MyYomangView.swift
//  Yomang
//
//  Created by 최민규 on 2023/07/12.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct MyYomangView: View {
    
    @StateObject var motionData = MotionObserver()
    @State private var index = 0
    @State private var dragHeight = CGFloat.zero
    @State private var isSwipping = false
    @State private var isSwipeUp = false
    @State private var isSwipeDown = false
    @State private var isSwipeRight = false
    @State private var isSwipeLeft = false
    @State private var isDateActive = false
    @State private var isUploadInProgress = false
    @State private var isFetchingInProgress = false
    
    @State var myYomangImage = MyYomangImage()
    @State private var selectedItem: PhotosPickerItem?
    @State var displayPhotoCropper = false
    
    @ObservedObject var viewModel = MyYomangViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                YomangImageView(data: viewModel.data, index: $index)
                    .overlay {
                        ZStack {
                            if viewModel.data.count == 0 {
                                Text("이곳을 눌러 마음을 담아 요망을 보내보세요")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            if isUploadInProgress {
                                Color
                                    .black
                                    .opacity(0.5)
                                    .ignoresSafeArea()
                                ProgressView()
                            }
                        }
                    }
                
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
            .navigationDestination(isPresented: $displayPhotoCropper) {
                PhotoCropView(myYomangImage: $myYomangImage, popToRoot: $displayPhotoCropper, viewModel: viewModel, index: $index, isUploadInProgress: $isUploadInProgress)
            }
        }
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
