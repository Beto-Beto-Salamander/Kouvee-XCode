//
//  ViewSupplier.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewSupplier: UIViewController {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    var urlDelete = "http://www.kouvee.xyz/index.php/Supplier/"
    
    @IBAction func opsi(_ sender: Any) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "EditSupplierSegue", sender: Any?.self)
            }))
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
                print("Hapus")
                let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                    self.delete(urlDel: self.urlDelete + self.Suppliers!.id_supplier)
                }))
                alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: { ACTION in
                    
                }))
                self.present(alert, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler:{ ACTION in
                print("Kembali")
            }))

            self.present(alert, animated: true)
        }
        
        @IBAction func btnBack(_ sender: Any) {
            performSegue(withIdentifier: "back", sender: Any?.self)
        }
        
        @IBOutlet weak var v: UIView!
        @IBOutlet weak var labelDelete: UILabel!
        @IBOutlet weak var labelUpdate: UILabel!
        @IBOutlet weak var labelCreate: UILabel!
        @IBOutlet weak var labelAlamat: UILabel!
        @IBOutlet weak var labelNamaPeg: UILabel!
        @IBOutlet weak var labelNama: UILabel!
        @IBOutlet weak var labelNomor: UILabel!
        @IBOutlet weak var labelID: UILabel!
    
    
        var Suppliers : Supplier?
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addShadowView(v: v)
           
            labelNama.text = Suppliers?.nama_supplier
            labelNamaPeg.text = Suppliers?.nama_pegawai
            labelAlamat.text = Suppliers?.alamat_supplier
            labelNomor.text = Suppliers?.phone_supplier
            labelCreate.text = Suppliers?.create_at_supplier
            labelUpdate.text = Suppliers?.update_at_supplier
            labelDelete.text = Suppliers?.delete_at_supplier
            labelID.text = Suppliers!.id_supplier
            // Do any additional setup after loading the view.
        }
        
        func addShadowView (v : UIView){
            v.layer.cornerRadius = 6
            v.layer.shadowColor = UIColor.lightGray.cgColor
            v.layer.shadowOffset = .zero
            v.layer.shadowOpacity = 0.4
            v.layer.shadowRadius = 9
            v.layer.shouldRasterize = true
            v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        }
        
        func addShadowBtn (b : UIButton){
           
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditSupplierSegue"{
                guard let VC = segue.destination as? EditSupplier else {return}
                VC.Suppliers = self.Suppliers
            }
            else if segue.identifier == "produkAdd"{
                
            }
        }
    
    fileprivate func delete(urlDel : String){
        self.request = Alamofire.request(urlDel, method: .delete, parameters: nil)
            if let request = request as? DataRequest {
                request.responseString { response in
                    do{
                        let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                        let Message = data["Message"] as! String
                        print(data)
                        if Message != "Data Berhasil Di Hapus" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Gagal Menghapus Data", message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                                self.present(alert,animated: true, completion: nil )
                                }
                        }else if Message == "Data Berhasil Di Hapus" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: Message, message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                                    self.performSegue(withIdentifier: "back", sender: Any?.self)
                                }))
                                self.present(alert,animated: true, completion: nil )
                                }
                        }
                    }catch{
                        print(error)
                    }
                }
            }

        }
    }
