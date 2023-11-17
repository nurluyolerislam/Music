//
//  AuthVM.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

class AuthVM{
    lazy var firebaseAuthManager = FirebaseAuthManager()
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping () -> Void) {
        firebaseAuthManager.signIn(email: email, password: password) {
            completion()
        } onError: { error in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Register
    func register(userName: String, email: String, password: String, completion: @escaping () -> Void) {
        firebaseAuthManager.register(userName: userName,
                                     email: email,
                                     password: password) {
            completion()
        } onError: { error in
            print(error)
        }

    }
    
    // MARK: - ForgotPassword
    func resetPassword(email: String, completion: @escaping (Bool, String) -> Void) {
        guard !email.isEmpty else {
            completion(false, "E-posta alanı boş bırakılamaz.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Şifre sıfırlama işlemi başarısız
                completion(false, "Şifre sıfırlama hatası: \(error.localizedDescription)")
            } else {
                // Şifre sıfırlama işlemi başarılı
                completion(true, "Şifrenizi sıfırlamak için e-posta gönderildi.")
            }
        }
    }
    
    func signInGoogle(credential: AuthCredential, username: String, completion: @escaping () -> Void) {
    
        firebaseAuthManager.signInWithCredential(credential: credential, username: username) {
            completion()
        } onError: { error in
            print(error)
        }

        
        
    }
    
}
