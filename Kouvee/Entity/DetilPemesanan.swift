//
//  DetilPemesanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class DetilPemesanan : NSObject{
    var id_pemesanan:String;
    var id_detil_pemesanan:String;
    var id_produk:String;
    var satuan:String;
    var nama_produk:String;
    var harga_beli:String;
    var jumlah_pesanan:String;
    var sub_total_pemesanan:String;
    var datang:String;
    
    init(json: [String:Any]) {
        self.id_pemesanan = json["ID_PEMESANAN"] as? String ?? ""
        self.id_detil_pemesanan = json["ID_DETIL_PEMESANAN"] as? String ?? ""
        self.id_produk = json["ID_PRODUK"] as? String ?? ""
        self.satuan = json["SATUAN_PRODUK"] as? String ?? ""
        self.nama_produk = json["NAMA_PRODUK"] as? String ?? ""
        self.harga_beli = json["HARGA_BELI"] as? String ?? ""
        self.jumlah_pesanan = json["JUMLAH_PESANAN"] as? String ?? ""
        self.sub_total_pemesanan = json["SUB_TOTAL_PEMESANAN"] as? String ?? ""
        self.datang = json["DATANG"] as? String ?? ""
        }
    /*init(id_pegawai: String, nama_produk: String, stock: String, min_stock: String, satuan_produk: String, harga_beli: String, harga_jual: String, gambar: String, create_at_produk: String, update_at_produk: String, delete_at_produk: String) {
        self.id_pegawai = id_pegawai;
        self.nama_produk = nama_produk;
        self.stock = stock;
        self.min_stock = min_stock;
        self.satuan_produk = satuan_produk;
        self.harga_beli = harga_beli;
        self.harga_jual = harga_jual;
        self.gambar = gambar;
        self.create_at_produk = create_at_produk;
        self.update_at_produk = update_at_produk;
        self.delete_at_produk = delete_at_produk;
    }*/
    
    /*func printData(){
        print(
            "id_produk        : ",self.id_produk,
            "nama_pegawai     : ",self.nama_pegawai,
            "nama_produk      : ",self.nama_produk,
            "stock            : ",self.stock,
            "min_stock        : ",self.min_stock,
            "satuan_produk    : ",self.satuan_produk,
            "harga_beli       : ",self.harga_beli,
            "harga_jual       : ",self.harga_jual,
            "gambar           : ",self.gambar,
            "create_at_produk : ",self.create_at_produk,
            "update_at_produk : ",self.update_at_produk,
            "delete_at_produk : ",self.delete_at_produk
        )
    }*/
}
