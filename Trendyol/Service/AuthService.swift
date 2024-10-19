//
//  AuthService.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 19.10.2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthService {
    
    static let shared = AuthService()
    private init() {}
    
    func signInWithEmail(viewController: UIViewController, email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Error", messageInput: error.localizedDescription)
                completion(false)
                return
            }
            
            if UrunlerService.shared.currentUser?.isEmailVerified == true {
                completion(true)
            } else {
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Error", messageInput: "Önce email doğrula.")
            }
            
        }
    }
    
    func signInWithGoogle(viewController: UIViewController, completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                print("Google Sign-In Error: \(error!.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Google Sign-In Error: Kullanıcı veya idToken bulunamadı")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }
                
                completion()
                
            }
        }
    }
    
    func signUp(viewController: UIViewController, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Error", messageInput: error.localizedDescription)
                return
            }
            
            authResult?.user.sendEmailVerification { error in
                if let error = error {
                    CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Error", messageInput: error.localizedDescription)
                    return
                }
                
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Success", messageInput: "Email sent.")
            }
        }
    }
    
    
    func forgotPassword(email: String, on viewController: UIViewController) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Hata", messageInput: error.localizedDescription)
            } else {
                CustomAlerts.shared.basicAlert(on: viewController, titleInput: "Başarılı", messageInput: "Şifre sıfırlama e-postası gönderildi.")
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Çıkış yapılamadı")
        }
    }
    
    
}
