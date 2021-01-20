//
//  File.swift
//  Kouvee
//
//  Created by Ryan Octavius on 17/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import Foundation
import UIKit
class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 210.0 / 255.0, green: 180.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
