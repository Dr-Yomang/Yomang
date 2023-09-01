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
                Color.black
                    .overlay(
                        Image("YomangMoon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 1800, height: 1800)
                            .offset(x: -UIScreen.width / 2, y: 1100)
                    )
                VStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                        .opacity(0.4)
                        .overlay {
                            Group {
                                if let imageUrl = viewModel.fetchProfileImg() {
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Image(.yottoGown2)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80)
                                        .offset(x: -5, y: 21)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .offset(y: 32)
                    
                    Text(AuthViewModel.shared.username ?? "나의 요망")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .frame(height: 36)
                        )
                        YomangImageView(data: viewModel.data, index: $index)
                            .overlay {
                                ZStack {
                                    if viewModel.data.count == 0 {
                                        Text("기다리는 동안 상대에게 보여질\n내 프로필 사진을 설정해볼까요?")
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
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        isScaleEffect = true
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        isScaleEffect = false
                                    }
                                }
                            }
                    .scaleEffect(isScaleEffect ? 0.95 : 1)
                    if AuthViewModel.shared.user?.partnerId != nil {
                        PhotoPicker(selectedItem: $selectedItem) {
                            ZStack {
                                Circle()
                                    .frame(width: UIScreen.width * 0.2)
                                    .tint(.gray001)
                                Image(systemName: .plus)
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .bold()
                            }
                            .padding()
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
                    Spacer()
                }
                .offset(y: -16)
            }
        }.navigationDestination(isPresented: $displayPhotoCropper) {
            PhotoCropView(myYomangImage: $myYomangImage, popToRoot: $displayPhotoCropper, viewModel: viewModel, index: $index, isUploadInProgress: $isUploadInProgress)
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
