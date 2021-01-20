//
//  Pelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Pelanggan : NSObject{
    var id_pelanggan:String;
    var nama_pegawai:String;
    var nama_pelanggan:String;
    var phone_pelanggan:String;
    var tgl_lahir_pelanggan:String;
    var alamat_pelanggan:String;
    var create_at_pelanggan:String;
    var update_at_pelanggan:String;
    var delete_at_pelanggan:String;
    
    init(json: [String:Any]) {
        self.id_pelanggan = json["ID_PELANGGAN"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.nama_pelanggan = json["NAMA_PELANGGAN"] as? String ?? ""
        self.phone_pelanggan = json["PHONE_PELANGGAN"] as? String ?? ""
        self.tgl_lahir_pelanggan = json["TGL_LAHIR_PELANGGAN"] as? String ?? ""
        self.alamat_pelanggan = json["ALAMAT_PELANGGAN"] as? String ?? ""
        self.create_at_pelanggan = json["CREATE_AT_PELANGGAN"] as? String ?? ""
        self.update_at_pelanggan = json["UPDATE_AT_PELANGGAN"] as? String ?? ""
        self.delete_at_pelanggan = json["DELETE_AT_PELANGGAN"] as? String ?? ""
        }
    
    init(id_pelanggan: String, nama_pegawai: String, nama_pelanggan: String, phone_pelanggan: String, tgl_lahir_pelanggan: String, alamat_pelanggan: String, create_at_pelanggan: String, update_at_pelanggan: String, delete_at_pelanggan: String) {
        self.id_pelanggan = id_pelanggan;
        self.nama_pegawai = nama_pegawai;
        self.nama_pelanggan = nama_pelanggan;
        self.phone_pelanggan = phone_pelanggan;
        self.tgl_lahir_pelanggan = tgl_lahir_pelanggan;
        self.alamat_pelanggan = alamat_pelanggan;
        self.create_at_pelanggan = create_at_pelanggan;
        self.update_at_pelanggan = update_at_pelanggan;
        self.delete_at_pelanggan = delete_at_pelanggan;
    }
    
    func printData(){
        print(
            "id_pelanggan            : ",self.id_pelanggan,
            "nama_pegawai            : ",self.nama_pelanggan,
            "nama_pelanggan          : ",self.nama_pelanggan,
            "phone_pelanggan         : ",self.phone_pelanggan,
            "tgl_lahir_pelanggan     : ",self.tgl_lahir_pelanggan,
            "alamat_pelanggan        : ",self.alamat_pelanggan,
            "create_at_pelanggan     : ",self.create_at_pelanggan,
            "update_at_pelanggan     : ",self.update_at_pelanggan,
            "delete_at_pelanggan     : ",self.delete_at_pelanggan
        )
    }
}
