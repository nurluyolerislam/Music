//
//  LoginVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

final class LoginVC: UIViewController {
    // MARK: - Properties
    private let HeadLabel                 = TitleLabel(textAlignment: .left, fontSize: 20)
    private lazy var emailTextField       = CustomTextField(fieldType: .email)
    private lazy var passwordTextField    = CustomTextField(fieldType: .password)
    private lazy var signInButton         = MusicButton( bgColor: .authButtonBackground ,color: .authButtonBackground , title: "Sign In", fontSize: .big)
    private lazy var goggleSignInButton         = MusicButton( bgColor: UIColor.systemBlue ,color: UIColor.systemBlue , title: "Google Sign In", fontSize: .big, systemImageName: "hand.point.up.braille")
    private let infoLabel            = SecondaryTitleLabel(fontSize: 16)
    private lazy var newUserButton        = MusicButton( bgColor:.clear ,color: .label, title: "Sign Up.", fontSize: .small)
    private lazy var forgotPasswordButton = MusicButton( bgColor:.clear ,color: .authButtonBackground , title: "Forgot password?", fontSize: .small)
    
    private lazy var stackView            = UIStackView()
    private let authViewModel = AuthViewModel()
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviewsExt(HeadLabel, emailTextField, passwordTextField, forgotPasswordButton, signInButton, goggleSignInButton,stackView)
        
        configureHeadLabel()
        configureTextField()
        configureForgotPassword()
        configureSignIn()
        configureStackView()
        
        
        
    }
    // MARK: - UI Configuration
    
    private func configureHeadLabel() {
        HeadLabel.text = "Let's sign you in"
        
        HeadLabel.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         //trailing: view.trailingAnchor,
                         padding: .init(top: 80, left: 20, bottom: 0, right: 0))
    }
    
    private func configureTextField() {
        emailTextField.anchor(top: HeadLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 40, left: 20, bottom: 0, right: 20),
                              size: .init(width: 0, height: 50))
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 padding: .init(top: 20, left: 20, bottom: 0, right: 20),
                                 size: .init(width: 0, height: 50))
    }
    
    private func configureForgotPassword(){
        forgotPasswordButton.tintColor = .systemPurple
        
        forgotPasswordButton.anchor(top: passwordTextField.bottomAnchor,
                                    trailing: passwordTextField.trailingAnchor,
                                    padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    private func configureSignIn(){
        signInButton.configuration?.cornerStyle = .capsule
        goggleSignInButton.configuration?.cornerStyle = .capsule
        
        signInButton.anchor(top: forgotPasswordButton.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 20, left: 20, bottom: 0, right: 20),
                            size: .init(width: 0, height: 50))
        
        
        goggleSignInButton.anchor(top: signInButton.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 20, left: 20, bottom: 0, right: 20),
                                  size: .init(width: 0, height: 50))
        
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        goggleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
    }
    
    
    
    private func configureStackView() {
        stackView.axis          = .horizontal
        
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(newUserButton)
        
        infoLabel.text = "Don't have an account?"
        
        
        stackView.anchor(top: goggleSignInButton.bottomAnchor,
                         padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        
        stackView.centerXInSuperview()
        
        newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
    }
    
    @objc private func didTapSignIn() {
        //Email & Password Validation
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else{
            presentAlert(title: "Alert!", message: "Email and Password ?", buttonTitle: "Ok")
            return
        }
        guard email.isValidEmail(email: email) else {
            presentAlert(title: "Alert!", message: "Email Invalid", buttonTitle: "Ok")
            return
        }
        
        guard password.isValidPassword(password: password) else {
            
            guard password.count >= 6 else {
                presentAlert(title: "Alert!", message: "Password must be at least 6 characters", buttonTitle: "Ok")
                return
            }
            
            guard password.containsDigits(password) else {
                presentAlert(title: "Alert!", message: "Password must contain at least 1 digit", buttonTitle: "Ok")
                return
            }
            
            guard password.containsLowerCase(password) else {
                presentAlert(title: "Alert!", message: "Password must contain at least 1 lowercase character", buttonTitle: "Ok")
                return
            }
            
            guard password.containsUpperCase(password) else {
                presentAlert(title: "Alert!", message: "Password must contain at least 1 uppercase character", buttonTitle: "Ok")
                return
            }
            
            return
        }
        
        authViewModel.login(email: email, password: password) { [weak self] in
            guard let self else { return }
            presentAlert(title: "Alert!", message: "Entry Successful 🥳", buttonTitle: "Ok")
            let mainTabBar = MainTabBarVC()
            self.view.window?.rootViewController = mainTabBar
        }
    }
    
    @objc private func didTapGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString,
                    let userName: String = user.profile?.name
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            authViewModel.signInGoogle(credential: credential,username: userName) {[weak self] in
                guard let self else { return }
                presentAlert(title: "Alert!", message: "Registration Successful 🥳", buttonTitle: "Ok")
                let mainTabBar = MainTabBarVC()
                self.view.window?.rootViewController = mainTabBar   
            }
        }
    }
        
    
    
    //MARK: - @Actions
    @objc private func didTapNewUser() {
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
