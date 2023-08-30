//
//  EditProfileView.swift
//  Yomang
//
//  Created by 제나 on 2023/08/30.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var viewModel = SettingViewModel()
    @State var selectedImage: PhotosPickerItem?
    
    var body: some View {
        VStack {
            // MARK: - 프로필 이미지
            ZStack {
                Circle()
                    .frame(width: 122, height: 122)
                    .foregroundColor(.black)
                
                if let profileImgUrl = viewModel.profileImageUrl {
                    KFImage(URL(string: profileImgUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image("yt_surprise")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                }
                Circle()
                    .trim(from: 0.08, to: 0.42)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.black)
                    .opacity(0.7)
                
                PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                    VStack {
                        Spacer()
                        
                        Text("편집")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                    }.frame(width: 120, height: 120)
                }
            }
            // MARK: - 유저네임
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
