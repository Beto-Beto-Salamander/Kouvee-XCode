//
//  DetilTransaksiProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 28/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class DetilTransaksiProduk : NSObject{
    var id_transaksi_produk:String;
    var id_detil_transaksi:String;
    var id_produk:String;
    var jumlah_produk:String;
    var nama_produk:String;
    var harga_jual:String;
    var sub_total_produk:String;
    
    init(json: [String:Any]) {
        self.id_detil_transaksi = json["ID_DETIL_TRANSAKSI"] as? String ?? ""
        self.id_transaksi_produk = json["ID_TRANSAKSI_PRODUK"] as? String ?? ""
        self.id_produk = json["ID_PRODUK"] as? String ?? ""
        self.nama_produk = json["NAMA_PRODUK"] as? String ?? ""
        self.jumlah_produk = json["JUMLAH_PRODUK"] as? String ?? ""
        self.harga_jual = json["HARGA_JUAL"] as? String ?? ""
        self.sub_total_produk = json["SUB_TOTAL_PRODUK"] as? String ?? ""
        
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
