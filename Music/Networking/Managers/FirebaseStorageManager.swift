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
        .child("Media/\(ApplicationVariables.currentUserID!).jpg")
    
    func uploadUserImage(image: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        FirebaseStorageService.shared.upload(reference: userImageRef, data: imageData) { metadata in
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func fetchUserImage(onSuccess: @escaping (URL) -> Void, onError: @escaping (String) -> Void) {
        FirebaseStorageService.shared.download(reference: userImageRef) { url in
            onSuccess(url)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
}
