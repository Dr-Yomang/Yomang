//
//  ImageUploader.swift
//  Yomang
//
//  Created by 제나 on 2023/08/20.
//
import Foundation
import FirebaseStorage
import UIKit

struct ImageUploader {
    
    enum UploadType: String {
        case profile
        case yomang
    }
    
    static func uploadImage(image: UIImage, type: UploadType, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "\(type.rawValue)/\(filename)")
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("DEBUG: failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, _ in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
