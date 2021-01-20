//
//  DataController.swift
//  Kouvee
//
//  Created by Ryan Octavius on 10/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class DataController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var vProduk: UIView!
    @IBOutlet weak var vLayanan: UIView!
    @IBOutlet weak var vUkuran: UIView!
    @IBOutlet weak var vJenis: UIView!
    @IBOutlet weak var vSupplier: UIView!
    
    var id_pegawai  = Info.sharedInstance.id_pegawai
    var nama_pegawai = Info.sharedInstance.nama_pegawai
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id_pegawai)
        addShadow(v: vProduk)
        addShadow(v: vLayanan)
        addShadow(v: vJenis)
        addShadow(v: vUkuran)
        addShadow(v: vSupplier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProduk))
        tapGesture.delegate = self
        self.vProduk.addGestureRecognizer(tapGesture)
        
        
        // Do any additional setup after loading the view.
    }
    
    public func addShadow(v: UIView){
        v.layer.cornerRadius = 10
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
    }
    
    @objc func tapProduk(sender: UIGestureRecognizer){
        performSegue(withIdentifier: "produkAdmin", sender: (Any).self)
        print("clicked")
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
