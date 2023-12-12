//
//  FirebaseStorageManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 18.11.2023.
//

import FirebaseStorage
import UIKit

protocol FirebaseStorageManagerProtocol {
    func uploadUserImage(image: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void)
    func fetchUserImage(onSuccess: @escaping (URL) -> Void, onError: @escaping (String) -> Void)
}

final class FirebaseStorageManager {
    private let userImageRef = Storage.storage()
        .reference()
        .child("Media/\(ApplicationVariables.currentUserID!).jpg")
    
    static let shared = FirebaseStorageManager()
    private let firebaseStorageService: FirebaseStorageService
    
    private init(firebaseStorageService: FirebaseStorageService = FirebaseStorageService.shared) {
        self.firebaseStorageService = firebaseStorageService
    }
}

extension FirebaseStorageManager: FirebaseStorageManagerProtocol {
    
    func uploadUserImage(image: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        firebaseStorageService.upload(reference: userImageRef, data: imageData) { metadata in
            onSuccess()
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
    func fetchUserImage(onSuccess: @escaping (URL) -> Void, onError: @escaping (String) -> Void) {
        firebaseStorageService.download(reference: userImageRef) { url in
            onSuccess(url)
        } onError: { error in
            onError(error.localizedDescription)
        }
    }
    
}
