//
//  TYTabBarController.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit

class TrendTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createHomeNC(), createFavorilerNC(), createSepetNC(), createProfilNC()]

    }
    
    func createHomeNC() -> UINavigationController {
        let homeVC = AnasayfaVC()
        homeVC.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 0)

        
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createSepetNC() -> UINavigationController {
        let sepetVC = SepetVC()
        sepetVC.tabBarItem = UITabBarItem(title: "Sepet", image: UIImage(systemName: "cart"), tag: 1)

        return UINavigationController(rootViewController: sepetVC)
    }
    
    func createFavorilerNC() -> UINavigationController {
        let favorilerVC = FavorilerVC()
        favorilerVC.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart"), tag: 2)

        return UINavigationController(rootViewController: favorilerVC)
    }
    
    func createProfilNC() -> UINavigationController {
        let profilVC = ProfilVC()
        profilVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)

        return UINavigationController(rootViewController: profilVC)
    }

}
