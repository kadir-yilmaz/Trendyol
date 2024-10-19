//
//  LoginViewModel.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 19.10.2024.
//

import Foundation
import UIKit

class LoginViewModel {
    
    // Kullanıcı giriş durumunu belirlemek için bir closure
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func validateInput(email: String?, password: String?) -> Bool {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            return false
        }
        return true
    }
    
    func signInWithEmail(viewController: UIViewController, email: String, password: String) {
        AuthService.shared.signInWithEmail(viewController: viewController, email: email, password: password) { [weak self] success in
            if success {
                self?.onLoginSuccess?()
            } else {
                self?.onLoginFailure?("Giriş başarısız. Lütfen bilgilerinizi kontrol edin.")
            }
        }
    }
    
    func signInWithGoogle(viewController: UIViewController) {
        AuthService.shared.signInWithGoogle(viewController: viewController) { [weak self] in
            self?.onLoginSuccess?()
        }
    }
    
    func signUp(viewController: UIViewController, email: String, password: String) {
        AuthService.shared.signUp(viewController: viewController, email: email, password: password)
    }
    
    func forgotPassword(viewController: UIViewController, email: String) {
        AuthService.shared.forgotPassword(email: email, on: viewController)
    }
}
