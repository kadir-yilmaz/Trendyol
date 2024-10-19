//
//  SepetViewModel.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 16.10.2024.
//

import Foundation
import RxSwift

class SepetViewModel {
    var sepettekiler = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())

    init(){
        sepettekileriGetir()
        sepettekiler = UrunlerService.shared.sepettekiler
    }
    
    func sepettekileriGetir() {
        UrunlerService.shared.sepettekileriGetir()
    }
    
    func sil(sepetId: Int) {
        UrunlerService.shared.sil(sepetId: sepetId)
    }
}
