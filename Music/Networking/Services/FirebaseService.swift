//
//  FirebaseService.swift
//  Music
//
//  Created by Yaşar Duman on 13.11.2023.
//

import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func getField<T: Codable>(reference: DocumentReference, fieldName: String, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void)
    
    func getDocument<T: Codable>(reference: DocumentReference, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void)
    
    func getDocuments<T: Codable>(reference: CollectionReference, onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void)
    
    func setData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    
    func updateData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    
    func deleteDocument(reference: DocumentReference, onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    
    func deleteCollection(reference: CollectionReference, onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    
    func checkDocumentExists(reference: DocumentReference, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void)
}

final class FirestoreService: FirestoreServiceProtocol {
    
    static let shared = FirestoreService()
    
    private init() {}
    
    func getDocument<T: Codable>(reference: DocumentReference, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        
        reference.getDocument { snapshot, error in
            if let error { onError(error) }
            
            guard let document = snapshot else { return }
            
            do {
                let response =  try document.data(as: T.self)
                onSuccess(response)
            } catch {
                onError(error)
            }
        }
    }
    
    func getDocuments<T: Codable>(reference: CollectionReference, onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void) {
        reference.getDocuments { snapshot, error in
            if let error { onError(error) }
            guard let documents = snapshot?.documents else { return }
            let response = documents.compactMap({try? $0.data(as: T.self)})
            onSuccess(response)
        }
    }
    
    func setData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void) {
        reference.setData(data) { error in
            if let error { onError(error) }
            onSuccess?()
        }
    }
    
    func deleteDocument(reference: DocumentReference, onSuccess: (() -> Void)? = nil, onError: @escaping (Error) -> Void) {
        reference.delete { error in
            if let error { onError(error) }
            onSuccess?()
        }
    }
    
    func deleteCollection(reference: CollectionReference, onSuccess: (() -> Void)? = nil, onError: @escaping (Error) -> Void) {
        reference.getDocuments { snapshot, error in
            if let error { onError(error) }
            guard let documents = snapshot?.documents else { return }
            documents.forEach { document in
                document.reference.delete { error in
                    if let error { onError(error) }
                }
            }
            onSuccess?()
        }
    }
    
    func getField<T: Codable>(reference: DocumentReference, fieldName: String, onSuccess: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        reference.getDocument { snapshot, error in
            if let error { onError(error) }
            guard let fieldValue = snapshot?.get(fieldName) as? T else { return }
            onSuccess(fieldValue)
        }
    }
    
    func checkDocumentExists(reference: DocumentReference, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void) {
        reference.getDocument { snapshot, error in
            if let error { onError(error) }
            if let document = snapshot { onSuccess(document.exists) }
        }
    }
    
    func updateData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void) {
        reference.updateData(data) { error in
            if let error { onError(error) }
            onSuccess?()
        }
    }
    
}
