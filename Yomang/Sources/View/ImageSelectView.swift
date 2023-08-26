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

struct ImageSelectViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectViewContainer()
    }
}

struct ImageSelectView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var myYomangImage: MyYomangImage
    @State var displayPhotoCropper = false
    
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
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).padding().frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
                    }
                }
                
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
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
                .tint(.nav100)
                .buttonStyle(.borderedProminent)
        }
    }
}
