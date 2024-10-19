//
//  UrunlerService.swift
//  Trendyol
//
//  Created by Kadir Yılmaz on 13.10.2024.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseAuth

class UrunlerService {
    
    static let shared = UrunlerService()
    private init() {}
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var urunler = BehaviorSubject<[Urunler]>(value: [Urunler]())
    var sepettekiler = BehaviorSubject<[UrunlerSepeti]>(value: [UrunlerSepeti]())

    
    func urunleriYukle(){
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php"
        
        AF.request(url,method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    if let liste = cevap.urunler {
                        self.urunler.onNext(liste) //Tetikleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func sepeteEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, siparisAdeti: Int) {
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        let params: Parameters = [
            "ad": ad,
            "resim": resim,
            "kategori": kategori,
            "fiyat": fiyat,
            "marka": marka,
            "siparisAdeti": siparisAdeti,
            "kullaniciAdi": userId!
        ]
        
        AF.request(url, method: .post, parameters: params).response { response in
            switch response.result {
            case .success(_):
                do {
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: response.data!)
                    print("Başarılı cevap: \(cevap)")
                } catch {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
            }
        }
    }
     
    func sil(sepetId: Int) {
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php"
        let params: Parameters = [
            "sepetId": sepetId,
            "kullaniciAdi": userId!
        ]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(UrunlerCevap.self, from: data)
                    print("Başarı : \(cevap.success!)")
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepettekileriGetir() {
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php"
        
        let params: Parameters = ["kullaniciAdi": userId!]
        
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                    if let liste = cevap.urunler_sepeti {
                        print(liste)
                        self.sepettekiler.onNext(liste) //Tetikleme
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func resetSepet() {
        self.sepettekiler.onNext([])
    }
    

    
}
