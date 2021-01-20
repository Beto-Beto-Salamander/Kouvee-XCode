//
//  JenisHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class JenisHewan : NSObject{
    var id_jenishewan:String;
    var nama_pegawai:String;
    var jenishewan:String;
    var create_at_jhewan:String;
    var update_at_jhewan:String;
    var delete_at_jhewan:String;
    
    init(json: [String:Any]) {
        self.id_jenishewan = json["ID_JENISHEWAN"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.jenishewan = json["JENISHEWAN"] as? String ?? ""
        self.create_at_jhewan = json["CREATE_AT_JHEWAN"] as? String ?? ""
        self.update_at_jhewan = json["UPDATE_AT_JHEWAN"] as? String ?? ""
        self.delete_at_jhewan = json["DELETE_AT_JHEWAN"] as? String ?? ""
        
        }
    /*init(id_pegawai: Int, jenishewan: String, create_at_jhewan: String, update_at_jhewan: String, delete_at_jhewan: String) {
        self.id_pegawai = id_pegawai;
        self.jenishewan = jenishewan;
        self.create_at_jhewan = create_at_jhewan;
        self.update_at_jhewan = update_at_jhewan;
        self.delete_at_jhewan = delete_at_jhewan;
    }*/
    
    func printData(){
        print(
            "id_jenishewan       : ",self.id_jenishewan,
            "nama_pegawai        : ",self.nama_pegawai,
            "jenis_hewan         : ",self.jenishewan,
            "create_at_jhewan    : ",self.create_at_jhewan,
            "update_at_jhewan    : ",self.update_at_jhewan,
            "delete_at_jhewan    : ",self.delete_at_jhewan
        )
    }
}
