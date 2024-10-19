//
//  DetayVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit
import Kingfisher

class DetayVC: UIViewController {
    
    var imageViewDetay = UIImageView()
    var labelFiyat = UILabel()
    var labelAd = UILabel()
    var stepperAdet = UIStepper()
    var adetLabel = UILabel()
    var buttonSepeteEkle = UIButton()
    
    var urun: Urunler?
    
    var viewModel = DetayViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        imageViewDetay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewDetay)
        
        labelFiyat.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelFiyat)
        
        labelAd.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelAd)
        
        stepperAdet.minimumValue = 1
        stepperAdet.value = 1
        stepperAdet.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepperAdet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stepperAdet)
        
        adetLabel.text = "Adet: 1"
        adetLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adetLabel)
        
        buttonSepeteEkle.setTitle("Sepete Ekle", for: .normal)
        buttonSepeteEkle.backgroundColor = .systemBlue
        buttonSepeteEkle.layer.cornerRadius = 10
        buttonSepeteEkle.addTarget(self, action: #selector(sepeteEkle), for: .touchUpInside)
        buttonSepeteEkle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSepeteEkle)
        
        NSLayoutConstraint.activate([
            imageViewDetay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageViewDetay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewDetay.widthAnchor.constraint(equalToConstant: 200),
            imageViewDetay.heightAnchor.constraint(equalToConstant: 200),
            
            labelAd.topAnchor.constraint(equalTo: imageViewDetay.bottomAnchor, constant: 20),
            labelAd.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            labelFiyat.topAnchor.constraint(equalTo: labelAd.bottomAnchor, constant: 10),
            labelFiyat.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stepperAdet.topAnchor.constraint(equalTo: labelFiyat.bottomAnchor, constant: 20),
            stepperAdet.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            adetLabel.topAnchor.constraint(equalTo: stepperAdet.bottomAnchor, constant: 10),
            adetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonSepeteEkle.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonSepeteEkle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSepeteEkle.widthAnchor.constraint(equalToConstant: 150),
            buttonSepeteEkle.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        configureProductDetails()
    }
    
    private func configureProductDetails() {
        guard let urun = urun else {
            print("Ürün bilgileri mevcut değil.")
            return
        }
        
        let baseUrl = "http://kasimadalan.pe.hu/urunler/resimler/"
        let imageUrlString = "\(baseUrl)\(urun.resim)"
        if let imageUrl = URL(string: imageUrlString) {
            imageViewDetay.kf.setImage(with: imageUrl)
        }
        labelAd.text = urun.ad
        labelFiyat.text = "\(urun.fiyat) ₺"
    }
    
    @objc func stepperValueChanged() {
        adetLabel.text = "Adet: \(Int(stepperAdet.value))"
    }
    
    @objc func sepeteEkle() {
        guard let urun = urun else {
            print("Sepete ekleme başarısız: Ürün mevcut değil.")
            return
        }
        
        let adet = Int(stepperAdet.value)
        print("Sepete eklendi: \(labelAd.text ?? "") - Adet: \(adet)")
        
        viewModel.sepeteEkle(ad: urun.ad, resim: urun.resim, kategori: urun.kategori, fiyat: urun.fiyat, marka: urun.marka, siparisAdeti: adet)
    }
}
