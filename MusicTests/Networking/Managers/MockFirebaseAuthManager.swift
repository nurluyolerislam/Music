//
//  MockFirebaseAuthManager.swift
//  MusicTests
//
//  Created by Yaşar Duman on 12.12.2023.
//

@testable import Music
import FirebaseAuth

final class MockFirebaseAuthManager: FirebaseAuthManagerProtocol{
    var invokedSignIn = false
    var invokedSignInCount = 0
    var invokedSignInParameters: (email: String, password: String)?
    var invokedSignInParametersList = [(email: String, password: String)]()
    func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        invokedSignIn = true
        invokedSignInCount += 1
        invokedSignInParameters = (email: email, password: password)
        invokedSignInParametersList.append((email: email, password: password))
        onSuccess()
    }
    
    var invokedRegister = false
    var invokedRegisterCount = 0
    var invokedRegisterParameters: (userName: String, email: String, password: String)?
    var invokedRegisterParametersList = [(userName: String, email: String, password: String)]()
    func register(userName: String, email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        invokedRegister = true
        invokedRegisterCount += 1
        invokedRegisterParameters = (userName: userName, email: email, password: password)
        invokedRegisterParametersList.append((userName: userName, email: email, password: password))
        onSuccess()
    }
    
    var invokedSignInWithCredential = false
    var invokedSignInWithCredentialCount = 0
    var invokedSignInWithCredentialParameters: (credential: AuthCredential, username: String)?
    var invokedSignInWithCredentialParametersList = [(credential: AuthCredential, username: String)]()
    func signInWithCredential(credential: AuthCredential, username: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        invokedSignInWithCredential = true
        invokedSignInWithCredentialCount += 1
        invokedSignInWithCredentialParameters = (credential: credential, username: username)
        invokedSignInWithCredentialParametersList.append((credential: credential, username: username))
        onSuccess()
    }
    
    var invokedSignOut = false
    var invokedSignOutCount = 0
    func signOut(onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        invokedSignOut = true
        invokedSignOutCount += 1
        onSuccess()
    }
    
    var invokedResetPassword = false
    var invokedResetPasswordCount = 0
    var invokedResetPasswordParameters: (email: String, Void)?
    var invokedResetPasswordParametersList = [(email: String, Void)]()
    func resetPassword(email: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void) {
        invokedResetPassword = true
        invokedResetPasswordCount += 1
        invokedResetPasswordParameters = (email: email, ())
        invokedResetPasswordParametersList.append((email: email, ()))
        onSuccess()
    }
}
