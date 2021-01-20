//
//  ViewPelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewPelanggan: UIViewController {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    var urlDelete = "http://www.kouvee.xyz/index.php/Pelanggan/"
    
    @IBAction func opsi(_ sender: Any) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "EditPelangganSegue", sender: Any?.self)
            }))
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
                print("Hapus")
                let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                    self.delete(urlDel: self.urlDelete + self.Pelanggans!.id_pelanggan)
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
        @IBOutlet weak var labelTanggal: UILabel!
        @IBOutlet weak var labelID: UILabel!
    
        var Pelanggans : Pelanggan?
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addShadowView(v: v)
           
            labelNama.text = Pelanggans?.nama_pelanggan
            labelNamaPeg.text = Pelanggans?.nama_pegawai
            labelAlamat.text = Pelanggans?.alamat_pelanggan
            labelNomor.text = Pelanggans?.phone_pelanggan
            labelTanggal.text = Pelanggans?.tgl_lahir_pelanggan
            labelCreate.text = Pelanggans?.create_at_pelanggan
            labelUpdate.text = Pelanggans?.update_at_pelanggan
            labelDelete.text = Pelanggans?.delete_at_pelanggan
            labelID.text = Pelanggans!.id_pelanggan
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
            if segue.identifier == "EditPelangganSegue"{
                guard let VC = segue.destination as? EditPelanggan else {return}
                VC.Pelanggans = self.Pelanggans
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
