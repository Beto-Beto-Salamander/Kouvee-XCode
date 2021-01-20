//
//  ViewHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire

class ViewHewan: UIViewController {
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    var urlDelete = "http://www.kouvee.xyz/index.php/Hewan/"
    
    @IBAction func opsi(_ sender: Any) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "EditHewanSegue", sender: Any?.self)
            }))
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
                print("Hapus")
                let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                    self.delete(urlDel: self.urlDelete + self.Hewans!.id_hewan)
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
        @IBOutlet weak var labelJenis: UILabel!
        @IBOutlet weak var labelNamaPeg: UILabel!
        @IBOutlet weak var labelNama: UILabel!
        @IBOutlet weak var labelTanggal: UILabel!
        @IBOutlet weak var labelPelanggan: UILabel!
        @IBOutlet weak var labelID: UILabel!
    
    
        var Hewans : Hewan?
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addShadowView(v: v)
           
            labelNama.text = Hewans?.nama_hewan
            labelNamaPeg.text = Hewans?.nama_pegawai
            labelJenis.text = Hewans?.jenishewan
            labelTanggal.text = Hewans?.tgl_lahir_hewan
            labelCreate.text = Hewans?.create_at_hewan
            labelUpdate.text = Hewans?.update_at_hewan
            labelDelete.text = Hewans?.delete_at_hewan
            labelPelanggan.text = Hewans?.nama_pelanggan
            labelID.text = Hewans!.id_hewan
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
            if segue.identifier == "EditHewanSegue"{
                guard let VC = segue.destination as? EditHewan else {return}
                VC.Hewans = self.Hewans
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
                        if Message != "Data Berhasil Di Ubah" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Gagal Menghapus Data", message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                                self.present(alert,animated: true, completion: nil )
                                }
                        }else if Message == "Data Berhasil Di Ubah" {
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

