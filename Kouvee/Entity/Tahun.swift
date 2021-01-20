//
//  Tahun.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class Tahun : NSObject{
    var thn:String;
    
    init(json: [String:Any]) {
        self.thn = json["Tahun"] as? String ?? ""
        }
    /*init(id_pegawai: Int, ukuran: String, create_at_ukuran: String, update_at_ukuran: String, delete_at_ukuran: String) {
        self.id_pegawai = id_pegawai;
        self.ukuran = ukuran;
        self.create_at_ukuran = create_at_ukuran;
        self.update_at_ukuran = update_at_ukuran;
        self.delete_at_ukuran = delete_at_ukuran;
    }*/
}
