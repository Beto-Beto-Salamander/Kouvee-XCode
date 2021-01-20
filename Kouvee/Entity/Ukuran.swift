//
//  Ukuran.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Ukuran : NSObject{
    var id_ukuran:String;
    var nama_pegawai:String;
    var ukuran:String;
    var create_at_ukuran:String;
    var update_at_ukuran:String;
    var delete_at_ukuran:String;
    
    init(json: [String:Any]) {
        self.id_ukuran = json["ID_UKURAN"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.ukuran = json["UKURAN"] as? String ?? ""
        self.create_at_ukuran = json["CREATE_AT_UKURAN"] as? String ?? ""
        self.update_at_ukuran = json["UPDATE_AT_UKURAN"] as? String ?? ""
        self.delete_at_ukuran = json["DELETE_AT_UKURAN"] as? String ?? ""
        
        }
    /*init(id_pegawai: Int, ukuran: String, create_at_ukuran: String, update_at_ukuran: String, delete_at_ukuran: String) {
        self.id_pegawai = id_pegawai;
        self.ukuran = ukuran;
        self.create_at_ukuran = create_at_ukuran;
        self.update_at_ukuran = update_at_ukuran;
        self.delete_at_ukuran = delete_at_ukuran;
    }*/
    
    func printData(){
        print(
            "id_ukuran           : ",self.id_ukuran,
            "ukuran              : ",self.ukuran,
            "nama_pegawai        : ",self.nama_pegawai,
            "create_at_ukuran    : ",self.create_at_ukuran,
            "update_at_ukuran    : ",self.update_at_ukuran,
            "delete_at_ukuran    : ",self.delete_at_ukuran
        )
    }
}
