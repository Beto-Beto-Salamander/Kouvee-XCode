//
//  Hewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Hewan : NSObject{
    var id_hewan:String;
    var id_jenishewan:String;
    var id_pelanggan:String;
    var jenishewan:String;
    var nama_pegawai:String;
    var nama_hewan:String;
    var nama_pelanggan:String;
    var tgl_lahir_hewan:String;
    var create_at_hewan:String;
    var update_at_hewan:String;
    var delete_at_hewan:String;
    
    init(json: [String:Any]) {
        self.id_hewan = json["ID_HEWAN"] as? String ?? ""
        self.id_pelanggan = json["ID_PELANGGAN"] as? String ?? ""
        self.id_jenishewan = json["ID_JENISHEWAN"] as? String ?? ""
        self.jenishewan = json["JENISHEWAN"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.nama_pelanggan = json["NAMA_PELANGGAN"] as? String ?? ""
        self.nama_hewan = json["NAMA_HEWAN"] as? String ?? ""
        self.tgl_lahir_hewan = json["TGL_LAHIR_HEWAN"] as? String ?? ""
        self.create_at_hewan = json["CREATE_AT_HEWAN"] as? String ?? ""
        self.update_at_hewan = json["UPDATE_AT_HEWAN"] as? String ?? ""
        self.delete_at_hewan = json["DELETE_AT_HEWAN"] as? String ?? ""
        
        }
    /*init(id_jenishewan: String, id_pegawai: String, id_pelanggan: String, nama_hewan: String, tgl_lahir_hewan:String,  create_at_hewan: String, update_at_hewan: String, delete_at_hewan: String) {
        self.id_jenishewan = id_jenishewan;
        self.id_pegawai = id_pegawai;
        self.id_pelanggan = id_pelanggan;
        self.nama_hewan = nama_hewan;
        self.tgl_lahir_hewan = tgl_lahir_hewan;
        self.create_at_hewan = create_at_hewan;
        self.update_at_hewan = update_at_hewan;
        self.delete_at_hewan = delete_at_hewan;
    }*/
    
    func printData(){
        print(
            "id_hewan            : ",self.id_hewan,
            "nama_hewan          : ",self.nama_hewan,
            "nama_pegawai          : ",self.nama_pegawai,
            "nama_pelanggan        : ",self.nama_pelanggan,
            "tgl_lahir_hewan     : ",self.tgl_lahir_hewan,
            "create_at_hewan     : ",self.create_at_hewan,
            "update_at_hewan     : ",self.update_at_hewan,
            "delete_at_hewan     : ",self.delete_at_hewan
        )
    }
}
