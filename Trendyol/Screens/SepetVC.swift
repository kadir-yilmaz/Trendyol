//
//  SepetVC.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import UIKit
import Kingfisher

class SepetVC: UIViewController {
    var tableView = UITableView()
    var labelToplamFiyat = UILabel()
    var buttonOnayla = UIButton()
    
    var sepettekiler = [UrunlerSepeti]()
    var viewModel = SepetViewModel()

    var toplamFiyat: Int {
        return sepettekiler.reduce(0) { $0 + ($1.fiyat * $1.siparisAdeti) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTableView()
        configureBottomView()

        _ = viewModel.sepettekiler.subscribe(onNext: { liste in
            self.sepettekiler = liste
            self.updateTotalPrice()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        updateTotalPrice()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.sepettekileriGetir()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SepetTVC.self, forCellReuseIdentifier: SepetTVC.reuseID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }

    func configureBottomView() {
        let bottomView = UIView()
        bottomView.backgroundColor = .lightGray
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(labelToplamFiyat)
        labelToplamFiyat.text = "Toplam: \(toplamFiyat)₺"
        labelToplamFiyat.font = UIFont.boldSystemFont(ofSize: 18)
        labelToplamFiyat.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(buttonOnayla)
        buttonOnayla.setTitle("Sepeti Onayla", for: .normal)
        buttonOnayla.backgroundColor = .systemGreen
        buttonOnayla.layer.cornerRadius = 10
        buttonOnayla.translatesAutoresizingMaskIntoConstraints = false
        buttonOnayla.addTarget(self, action: #selector(sepetiOnayla), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            labelToplamFiyat.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            labelToplamFiyat.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            buttonOnayla.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            buttonOnayla.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            buttonOnayla.widthAnchor.constraint(equalToConstant: 150),
            buttonOnayla.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func sepetiOnayla() {
        let alert = UIAlertController(title: "Onay", message: "Sepet onaylandı. Toplam: \(toplamFiyat)₺", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateTotalPrice() {
        labelToplamFiyat.text = "Toplam: \(toplamFiyat)₺"
    }
}

extension SepetVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepettekiler.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: SepetTVC.reuseID, for: indexPath) as! SepetTVC
        let urun = sepettekiler[indexPath.row]

        hucre.labelName.text = urun.ad
        hucre.labelFiyat.text = "Fiyat: \(urun.fiyat)₺"
        hucre.labelAdet.text = "Adet: \(urun.siparisAdeti)"
        hucre.labelToplamFiyat.text = "Toplam: \(urun.fiyat * urun.siparisAdeti)₺"

        let baseUrl = "http://kasimadalan.pe.hu/urunler/resimler/"
        let imageUrlString = "\(baseUrl)\(urun.resim)"
        if let imageUrl = URL(string: imageUrlString) {
            hucre.imageViewSepet.kf.setImage(with: imageUrl)
        }

        hucre.urunSilAction = { [weak self] in
            self!.viewModel.sil(sepetId: urun.sepetId)
            self?.sepettekiler.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.updateTotalPrice()
        }

        return hucre
    }
}
