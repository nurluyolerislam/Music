//
//  FirebaseStorageManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 18.11.2023.
//

import FirebaseStorage
import UIKit.UIImage

final class FirebaseStorageManager {
    
    private let userImageRef = Storage.storage()
        .reference()
        .child("Media/\(ApplicationVariables.currentUserID).jpg")
    
    func uploadImage(image: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        userImageRef.putData(imageData) { storageMetaData, error in
            if let error = error {
                onError(error.localizedDescription)
            }
            onSuccess()
        }
    }
    
    func fetchImage(onSuccess: @escaping (URL) -> Void, onError: @escaping (String) -> Void) {
        userImageRef.downloadURL { url, error in
            if let error = error {
                onError(error.localizedDescription)
            }
            
            guard let url else { return }
            onSuccess(url)
        }
    }
}
