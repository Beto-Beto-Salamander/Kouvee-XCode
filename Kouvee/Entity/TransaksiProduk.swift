//
//  TransaksiProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class TransaksiProduk : NSObject{
    var indeks:String;
    var id_transaksi_produk:String;
    var id_pelanggan:String;
    var nama_pelanggan:String;
    var id_pegawai:String;
    var nama_cs:String;
    var id_hewan:String;
    var nama_hewan:String;
    var jenis_hewan:String;
    var peg_id_pegawai:String;
    var nama_kasir:String;
    var status_transaksi_produk:String;
    var tgl_transaksi:String;
    var subtotal_transaksi_produk:String;
    var total_transaksi_produk:String;
    var diskon_produk:String;
    
    init(json: [String:Any]) {
        self.indeks = json["INDEKS"] as? String ?? ""
        self.id_transaksi_produk = json["ID_TRANSAKSI_PRODUK"] as? String ?? ""
        self.id_pelanggan = json["ID_PELANGGAN"] as? String ?? ""
        self.nama_pelanggan = json["NAMA_PELANGGAN"] as? String ?? ""
        self.id_pegawai = json["ID_PEGAWAI"] as? String ?? ""
        self.nama_cs = json["NAMA_CS"] as? String ?? ""
        self.id_hewan = json["ID_HEWAN"] as? String ?? ""
        self.nama_hewan = json["NAMA_HEWAN"] as? String ?? ""
        self.jenis_hewan = json["JENISHEWAN"] as? String ?? ""
        self.peg_id_pegawai = json["PEG_ID_PEGAWAI"] as? String ?? ""
        self.nama_kasir = json["NAMA_KASIR"] as? String ?? ""
        self.status_transaksi_produk = json["STATUS_TRANSAKSI_PRODUK"] as? String ?? ""
        self.tgl_transaksi = json["TGL_TRANSAKSI"] as? String ?? ""
        self.subtotal_transaksi_produk = json["SUBTOTAL_TRANSAKSI_PRODUK"] as? String ?? ""
        self.total_transaksi_produk = json["TOTAL_TRANSAKSI_PRODUK"] as? String ?? ""
        self.diskon_produk = json["DISKON_PRODUK"] as? String ?? ""
        
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
