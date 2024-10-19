//
//  UrunlerSepeti.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import Foundation

struct UrunlerSepeti: Codable {
    var sepetId: Int
    var ad: String
    var resim: String
    var kategori: String
    var fiyat: Int
    var marka: String
    var siparisAdeti: Int
    var kullaniciAdi: String
}

