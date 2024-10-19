//
//  HomeCVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit


class HomeCVC: UICollectionViewCell {
    
    static let reuseID = "HomeCVC"
    
    var imageView = UIImageView()
    var labelName = UILabel()
    var labelFiyat = UILabel()
    var favoriButton = UIButton()
    var isFavori: Bool = false
    var urunId: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(labelName)
        addSubview(labelFiyat)
        addSubview(favoriButton)
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelFiyat.translatesAutoresizingMaskIntoConstraints = false
        favoriButton.translatesAutoresizingMaskIntoConstraints = false
        

        favoriButton.setImage(UIImage(systemName: "heart"), for: .normal)

        favoriButton.addTarget(self, action: #selector(favoriEkle), for: .touchUpInside)

        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            labelName.heightAnchor.constraint(equalToConstant: 20),
            
            labelFiyat.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelFiyat.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            labelFiyat.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            labelFiyat.heightAnchor.constraint(equalToConstant: 20),
            
            // Kalp butonunu yerleştirme
            favoriButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriButton.widthAnchor.constraint(equalToConstant: 30),
            favoriButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func favoriEkle() {
        isFavori.toggle()
        
        if isFavori {
            favoriButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        if isFavori {
            print("Favorilere eklendi: \(labelName.text ?? "")")
        } else {
            print("Favorilerden çıkarıldı: \(labelName.text ?? "")")
        }
    }
    
}
