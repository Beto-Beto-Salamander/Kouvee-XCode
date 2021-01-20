//
//  Produk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Produk : NSObject{
    var id_produk:String;
    var nama_pegawai:String;
    var nama_produk:String;
    var stock:String;
    var min_stock:String;
    var satuan_produk:String;
    var harga_beli:String;
    var harga_jual:String;
    var gambar:String;
    var create_at_produk:String;
    var update_at_produk:String;
    var delete_at_produk:String;
    
    init(json: [String:Any]) {
        self.id_produk = json["ID_PRODUK"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.nama_produk = json["NAMA_PRODUK"] as? String ?? ""
        self.stock = json["STOCK"] as? String ?? ""
        self.min_stock = json["MIN_STOCK"] as? String ?? ""
        self.satuan_produk = json["SATUAN_PRODUK"] as? String ?? ""
        self.harga_beli = json["HARGA_BELI"] as? String ?? ""
        self.harga_jual = json["HARGA_JUAL"] as? String ?? ""
        self.gambar = json["GAMBAR"] as? String ?? ""
        self.create_at_produk = json["CREATE_AT_PRODUK"] as? String ?? ""
        self.update_at_produk = json["UPDATE_AT_PRODUK"] as? String ?? ""
        self.delete_at_produk = json["DELETE_AT_PRODUK"] as? String ?? ""
        
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
    
    func printData(){
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
    }
}
