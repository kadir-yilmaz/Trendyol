//
//  ProfilVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit

class ProfilVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        let logoutBarButtonItem = UIBarButtonItem(customView: logoutButton)

        navigationItem.rightBarButtonItem = logoutBarButtonItem

    }
    
    @objc func logoutButtonTapped() {
        CustomAlerts.shared.customAlert(on: self, titleInput: "Çıkış Yap", messageInput: "Hesabınızdan çıkış yapılacak.") {
            
            AuthService.shared.logout()
            UrunlerService.shared.resetSepet()
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            
            UIView.transition(with: sceneDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                sceneDelegate.window?.rootViewController = LoginVC()
            }, completion: nil)
        }
    }

}
