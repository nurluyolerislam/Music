//
//  RegisterVC.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import UIKit
import FirebaseAuth

final class RegisterVC: UIViewController {
    // MARK: - Properties
    private let HeadLabel            = TitleLabel(textAlignment: .left, fontSize: 20)
    private lazy var userNameTextField    = CustomTextField(fieldType: .username)
    private lazy var emailTextField       = CustomTextField(fieldType: .email)
    private lazy var passwordTextField    = CustomTextField(fieldType: .password)
    private lazy var repasswordTextField  = CustomTextField(fieldType: .password)
    private lazy var signUpButton         = MusicButton( bgColor: .authButtonBackground ,color: .authButtonBackground, title: "Sign Up", fontSize: .big)
    private let infoLabel            = SecondaryTitleLabel(fontSize: 16)
    private lazy var signInButton         = MusicButton( bgColor:.clear ,color: .label, title: "Sign In.", fontSize: .small)
    
    private lazy var stackView            = UIStackView()
    private let authViewModel = AuthViewModel()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureHeadLabel()
        configureTextField()
        configureSignUp()
        configureStackView()
    }
    
    // MARK: - UI Configuration
    func configureViewController() {
        view.backgroundColor = .systemBackground
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.addSubviewsExt(HeadLabel, userNameTextField, emailTextField, passwordTextField, repasswordTextField, signUpButton, signInButton, stackView)
    }
    
    private func configureHeadLabel() {
        HeadLabel.text = "Create an account"
        
        HeadLabel.anchor(top: view.topAnchor,
                         leading: view.leadingAnchor,
                         padding: .init(top: 80, leading: 20))
        
    }
    
    private func configureTextField() {
        userNameTextField.anchor(top: HeadLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 40, leading: 20, trailing: 20),
                              size: .init(heightSize: 50))
        
        
        emailTextField.anchor(top: userNameTextField.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 20, leading: 20, trailing: 20),
                              size: .init(heightSize: 50))
        

        
        passwordTextField.anchor(top: emailTextField.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 20, leading: 20, trailing: 20),
                              size: .init(heightSize: 50))
        
        
        repasswordTextField.placeholder = "Repassword"
           
        repasswordTextField.anchor(top: passwordTextField.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 20, leading: 20, trailing: 20),
                              size: .init(heightSize: 50))
        

    }
    
    private func configureSignUp(){
        signUpButton.configuration?.cornerStyle = .capsule

        signUpButton.anchor(top: repasswordTextField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 20, leading: 20, trailing: 20),
                            size: .init(width: 0, height: 50))
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
       
    }
    
  

    private func configureStackView() {
        stackView.axis          = .horizontal
        
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(signInButton)
        
        infoLabel.text = "Already have an account?"

        stackView.anchor(top: signUpButton.bottomAnchor,
                         padding: .init(top: 5))
        
        stackView.centerXInSuperview()
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    // MARK: - Action
    @objc private func didTapSignUp() {
       
        //Email & Password Validation
        guard let userName = userNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let rePassword = repasswordTextField.text else{
            presentAlert(title: "Alert!", message: "Username, email, password, rePassword ?", buttonTitle: "Ok")
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
            
            guard password == rePassword else {
                presentAlert(title: "Alert!", message: "Password and password repeat are not the same", buttonTitle: "Ok")
                return
            }
    
        return
        }
        
        authViewModel.register(userName: userName,
                         email: email,
                         password: password) { [weak self] in
            guard let self else { return }
            presentAlert(title: "Alert!", message: "Registration Successful 🥳", buttonTitle: "Ok")
            let mainTabBar = MainTabBarVC()
            self.view.window?.rootViewController = mainTabBar
        }
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
