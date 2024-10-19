//
//  SepetTVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 16.10.2024.
//

import UIKit

class SepetTVC: UITableViewCell {

    static let reuseID = "SepetTVC"
    
    var imageViewSepet = UIImageView()
    var labelName = UILabel()
    var labelFiyat = UILabel()
    var labelAdet = UILabel()
    var labelToplamFiyat = UILabel()
    var silButonu = UIButton()
    var urunSilAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(imageViewSepet)
        contentView.addSubview(labelName)
        contentView.addSubview(labelFiyat)
        contentView.addSubview(labelAdet)
        contentView.addSubview(labelToplamFiyat)
        contentView.addSubview(silButonu)
        
        // Enabling auto layout
        imageViewSepet.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelFiyat.translatesAutoresizingMaskIntoConstraints = false
        labelAdet.translatesAutoresizingMaskIntoConstraints = false
        labelToplamFiyat.translatesAutoresizingMaskIntoConstraints = false
        silButonu.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewSepet.contentMode = .scaleAspectFit
        imageViewSepet.clipsToBounds = true
        imageViewSepet.layer.cornerRadius = 8
        
        labelName.font = UIFont.boldSystemFont(ofSize: 16)
        labelFiyat.font = UIFont.systemFont(ofSize: 14)
        labelFiyat.textColor = .gray
        labelAdet.font = UIFont.systemFont(ofSize: 14)
        labelAdet.textColor = .gray
        labelToplamFiyat.font = UIFont.boldSystemFont(ofSize: 16)
        labelToplamFiyat.textColor = .systemGreen
        
        silButonu.setTitle("Sil", for: .normal)
        silButonu.setTitleColor(.red, for: .normal)
        silButonu.addTarget(self, action: #selector(silButonunaBasildi), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageViewSepet.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageViewSepet.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewSepet.widthAnchor.constraint(equalToConstant: 80),
            imageViewSepet.heightAnchor.constraint(equalToConstant: 80),
            
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelName.leadingAnchor.constraint(equalTo: imageViewSepet.trailingAnchor, constant: 12),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            labelFiyat.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelFiyat.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            labelAdet.topAnchor.constraint(equalTo: labelFiyat.bottomAnchor, constant: 4),
            labelAdet.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            labelToplamFiyat.topAnchor.constraint(equalTo: labelAdet.bottomAnchor, constant: 4),
            labelToplamFiyat.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            
            silButonu.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            silButonu.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        contentView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    @objc private func silButonunaBasildi() {
        let alert = UIAlertController(title: "Sil", message: "Ürünü silmek ister misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { [weak self] _ in
            self?.urunSilAction?()
        }))
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let topVC = window.rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
