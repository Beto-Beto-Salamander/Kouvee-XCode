//
//  Pemesanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Pemesanan : NSObject{
    var indeks:String;
    var id_pemesanan:String;
    var id_supplier:String;
    var nama_supplier:String;
    var alamat_supplier:String;
    var phone_supplier:String;
    var tanggal_pemesanan:String;
    var status_pemesanan:String;
    var total:String;
    
    
    init(json: [String:Any]) {
        self.indeks = json["INDEKS"] as? String ?? ""
        self.id_pemesanan = json["ID_PEMESANAN"] as? String ?? ""
        self.id_supplier = json["ID_SUPPLIER"] as? String ?? ""
        self.nama_supplier = json["NAMA_SUPPLIER"] as? String ?? ""
        self.alamat_supplier = json["ALAMAT_SUPPLIER"] as? String ?? ""
        self.phone_supplier = json["PHONE_SUPPLIER"] as? String ?? ""
        self.tanggal_pemesanan = json["TANGGAL_PEMESANAN"] as? String ?? ""
        self.status_pemesanan = json["STATUS_PEMESANAN"] as? String ?? ""
        self.total = json["TOTAL"] as? String ?? ""
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
