//
//  Layanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Layanan : NSObject{
    var id_layanan:String;
    var id_jenishewan:String;
    var id_ukuran:String;
    var nama_pegawai:String;
    var nama_layanan:String;
    var jenis_hewan:String;
    var ukuran:String
    var harga_layanan:String;
    var create_at_layanan:String;
    var update_at_layanan:String;
    var delete_at_layanan:String;
    
    init(json: [String:Any]) {
        self.id_layanan = json["ID_LAYANAN"] as? String ?? ""
        self.id_jenishewan = json["ID_JENISHEWAN"] as? String ?? ""
        self.id_ukuran = json["ID_UKURAN"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.nama_layanan = json["NAMA_LAYANAN"] as? String ?? ""
        self.jenis_hewan = json["JENISHEWAN"] as? String ?? ""
        self.ukuran = json["UKURAN"] as? String ?? ""
        self.harga_layanan = json["HARGA_LAYANAN"] as? String ?? ""
        self.create_at_layanan = json["CREATE_AT_LAYANAN"] as? String ?? ""
        self.update_at_layanan = json["UPDATE_AT_LAYANAN"] as? String ?? ""
        self.delete_at_layanan = json["DELETE_AT_LAYANAN"] as? String ?? ""
        
        }
    /*init(id_layanan: String, nama_pegawai: String, jenis_hewan: String, ukuran: String, nama_layanan: String, harga_layanan: String, create_at_layanan: String, update_at_layanan: String, delete_at_layanan: String) {
        self.id_layanan = id_layanan;
        self.nama_pegawai = nama_pegawai;
        self.nama_layanan = nama_layanan;
        self.jenis_hewan = jenis_hewan;
        self.ukuran = ukuran;
        self.harga_layanan = harga_layanan;
        self.create_at_layanan = create_at_layanan;
        self.update_at_layanan = update_at_layanan;
        self.delete_at_layanan = delete_at_layanan;
    }*/
    
    func printData(){
        print(
            "id_layanan       : ",self.id_layanan,
            "nama_pegawai     : ",self.nama_pegawai,
            "nama_layanan     : ",self.nama_layanan,
            "jenis_hewan      : ",self.jenis_hewan,
            "ukuran           : ",self.ukuran,
            "harga_layanan    : ",self.harga_layanan,
            "create_at_produk : ",self.create_at_layanan,
            "update_at_produk : ",self.update_at_layanan,
            "delete_at_produk : ",self.delete_at_layanan
        )
    }
}
