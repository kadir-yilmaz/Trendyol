//
//  CustomAlerts.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 19.10.2024.
//

import UIKit

class CustomAlerts {
    
    static let shared = CustomAlerts()
    private init() {}
    
    func basicAlert(on viewController: UIViewController, titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func customAlert(on viewController: UIViewController, titleInput: String, messageInput: String, confirmHandler: @escaping () -> Void) {
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                confirmHandler()
            }
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            viewController.present(alert, animated: true, completion: nil)
    }
    
    func alertWithTextField(on viewController: UIViewController, titleInput: String, messageInput: String, confirmHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Name"
        }
        
        let iptalAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        
        let kaydetAction = UIAlertAction(title: "Save", style: .destructive) { action in
            
            if let alinanVeri = alertController.textFields?.first?.text {
                confirmHandler(alinanVeri)
            }
        }
        
        alertController.addAction(iptalAction)
        alertController.addAction(kaydetAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    

    
}
