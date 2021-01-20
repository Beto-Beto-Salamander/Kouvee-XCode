//
//  DetailTransaksiLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 30/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class DetilTransaksiLayanan : NSObject{
    var id_transaksi_layanan:String;
    var id_detiltransaksi_layanan:String;
    var id_layanan:String;
    var id_ukuran:String;
    var id_jenishewan:String;
    var ukuran:String;
    var jenishewan:String;
    var jumlah_detil_layanan:String;
    var nama_layanan:String;
    var harga_layanan:String;
    var sub_total_layanan:String;
    
    init(json: [String:Any]) {
        self.id_detiltransaksi_layanan = json["ID_DETILTRANSAKSI_LAYANAN"] as? String ?? ""
        self.id_transaksi_layanan = json["ID_TRANSAKSI_LAYANAN"] as? String ?? ""
        self.id_layanan = json["ID_LAYANAN"] as? String ?? ""
        self.id_ukuran = json["ID_UKURAN"] as? String ?? ""
        self.id_jenishewan = json["ID_JENISHEWAN"] as? String ?? ""
        self.nama_layanan = json["NAMA_LAYANAN"] as? String ?? ""
        self.ukuran = json["UKURAN"] as? String ?? ""
        self.jenishewan = json["JENISHEWAN"] as? String ?? ""
        self.jumlah_detil_layanan = json["JUMLAH_DETIL_LAYANAN"] as? String ?? ""
        self.harga_layanan = json["HARGA_LAYANAN"] as? String ?? ""
        self.sub_total_layanan = json["SUB_TOTAL_LAYANAN"] as? String ?? ""
        
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
