//
//  DetayViewModel.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 16.10.2024.
//

import Foundation

class DetayViewModel {
    
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int) {
        UrunlerService.shared.sepeteEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, siparisAdeti: siparisAdeti)
    }
}
