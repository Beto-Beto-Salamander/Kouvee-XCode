//
//  RespErr.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
class RespErr{
    var Err : String?
    
    init(json: [String:Any]) {
        self.Err = json["Error"] as? String ?? ""
    }
}
