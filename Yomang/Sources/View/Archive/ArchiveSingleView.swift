//
//  ArchiveSingleView.swift
//  Yomang
//
//  Created by 제나 on 2023/09/01.
//

import SwiftUI
import Kingfisher
import Photos

struct ArchiveSingleView: View {
    
    @State private var imageUrl: String?
    @State private var isImageSaved = false
    @State private var isAleert = false

    let data: YomangData
    @Environment(\.dismiss) private var dismiss
    private let width = UIScreen.width - 40
    private var height: CGFloat {
        return Constants.widgetSize.height / Constants.widgetSize.width * width
    }
    var body: some View {
        ZStack {
            KFImage(URL(string: data.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: width,
                       height: height)
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: width,
                               height: height)
                }
                .padding(.horizontal, 20)
                .overlay {
                    if let emoji = data.emoji {
                        Image(emoji[0])
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.width / 3)
                            .padding(.top, height / 2)
                            .padding(.leading, width / 2)
                    }
                }
            VStack {
                Spacer()
                ZStack {
                    Button {
                        saveImageToAlbum(data.imageUrl)
                        isAleert.toggle()
                    } label: {
                        Image(systemName: "arrow.down.to.line.compact")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.width / 2, height: 50)
                            .padding(.bottom, 20)
                    }
                }
                .frame(width: UIScreen.width, height: 84)
                .background(Color(hex: 0x3D3D3D))
            }
        }
        .ignoresSafeArea()
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isAleert) {
            Alert(title: Text("요망을 사진첩에 저장했습니다."), message: Text("즐거운 요망!"), dismissButton: .cancel(Text("확인")))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: .chevronBackward)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    func saveImageToAlbum(_ imageUrl: String) {
            // Kingfisher를 사용하여 URL에서 이미지를 다운로드합니다.
            if let url = URL(string: imageUrl) {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        // 다운로드한 이미지를 앨범에 저장합니다.
                        PHPhotoLibrary.shared().performChanges {
                            PHAssetChangeRequest.creationRequestForAsset(from: value.image)
                        } completionHandler: { success, error in
                            if success {
                                DispatchQueue.main.async {
                                    isImageSaved = true
                                }
                            } else {
                                if let error = error {
                                    print("Error saving image: \(error.localizedDescription)")
                                }
                            }
                        }

                    case .failure(let error):
                        print("Error downloading image: \(error.localizedDescription)")
                    }
                }
            }
        }
}
