//
//  MockFirebaseStorageManager.swift
//  MusicTests
//
//  Created by Yaşar Duman on 12.12.2023.
//

@testable import Music
import UIKit

final class MockFirebaseStorageManager: FirebaseStorageManagerProtocol {

    var invokedUploadUserImage = false
    var invokedUploadUserImageCount = 0
    var invokedUploadUserImageParameters: (image: UIImage, Void)?
    var invokedUploadUserImageParametersList = [(image: UIImage, Void)]()

    func uploadUserImage(image: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedUploadUserImage = true
        invokedUploadUserImageCount += 1
        invokedUploadUserImageParameters = (image: image, ())
        invokedUploadUserImageParametersList.append((image: image, ()))
        
        onSuccess()
    }
    
    var invokedFetchUserImage = false
    var invokedFetchUserImageCount = 0

    func fetchUserImage(onSuccess: @escaping (URL) -> Void, onError: @escaping (String) -> Void) {
        invokedFetchUserImage = true
        invokedFetchUserImageCount += 1
        
        onSuccess(MockData.mockURL)
    }
}
