//
//  Supplier.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Supplier : NSObject{
    var id_supplier:String;
    var nama_supplier:String;
    var alamat_supplier:String;
    var phone_supplier:String;
    var nama_pegawai:String;
    var create_at_supplier:String;
    var update_at_supplier:String;
    var delete_at_supplier:String;
    
    init(json: [String:Any]) {
        self.id_supplier = json["ID_SUPPLIER"] as? String ?? ""
        self.nama_supplier = json["NAMA_SUPPLIER"] as? String ?? ""
        self.alamat_supplier = json["ALAMAT_SUPPLIER"] as? String ?? ""
        self.phone_supplier = json["PHONE_SUPPLIER"] as? String ?? ""
        self.nama_pegawai = json["NAMA_PEGAWAI"] as? String ?? ""
        self.create_at_supplier = json["CREATE_AT_SUPPLIER"] as? String ?? ""
        self.update_at_supplier = json["UPDATE_AT_SUPPLIER"] as? String ?? ""
        self.delete_at_supplier = json["DELETE_AT_SUPPLIER"] as? String ?? ""
        
    }
    
    /*init(id_pegawai: Int, nama_supplier: String, alamat_supplier: String, phone_supplier: String, create_at_supplier: String, update_at_supplier: String, delete_at_supplier: String) {
        self.id_pegawai = id_pegawai;
        self.nama_supplier = nama_supplier;
        self.alamat_supplier = alamat_supplier;
        self.phone_supplier = phone_supplier;
        self.create_at_supplier = create_at_supplier;
        self.update_at_supplier = update_at_supplier;
        self.delete_at_supplier = delete_at_supplier;
    }*/
    
    func printData(){
        print(
            "id_supplier           : ",self.id_supplier,
            "nama_supplier         : ",self.nama_supplier,
            "alamat_supplier       : ",self.alamat_supplier,
            "phone_supplier        : ",self.phone_supplier,
            "nama_pegawai          : ",self.nama_pegawai,
            "create_at_supplier    : ",self.create_at_supplier,
            "update_at_supplier    : ",self.update_at_supplier,
            "delete_at_supplier    : ",self.delete_at_supplier
        )
    }
}

