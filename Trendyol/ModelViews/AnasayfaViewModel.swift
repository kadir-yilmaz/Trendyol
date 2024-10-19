//
//  HomeViewModel.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import Foundation
import RxSwift


class AnasayfaViewModel {
    var urunler = BehaviorSubject<[Urunler]>(value: [Urunler]())
    private let disposeBag = DisposeBag()

    init() {
        urunleriYukle()
        urunler = UrunlerService.shared.urunler
    }

    func urunleriYukle() {
        UrunlerService.shared.urunleriYukle()
    }


    func ara(aramaKelimesi: String) {
        do {
            let tumUrunler = try urunler.value()
            let filtrelenmisUrunler = tumUrunler.filter { urun in
                urun.ad.lowercased().contains(aramaKelimesi.lowercased())
            }
            urunler.onNext(filtrelenmisUrunler)
        } catch {
            print("Ürünleri alırken bir hata oluştu: \(error)")
        }
    }
    

    func fiyatSirala(ascending: Bool) {
        do {
            let tumUrunler = try urunler.value()
            let siralanmisUrunler = tumUrunler.sorted { x, y in
                return ascending ? (x.fiyat < y.fiyat) : (x.fiyat > y.fiyat)
            }
            urunler.onNext(siralanmisUrunler)
        } catch {
            print("Ürünleri alırken bir hata oluştu: \(error)")
        }
    }
}
