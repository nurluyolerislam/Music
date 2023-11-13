//
//  AuthVM.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import FirebaseAuth
import FirebaseFirestore

class AuthVM{
    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Giriş başarılı.")
            }
        }
    }
    
    // MARK: - Register
    func register(userName: String, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let user = result?.user else {
                    print("registerdan donen kullanıcı yok")
                    return
                }
                let fireStore = Firestore.firestore()
                
                let userDictionaray = [
                    "userName" : userName
                ] as! [String : Any]
                
                fireStore.collection("UsersInfo")
                    .document(user.uid)
                    .setData(userDictionaray) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        completion(true,"Kayıt başarılı")
                    }
            }
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
    
}
