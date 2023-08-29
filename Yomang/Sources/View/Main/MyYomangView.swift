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
    
    @State private var index = 0
    @State private var isUploadInProgress = false
    @State private var isFetchingInProgress = false
    @State private var isScaleEffect = false
    @State var myYomangImage = MyYomangImage()
    @State private var selectedItem: PhotosPickerItem?
    @State var displayPhotoCropper = false
    @ObservedObject var viewModel = MyYomangViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("YomangMoon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1800, height: 1800)
                    .offset(x: -UIScreen.width / 2, y: 1100)
                    .ignoresSafeArea()
                YomangImageView(data: viewModel.data, index: $index)
                    .overlay {
                        ZStack {
                            if viewModel.data.count == 0 {
                                Text("마음을 담아 요망을 보내보세요")
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
                    .frame(width: UIScreen.width - 40, height: Constants.widgetSize.width / (UIScreen.width - 40) *  Constants.widgetSize.height)
                    .offset(y: -56)
                
                VStack {
                    PhotoPicker(selectedItem: $selectedItem) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 28)
                                .foregroundColor(Color(hex: 0x3D3D3D))
                                .frame(width: 112, height: 72)
                            Text("보내기")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
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
                    //                    .onTapGesture {
                    //                        DispatchQueue.main.async {
                    //                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    //                            withAnimation(.easeIn(duration: 0.3)) {
                    //                                isScaleEffect = true
                    //                            }
                    //                        }
                    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    //                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    //                            withAnimation(.easeOut(duration: 0.5)) {
                    //                                isScaleEffect = false
                    //                            }
                    //                            // TODO: - upload my yomang
                    //                        }
                    //                    }
                    //                    .scaleEffect(isScaleEffect ? 1.05 : 1)
                }
                .padding(Constants.yomangPadding / 2)
                .offset(y: UIScreen.width / 2.2)
                
                VStack {
                    Text(AuthViewModel.shared.username ?? "나의 요망")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 48)
                        )
                    
                }
                .offset(y: -UIScreen.width / 1.45)
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
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                AnyView(label)
            }.tint(.nav100)
    }
}
