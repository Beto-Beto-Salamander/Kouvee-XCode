//
//  Pegawai.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Pegawai : NSObject{
    var id_pegawai: String;
    var nama_pegawai:String;
    var tgl_lahir_pegawai:String;
    var phone_pegawai:String;
    var alamat_pegawai:String;
    var jabatan:String;
    var password:String;
    var create_at_pegawai:String;
    var update_at_pegawai:String;
    var delete_at_pegawai:String;
    
    init(json: [String:Any]) {
        self.id_pegawai = json["ID_PEGAWAI"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.tgl_lahir_pegawai = json["TGL_LAHIR_PEGAWAI"] as? String ?? ""
        self.phone_pegawai = json["PHONE_PEGAWAI"] as? String ?? ""
        self.alamat_pegawai = json["ALAMAT_PEGAWAI"] as? String ?? ""
        self.jabatan = json["JABATAN"] as? String ?? ""
        self.password = json["PASSWORD"] as? String ?? ""
        self.create_at_pegawai = json["CREATE_AT_PEGAWAI"] as? String ?? ""
        self.update_at_pegawai = json["UPDATE_AT_PEGAWAI"] as? String ?? ""
        self.delete_at_pegawai = json["DELETE_AT_PEGAWAI"] as? String ?? ""
        }
    
    /*init(id_pegawai: String, nama_pegawai: String, tgl_lahir_pegawai: String, phone_pegawai: String,  alamat_pegawai: String, jabatan: String, password: String, create_at_pegawai: String, update_at_pegawai: String, delete_at_pegawai: String) {
        self.id_pegawai = id_pegawai
        self.nama_pegawai = nama_pegawai;
        self.tgl_lahir_pegawai = tgl_lahir_pegawai;
        self.phone_pegawai = phone_pegawai;
        self.alamat_pegawai = alamat_pegawai;
        self.jabatan = jabatan;
        self.password = password;
        self.create_at_pegawai = create_at_pegawai;
        self.update_at_pegawai = update_at_pegawai;
        self.delete_at_pegawai = delete_at_pegawai;
    }*/
    
    func printData(){
        print(
            "id_pegawai            : ",self.id_pegawai,
            "nama_pegawai          : ",self.nama_pegawai,
            "tgl_lahir_pegawai     : ",self.tgl_lahir_pegawai,
            "phone_pegawai         : ",self.phone_pegawai,
            "alamat_pegawai        : ",self.alamat_pegawai,
            "jabatan               : ",self.jabatan,
            "password              : ",self.password,
            "create_at_pegawai     : ",self.create_at_pegawai,
            "update_at_pegawai     : ",self.update_at_pegawai,
            "delete_at_pegawai     : ",self.delete_at_pegawai
        )
    }
}
