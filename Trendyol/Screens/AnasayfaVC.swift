//
//  HomeVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit
import Kingfisher

class AnasayfaVC: UIViewController {
    
    var searchBar = UISearchBar()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    var urunler = [Urunler]()
    
    var viewModel = AnasayfaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Trendyol"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        _ = viewModel.urunler.subscribe(onNext: { liste in
            self.urunler = liste

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        configureSearchBar()
        configureCollectionView()
        
        UrunlerService.shared.sepettekileriGetir()
        
        configureNavigationItem()

    }
    
    private var fiyatSiralaAscending = true
    func configureNavigationItem() {
        let siralamaButton = UIButton(type: .custom)
        updateButtonImage(for: siralamaButton)
        siralamaButton.addTarget(self, action: #selector(fiyatSirala), for: .touchUpInside)

        let siralamaBarButtonItem = UIBarButtonItem(customView: siralamaButton)
        navigationItem.rightBarButtonItem = siralamaBarButtonItem
    }

    private func updateButtonImage(for button: UIButton) {
        let imageName = fiyatSiralaAscending ? "arrow.up" : "arrow.down"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc func fiyatSirala() {
        fiyatSiralaAscending.toggle()
        viewModel.fiyatSirala(ascending: fiyatSiralaAscending)
        if let button = navigationItem.rightBarButtonItem?.customView as? UIButton {
            updateButtonImage(for: button)
        }
    }
    
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .secondarySystemBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tasarim.minimumInteritemSpacing = 5
        tasarim.minimumLineSpacing = 5
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 20) / 2
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.5)
        
        tasarim.scrollDirection = .vertical
        collectionView.collectionViewLayout = tasarim
        
        collectionView.register(HomeCVC.self, forCellWithReuseIdentifier: HomeCVC.reuseID)
        
        // CollectionView constraint'leri
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

}

extension AnasayfaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.urunleriYukle()
        } else {
            viewModel.ara(aramaKelimesi: searchText)
        }
    }
}

extension AnasayfaVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urunler.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hucre = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVC.reuseID, for: indexPath) as! HomeCVC
        
        let urun = urunler[indexPath.row]
        
        let baseUrl = "http://kasimadalan.pe.hu/urunler/resimler/"
        let imageUrlString = "\(baseUrl)\(urun.resim)"
        
        if let imageUrl = URL(string: imageUrlString) {
            hucre.imageView.kf.setImage(with: imageUrl)
        }

        hucre.labelName.text = "\(urun.ad)"
        hucre.labelFiyat.text = "\(urun.fiyat) ₺"
        
        hucre.backgroundColor = .systemBackground
        hucre.layer.borderColor = UIColor.darkGray.cgColor
        hucre.layer.borderWidth = 0.3
        hucre.layer.cornerRadius = 10
        
        return hucre
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urun = urunler[indexPath.row]
        let detayVC = DetayVC()
        detayVC.urun = urun
        navigationController?.pushViewController(detayVC, animated: true)
        print("tıklandı \(urun.ad)")
    }
    
    
    
}
