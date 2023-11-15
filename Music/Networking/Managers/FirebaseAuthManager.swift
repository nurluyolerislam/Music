//
//  FirebaseAuthManager.swift
//  Music
//
//  Created by Erislam Nurluyol on 15.11.2023.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                onError(error)
            }
            guard let result else { return }
            ApplicationVariables.currentUserID = result.user.uid
            onSuccess()
        }
    }
    
    func register(userName: String, email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                onError(error)
            }
            
            guard let result else { return }
            
            let ref = Firestore.firestore().collection("UsersInfo").document(result.user.uid)
            
            let data = [
                "userName" : userName
            ] as! [String : Any]
            
            ApplicationVariables.currentUserID = result.user.uid
            FirestoreService.shared.setData(reference: ref, data: data) {
                onSuccess()
            } onError: { error in
                onError(error)
            }
        }
    }
    
    func signOut(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        do {
            try Auth.auth().signOut()
            onSuccess()
        } catch {
            onError(error)
        }
    }
}