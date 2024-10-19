//
//  LoginVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 19.10.2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginVC: UIViewController {
    
    let viewModel = LoginViewModel()
    
    let logoImageView = UIImageView()
    let emailTextField = TrendTextField(placeholder: "Email")
    let passwordTextField = TrendTextField(placeholder: "Password")
    let googleSignInButton = TrendButton(backgroundColor: .systemBlue, title: "Sign in with Google")
    let signInButton = TrendButton(backgroundColor: .systemGreen, title: "Login")
    let signUpButton = TrendButton(backgroundColor: .systemPink, title: "SignUp")
    let forgotPasswordButton = TrendButton(backgroundColor: .systemGray, title: "Forgot password?")
    var buttonStackView = UIStackView()
    var textFieldStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(googleSignInButton)
        view.addSubview(forgotPasswordButton)
        
        buttonStackView = UIStackView(arrangedSubviews: [signUpButton, forgotPasswordButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        view.addSubview(buttonStackView)
        
        textFieldStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 10
        view.addSubview(textFieldStackView)
        
        configureLogoImageView()
        configureSignInButton()
        createDismissKeyboardTapGesture()
        configureButtonStackView(stackView: buttonStackView)
        configureGoogleSignInButton()
        configureTextFieldStackView(stackView: textFieldStackView)
        
        // ViewModel için closure tanımları
        viewModel.onLoginSuccess = { [weak self] in
            self?.transitionToHomeScreen()
        }
        viewModel.onLoginFailure = { [weak self] message in
            CustomAlerts.shared.basicAlert(on: self!, titleInput: "Hata", messageInput: message)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureButtonStackView(stackView: UIStackView) {
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureTextFieldStackView(stackView: UIStackView) {
                
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "Trendyol")
        
        let logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureSignInButton() {
        signInButton.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: googleSignInButton.topAnchor, constant: -25),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureGoogleSignInButton() {
        googleSignInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            googleSignInButton.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -25),
            googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            googleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func forgotPassword() {
        let alertController = UIAlertController(title: "Reset Password", message: "Please enter email.", preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Email"
        }
        
        let iptalAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let kaydetAction = UIAlertAction(title: "Send", style: .destructive) { [weak self] _ in
            if let alinanVeri = alertController.textFields?.first?.text {
                self?.viewModel.forgotPassword(viewController: self!, email: alinanVeri)
            }
        }
        
        alertController.addAction(iptalAction)
        alertController.addAction(kaydetAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func signUp() {
        viewModel.signUp(viewController: self, email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @objc func signInWithGoogle() {
        viewModel.signInWithGoogle(viewController: self)
    }
    
    @objc func signInWithEmail() {
        guard viewModel.validateInput(email: emailTextField.text, password: passwordTextField.text) else {
            CustomAlerts.shared.basicAlert(on: self, titleInput: "Hata", messageInput: "Email ve şifre boş olamaz.")
            return
        }
        
        viewModel.signInWithEmail(viewController: self, email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    func transitionToHomeScreen() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }

        UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let navigationController = self.createTabBarController()
            navigationController.setNavigationBarHidden(true, animated: false)
            sceneDelegate.window?.rootViewController = navigationController
        }, completion: nil)
    }
    
    func createTabBarController() -> UINavigationController {
        let tabBar = TrendTabBarController()
        let navigationController = UINavigationController(rootViewController: tabBar)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}

extension LoginVC: UITextFieldDelegate {
}
